import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forgefit/core/database/app_database.dart';
import 'package:forgefit/core/sync/sync_coordinator.dart';
import 'package:forgefit/features/auth/data/auth_repository.dart';
import 'package:forgefit/features/planning/data/offline_first_planning_repository.dart';
import 'package:forgefit/features/planning/data/remote_planning_data_source.dart';
import 'package:forgefit/features/planning/domain/planning_models.dart';
import 'package:forgefit/features/sessions/data/offline_first_session_repository.dart';
import 'package:forgefit/features/sessions/data/remote_session_data_source.dart';
import 'package:forgefit/features/sessions/domain/workout_session_models.dart';
import 'package:forgefit/features/workouts/data/offline_first_workout_repository.dart';
import 'package:forgefit/features/workouts/data/remote_workout_data_source.dart';
import 'package:forgefit/features/workouts/domain/workout_entry.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Scoped at the authenticated app boundary in [ForgeFitApp].
///
/// Riverpod 3 requires every provider that reads this override to explicitly
/// declare its dependency. Without that metadata, a descendant can resolve in
/// the parent scope and use this deliberate fallback instead.
final supabaseClientProvider = Provider<SupabaseClient>(
  (ref) => throw StateError('Supabase is not configured for this widget tree.'),
  dependencies: const [],
  name: 'supabaseClientProvider',
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(supabaseClientProvider)),
  dependencies: [supabaseClientProvider],
  name: 'authRepositoryProvider',
);

final authStateProvider = StreamProvider<AuthState>(
  (ref) => ref.watch(authRepositoryProvider).authStateChanges,
  dependencies: [authRepositoryProvider],
  name: 'authStateProvider',
);

final appDatabaseProvider = Provider<AppDatabase>(
  (ref) {
    final database = AppDatabase();
    ref.onDispose(database.close);
    return database;
  },
  dependencies: const [],
  name: 'appDatabaseProvider',
);

final remoteWorkoutDataSourceProvider =
    Provider<SupabaseRemoteWorkoutDataSource>(
      (ref) =>
          SupabaseRemoteWorkoutDataSource(ref.watch(supabaseClientProvider)),
      dependencies: [supabaseClientProvider],
      name: 'remoteWorkoutDataSourceProvider',
    );

final workoutRepositoryProvider = Provider<OfflineFirstWorkoutRepository>(
  (ref) => OfflineFirstWorkoutRepository(
    database: ref.watch(appDatabaseProvider),
    remote: ref.watch(remoteWorkoutDataSourceProvider),
  ),
  dependencies: [appDatabaseProvider, remoteWorkoutDataSourceProvider],
  name: 'workoutRepositoryProvider',
);

final remotePlanningDataSourceProvider =
    Provider<SupabaseRemotePlanningDataSource>(
      (ref) =>
          SupabaseRemotePlanningDataSource(ref.watch(supabaseClientProvider)),
      dependencies: [supabaseClientProvider],
      name: 'remotePlanningDataSourceProvider',
    );

final planningRepositoryProvider = Provider<OfflineFirstPlanningRepository>(
  (ref) => OfflineFirstPlanningRepository(
    database: ref.watch(appDatabaseProvider),
    remote: ref.watch(remotePlanningDataSourceProvider),
  ),
  dependencies: [appDatabaseProvider, remotePlanningDataSourceProvider],
  name: 'planningRepositoryProvider',
);

final remoteSessionDataSourceProvider = Provider<RemoteSessionDataSource>(
  (ref) => SupabaseRemoteSessionDataSource(ref.watch(supabaseClientProvider)),
  dependencies: [supabaseClientProvider],
  name: 'remoteSessionDataSourceProvider',
);

final sessionRepositoryProvider = Provider<OfflineFirstSessionRepository>(
  (ref) => OfflineFirstSessionRepository(
    database: ref.watch(appDatabaseProvider),
    remote: ref.watch(remoteSessionDataSourceProvider),
  ),
  dependencies: [appDatabaseProvider, remoteSessionDataSourceProvider],
  name: 'sessionRepositoryProvider',
);

