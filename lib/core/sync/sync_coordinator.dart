import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../../features/planning/data/offline_first_planning_repository.dart';
import '../../features/sessions/data/offline_first_session_repository.dart';
import '../../features/workouts/data/offline_first_workout_repository.dart';

enum SyncState { everythingSynced, syncing, changesWaiting, syncFailed }

class SyncRetryPolicy {
  const SyncRetryPolicy({
    this.initialDelay = const Duration(seconds: 2),
    this.maximumDelay = const Duration(minutes: 5),
    this.multiplier = 2,
  }) : assert(multiplier >= 2);

  final Duration initialDelay;
  final Duration maximumDelay;
  final int multiplier;

  /// Returns a deterministic capped exponential delay. Failure 1 uses the
  /// initial delay, failure 2 multiplies it once, and so on.
  Duration delayForFailure(int consecutiveFailures) {
    if (initialDelay <= Duration.zero || maximumDelay < initialDelay) {
      throw StateError('Sync retry delays must be positive and ordered.');
    }
    if (consecutiveFailures <= 0) {
      throw ArgumentError.value(
        consecutiveFailures,
        'consecutiveFailures',
        'Must be greater than zero.',
      );
    }

    var milliseconds = initialDelay.inMilliseconds;
    final maximumMilliseconds = maximumDelay.inMilliseconds;
    for (var index = 1; index < consecutiveFailures; index++) {
      if (milliseconds >= maximumMilliseconds ~/ multiplier) {
        return maximumDelay;
      }
      milliseconds *= multiplier;
    }
    return Duration(milliseconds: milliseconds.clamp(0, maximumMilliseconds));
  }
}

abstract interface class ScheduledSyncRetry {
  void cancel();
}

abstract interface class SyncRetryScheduler {
  ScheduledSyncRetry schedule(Duration delay, void Function() callback);
}

class TimerSyncRetryScheduler implements SyncRetryScheduler {
  const TimerSyncRetryScheduler();

  @override
  ScheduledSyncRetry schedule(Duration delay, void Function() callback) {
    return _TimerScheduledSyncRetry(Timer(delay, callback));
  }
}

class _TimerScheduledSyncRetry implements ScheduledSyncRetry {
  _TimerScheduledSyncRetry(this._timer);

  final Timer _timer;

  @override
  void cancel() => _timer.cancel();
}

class SyncStatus {
  const SyncStatus({
    required this.state,
    required this.pendingChanges,
    this.errorMessage,
  });

  const SyncStatus.everythingSynced()
    : state = SyncState.everythingSynced,
      pendingChanges = 0,
      errorMessage = null;

  const SyncStatus.syncing(int pending)
    : state = SyncState.syncing,
      pendingChanges = pending,
      errorMessage = null;

  const SyncStatus.changesWaiting(int pending, [String? error])
    : state = SyncState.changesWaiting,
      pendingChanges = pending,
      errorMessage = error;

  const SyncStatus.syncFailed(int pending, String error)
    : state = SyncState.syncFailed,
      pendingChanges = pending,
      errorMessage = error;

  final SyncState state;
  final int pendingChanges;
  final String? errorMessage;
}

/// Flushes the durable outbox and retries it when connectivity returns.
///
/// Concurrent [sync] calls share one operation, which avoids racing two
/// uploads for the same queue row.
class SyncCoordinator {
  factory SyncCoordinator({
    required OfflineFirstWorkoutRepository repository,
    OfflineFirstPlanningRepository? planningRepository,
    OfflineFirstSessionRepository? sessionRepository,
    Stream<List<ConnectivityResult>>? connectivityChanges,
    SyncRetryPolicy retryPolicy = const SyncRetryPolicy(),
    SyncRetryScheduler retryScheduler = const TimerSyncRetryScheduler(),
  }) => SyncCoordinator._(
    repository,
    planningRepository,
    sessionRepository,
    connectivityChanges,
    retryPolicy,
    retryScheduler,
  );

  SyncCoordinator._(
    this._repository,
    this._planningRepository,
    this._sessionRepository,
    Stream<List<ConnectivityResult>>? connectivityChanges,
    this._retryPolicy,
    this._retryScheduler,
  ) {
    final changes = connectivityChanges ?? Connectivity().onConnectivityChanged;
    _connectivitySubscription = changes.listen(
      _handleConnectivityChange,
      onError: (_) {
        // A connectivity signal is only a retry hint. Failed uploads still
        // remain safely queued and can be retried by the next explicit sync.
      },
    );
  }

