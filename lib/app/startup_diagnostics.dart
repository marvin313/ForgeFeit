import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

/// A safe, user-facing identifier for an otherwise unrenderable startup error.
class StartupFailure {
  const StartupFailure({
    required this.providerName,
    required this.exceptionType,
  });

  final String providerName;
  final String exceptionType;
}

class StartupDiagnostics {
  StartupFailure? _latestProviderFailure;

  StartupFailure? get latestProviderFailure => _latestProviderFailure;

  void recordProviderFailure({
    required String? providerName,
    required Object error,
  }) {
    final underlying = _unwrap(error);
    if (underlying is ProviderException) return;
    _latestProviderFailure ??= StartupFailure(
      providerName: providerName ?? 'applicationProvider',
      exceptionType: underlying.runtimeType.toString(),
    );
  }

  StartupFailure describe(Object error) {
    final providerFailure = _latestProviderFailure;
    if (providerFailure != null) return providerFailure;
    final underlying = _unwrap(error);
    return StartupFailure(
      providerName: 'applicationStartup',
      exceptionType: underlying.runtimeType.toString(),
    );
  }

  Object _unwrap(Object error) {
    var underlying = error;
    while (underlying is ProviderException) {
      underlying = underlying.exception;
    }
    return underlying;
  }
}

final class ForgeFitStartupProviderObserver extends ProviderObserver {
  const ForgeFitStartupProviderObserver(this._diagnostics);

  final StartupDiagnostics _diagnostics;

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    _diagnostics.recordProviderFailure(
      providerName: context.provider.name,
      error: error,
    );
  }
}

final startupDiagnostics = StartupDiagnostics();
final startupProviderObserver = ForgeFitStartupProviderObserver(
  startupDiagnostics,
);
