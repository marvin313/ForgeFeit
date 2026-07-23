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

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  throw StateError('Supabase is not configured for this widget tree.');
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(supabaseClientProvider));
});

final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final remoteWorkoutDataSourceProvider =
    Provider<SupabaseRemoteWorkoutDataSource>((ref) {
      return SupabaseRemoteWorkoutDataSource(ref.watch(supabaseClientProvider));
    });

final workoutRepositoryProvider = Provider<OfflineFirstWorkoutRepository>((
  ref,
) {
  return OfflineFirstWorkoutRepository(
    database: ref.watch(appDatabaseProvider),
    remote: ref.watch(remoteWorkoutDataSourceProvider),
  );
});

final remotePlanningDataSourceProvider =
    Provider<SupabaseRemotePlanningDataSource>((ref) {
      return SupabaseRemotePlanningDataSource(
        ref.watch(supabaseClientProvider),
      );
    });

final planningRepositoryProvider = Provider<OfflineFirstPlanningRepository>((
  ref,
) {
  return OfflineFirstPlanningRepository(
    database: ref.watch(appDatabaseProvider),
    remote: ref.watch(remotePlanningDataSourceProvider),
  );
});

final remoteSessionDataSourceProvider = Provider<RemoteSessionDataSource>((
  ref,
) {
  return SupabaseRemoteSessionDataSource(ref.watch(supabaseClientProvider));
});

final sessionRepositoryProvider = Provider<OfflineFirstSessionRepository>((
  ref,
) {
  return OfflineFirstSessionRepository(
    database: ref.watch(appDatabaseProvider),
    remote: ref.watch(remoteSessionDataSourceProvider),
  );
});

final syncCoordinatorProvider = Provider<SyncCoordinator>((ref) {
  final coordinator = SyncCoordinator(
    repository: ref.watch(workoutRepositoryProvider),
    planningRepository: ref.watch(planningRepositoryProvider),
    sessionRepository: ref.watch(sessionRepositoryProvider),
  );
  ref.onDispose(coordinator.dispose);
  return coordinator;
});

final syncStatusProvider = StreamProvider<SyncStatus>((ref) async* {
  final coordinator = ref.watch(syncCoordinatorProvider);
  yield coordinator.currentStatus;
  yield* coordinator.statuses;
});

final workoutHistoryProvider =
    StreamProvider.family<List<WorkoutEntry>, String>((ref, userId) {
      return ref.watch(workoutRepositoryProvider).watchWorkouts(userId);
    });

final activeWorkoutProvider =
    StreamProvider.family<ActiveWorkoutBundle?, String>((ref, userId) {
      return ref.watch(sessionRepositoryProvider).watchActiveWorkout(userId);
    });

final completedWorkoutSessionsProvider =
    StreamProvider.family<List<CompletedWorkoutSession>, String>((ref, userId) {
      return ref
          .watch(sessionRepositoryProvider)
          .watchCompletedSessions(userId);
    });

final personalRecordsProvider =
    StreamProvider.family<List<PersonalRecord>, String>((ref, userId) {
      return ref.watch(sessionRepositoryProvider).watchPersonalRecords(userId);
    });

final workoutSplitsProvider = StreamProvider.family<List<WorkoutSplit>, String>(
  (ref, userId) {
    return ref.watch(planningRepositoryProvider).watchSplits(userId);
  },
);

final workoutTemplatesProvider =
    StreamProvider.family<List<WorkoutTemplate>, String>((ref, userId) {
      return ref.watch(planningRepositoryProvider).watchTemplates(userId);
    });

final customExercisesProvider =
    StreamProvider.family<List<CustomExercise>, String>((ref, userId) {
      return ref.watch(planningRepositoryProvider).watchCustomExercises(userId);
    });

typedef TemplateExerciseQuery = ({String userId, String templateId});

final templateExercisesProvider =
    StreamProvider.family<List<TemplateExercise>, TemplateExerciseQuery>((
      ref,
      query,
    ) {
      return ref
          .watch(planningRepositoryProvider)
          .watchTemplateExercises(query.userId, query.templateId);
    });