  final OfflineFirstWorkoutRepository _repository;
  final OfflineFirstPlanningRepository? _planningRepository;
  final OfflineFirstSessionRepository? _sessionRepository;
  final SyncRetryPolicy _retryPolicy;
  final SyncRetryScheduler _retryScheduler;
  final StreamController<SyncStatus> _statusController =
      StreamController<SyncStatus>.broadcast();
  late final StreamSubscription<List<ConnectivityResult>>
  _connectivitySubscription;

  SyncStatus _status = const SyncStatus.everythingSynced();
  Future<void>? _inFlight;
  String? _lastUserId;
  bool _rerunRequested = false;
  bool _disposed = false;
  int _consecutiveFailures = 0;
  ScheduledSyncRetry? _scheduledRetry;
  Duration? _scheduledRetryDelay;

  SyncStatus get currentStatus => _status;

  int get consecutiveFailures => _consecutiveFailures;

  Duration? get scheduledRetryDelay => _scheduledRetryDelay;

  Stream<SyncStatus> get statuses async* {
    yield _status;
    yield* _statusController.stream;
  }

  Future<void> sync(String userId, {bool forceAfterCurrent = false}) {
    if (_disposed) {
      return Future.error(StateError('SyncCoordinator has been disposed.'));
    }
    final previousUserId = _lastUserId;
    _lastUserId = userId;
    if (previousUserId != null && previousUserId != userId) {
      _consecutiveFailures = 0;
    }
    final running = _inFlight;
    if (running != null) {
      if (previousUserId != userId || forceAfterCurrent) {
        _cancelScheduledRetry();
        _rerunRequested = true;
      }
      return running;
    }
    _cancelScheduledRetry();

    late final Future<void> operation;
    operation = _runUntilSettled(userId).whenComplete(() {
      if (identical(_inFlight, operation)) {
        _inFlight = null;
      }
    });
    _inFlight = operation;
    return operation;
  }

  Future<void> _runUntilSettled(String userId) async {
    var nextUserId = userId;
    do {
      _rerunRequested = false;
      final runningUserId = nextUserId;
      await _runSync(runningUserId);
      nextUserId = _lastUserId ?? runningUserId;
      if (nextUserId != runningUserId) {
        _rerunRequested = true;
      }
    } while (_rerunRequested && !_disposed);
  }

  Future<void> _runSync(String userId) async {
    var pending = 0;
    String? deferredFailure;
    try {
      pending = await _pendingCount(userId);
      if (pending == 0) {
        _markSuccessfulSync();
        _emit(const SyncStatus.everythingSynced());
        return;
      }

      _emit(SyncStatus.changesWaiting(pending));
      _emit(SyncStatus.syncing(pending));
      final uploads = await _repository.pendingUploads(userId);
      for (final upload in uploads) {
        try {
          await _repository.upload(upload);
          await _repository.completeUpload(upload.queueId);
        } catch (error) {
          final message = _readableError(error);
          await _repository.recordUploadFailure(upload.queueId, message);
          pending = await _pendingCount(userId);
          if (_isLikelyNetworkError(error)) {
            _emit(SyncStatus.changesWaiting(pending, message));
            _scheduleRetry(userId);
            return;
          }
          // A permanent failure in the independent Stage 1 queue must not
          // prevent split/template changes from reaching the cloud.
          deferredFailure = message;
          break;
        }

        pending = await _pendingCount(userId);
        if (pending > 0) {
          _emit(SyncStatus.syncing(pending));
        }
      }

      final planningRepository = _planningRepository;
      if (planningRepository != null) {
        final uploads = await planningRepository.pendingUploads(userId);
        for (final upload in uploads) {
          try {
            await planningRepository.upload(upload);
            await planningRepository.completeUpload(
              upload.queueId,
              upload.entityVersion,
            );
          } catch (error) {
            final message = _readableError(error);
            await planningRepository.recordUploadFailure(
              upload.queueId,
              upload.entityVersion,
              message,
            );
            pending = await _pendingCount(userId);
            _emit(
              _isLikelyNetworkError(error)
                  ? SyncStatus.changesWaiting(pending, message)
                  : SyncStatus.syncFailed(pending, message),
            );
            _scheduleRetry(userId);
            return;
          }

          pending = await _pendingCount(userId);
          if (pending > 0) {
            _emit(SyncStatus.syncing(pending));
          }
        }
      }

      final sessionRepository = _sessionRepository;
      if (sessionRepository != null) {
        final uploads = await sessionRepository.pendingUploads(userId);
        for (final upload in uploads) {
          try {
            await sessionRepository.uploadPending(upload);
            await sessionRepository.markUploadSucceeded(upload);
          } catch (error) {
            final message = _readableError(error);
            await sessionRepository.markUploadFailed(upload, error);
            pending = await _pendingCount(userId);
            _emit(
              _isLikelyNetworkError(error)
                  ? SyncStatus.changesWaiting(pending, message)
                  : SyncStatus.syncFailed(pending, message),
            );
            _scheduleRetry(userId);
            return;
          }

          pending = await _pendingCount(userId);
          if (pending > 0) {
            _emit(SyncStatus.syncing(pending));
          }
        }
      }

      pending = await _pendingCount(userId);
      if (deferredFailure case final message?) {
        _emit(SyncStatus.syncFailed(pending, message));
        _scheduleRetry(userId);
      } else if (pending == 0) {
        _markSuccessfulSync();
        _emit(const SyncStatus.everythingSynced());
      } else {
        _emit(SyncStatus.changesWaiting(pending));
        // All uploads captured by this pass succeeded, so remaining work must
        // have arrived or advanced while a request was in flight.
        _rerunRequested = true;
      }
    } catch (error) {
      final message = _readableError(error);
      _emit(
        _isLikelyNetworkError(error)
            ? SyncStatus.changesWaiting(pending, message)
            : SyncStatus.syncFailed(pending, message),
      );
      _scheduleRetry(userId);
    }
  }