final syncCoordinatorProvider = Provider<SyncCoordinator>(
  (ref) {
    final coordinator = SyncCoordinator(
      repository: ref.watch(workoutRepositoryProvider),
      planningRepository: ref.watch(planningRepositoryProvider),
      sessionRepository: ref.watch(sessionRepositoryProvider),
    );
    ref.onDispose(coordinator.dispose);
    return coordinator;
  },
  dependencies: [
    workoutRepositoryProvider,
    planningRepositoryProvider,
    sessionRepositoryProvider,
  ],
  name: 'syncCoordinatorProvider',
);

final syncStatusProvider = StreamProvider<SyncStatus>(
  (ref) async* {
    final coordinator = ref.watch(syncCoordinatorProvider);
    yield coordinator.currentStatus;
    yield* coordinator.statuses;
  },
  dependencies: [syncCoordinatorProvider],
  name: 'syncStatusProvider',
);

final workoutHistoryProvider =
    StreamProvider.family<List<WorkoutEntry>, String>(
      (ref, userId) =>
          ref.watch(workoutRepositoryProvider).watchWorkouts(userId),
      dependencies: [workoutRepositoryProvider],
      name: 'workoutHistoryProvider',
    );

final activeWorkoutProvider =
    StreamProvider.family<ActiveWorkoutBundle?, String>(
      (ref, userId) =>
          ref.watch(sessionRepositoryProvider).watchActiveWorkout(userId),
      dependencies: [sessionRepositoryProvider],
      name: 'activeWorkoutProvider',
    );

final completedWorkoutSessionsProvider =
    StreamProvider.family<List<CompletedWorkoutSession>, String>(
      (ref, userId) =>
          ref.watch(sessionRepositoryProvider).watchCompletedSessions(userId),
      dependencies: [sessionRepositoryProvider],
      name: 'completedWorkoutSessionsProvider',
    );

/// Completed snapshots, including the exercises and sets used by Progress.
/// The source session stream changes after a workout is completed or deleted,
/// so derived progress data refreshes without maintaining a second cache.
final completedWorkoutBundlesProvider =
    StreamProvider.family<List<CompletedWorkoutBundle>, String>(
      (ref, userId) async* {
        final repository = ref.watch(sessionRepositoryProvider);
        await for (final sessions in repository.watchCompletedSessions(
          userId,
        )) {
          final bundles = await Future.wait(
            sessions.map(
              (session) => repository.getCompletedWorkout(
                userId: userId,
                sessionId: session.id,
              ),
            ),
          );
          yield List.unmodifiable(bundles);
        }
      },
      dependencies: [sessionRepositoryProvider],
      name: 'completedWorkoutBundlesProvider',
    );

final personalRecordsProvider =
    StreamProvider.family<List<PersonalRecord>, String>(
      (ref, userId) =>
          ref.watch(sessionRepositoryProvider).watchPersonalRecords(userId),
      dependencies: [sessionRepositoryProvider],
      name: 'personalRecordsProvider',
    );

final workoutSplitsProvider = StreamProvider.family<List<WorkoutSplit>, String>(
  (ref, userId) => ref.watch(planningRepositoryProvider).watchSplits(userId),
  dependencies: [planningRepositoryProvider],
  name: 'workoutSplitsProvider',
);

final workoutTemplatesProvider =
    StreamProvider.family<List<WorkoutTemplate>, String>(
      (ref, userId) =>
          ref.watch(planningRepositoryProvider).watchTemplates(userId),
      dependencies: [planningRepositoryProvider],
      name: 'workoutTemplatesProvider',
    );

final customExercisesProvider =
    StreamProvider.family<List<CustomExercise>, String>(
      (ref, userId) =>
          ref.watch(planningRepositoryProvider).watchCustomExercises(userId),
      dependencies: [planningRepositoryProvider],
      name: 'customExercisesProvider',
    );

typedef TemplateExerciseQuery = ({String userId, String templateId});

final templateExercisesProvider =
    StreamProvider.family<List<TemplateExercise>, TemplateExerciseQuery>(
      (ref, query) => ref
          .watch(planningRepositoryProvider)
          .watchTemplateExercises(query.userId, query.templateId),
      dependencies: [planningRepositoryProvider],
      name: 'templateExercisesProvider',
    );