  Future<int> _pendingCount(String userId) async {
    final workoutCount = await _repository.pendingCount(userId);
    final planningRepository = _planningRepository;
    final planningCount = planningRepository == null
        ? 0
        : await planningRepository.pendingCount(userId);
    final sessionRepository = _sessionRepository;
    final sessionCount = sessionRepository == null
        ? 0
        : await sessionRepository.pendingUploadCount(userId);
    return workoutCount + planningCount + sessionCount;
  }

  void _handleConnectivityChange(List<ConnectivityResult> results) {
    if (_disposed ||
        results.isEmpty ||
        results.every((result) => result == ConnectivityResult.none)) {
      return;
    }
    final userId = _lastUserId;
    if (userId != null) {
      // A positive connectivity signal supersedes a delayed attempt.
      unawaited(sync(userId, forceAfterCurrent: true));
    }
  }

  void _scheduleRetry(String userId) {
    if (_disposed) return;
    _scheduledRetry?.cancel();
    _consecutiveFailures++;
    final delay = _retryPolicy.delayForFailure(_consecutiveFailures);
    _scheduledRetryDelay = delay;
    _scheduledRetry = _retryScheduler.schedule(delay, () {
      _scheduledRetry = null;
      _scheduledRetryDelay = null;
      if (!_disposed) {
        unawaited(sync(userId, forceAfterCurrent: true));
      }
    });
  }

  void _cancelScheduledRetry() {
    _scheduledRetry?.cancel();
    _scheduledRetry = null;
    _scheduledRetryDelay = null;
  }

  void _markSuccessfulSync() {
    _cancelScheduledRetry();
    _consecutiveFailures = 0;
  }

  void _emit(SyncStatus status) {
    _status = status;
    if (!_disposed) {
      _statusController.add(status);
    }
  }

  void dispose() {
    if (_disposed) {
      return;
    }
    _disposed = true;
    _cancelScheduledRetry();
    unawaited(_connectivitySubscription.cancel());
    unawaited(_statusController.close());
  }
}

String _readableError(Object error) {
  final message = error.toString().trim();
  return message.isEmpty ? 'ForgeFit sync failed. Please try again.' : message;
}

bool _isLikelyNetworkError(Object error) {
  if (error is SocketException || error is TimeoutException) {
    return true;
  }
  final message = error.toString().toLowerCase();
  const networkMarkers = [
    'socketexception',
    'clientexception',
    'failed host lookup',
    'network is unreachable',
    'network request failed',
    'connection refused',
    'connection reset',
    'connection closed',
    'connection aborted',
    'timed out',
    'timeout',
    'offline',
  ];
  return networkMarkers.any(message.contains);
}
