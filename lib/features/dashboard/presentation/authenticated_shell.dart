import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forgefit/app/app_flow.dart';
import 'package:forgefit/app/branding.dart';
import 'package:forgefit/app/providers.dart';
import 'package:forgefit/features/auth/presentation/auth_controller.dart';
import 'package:forgefit/features/auth/presentation/auth_validation.dart';
import 'package:forgefit/features/dashboard/presentation/dashboard_screen.dart';
import 'package:forgefit/features/planning/presentation/start_workout_screen.dart';
import 'package:forgefit/features/planning/presentation/template_editor_screen.dart';
import 'package:forgefit/features/planning/presentation/template_library_screen.dart';
import 'package:forgefit/features/sessions/presentation/active_workout_screen.dart';
import 'package:forgefit/features/sessions/presentation/personal_records_screen.dart';
import 'package:forgefit/features/sessions/presentation/session_history_screen.dart';
import 'package:forgefit/features/workouts/presentation/workout_form_screen.dart';
import 'package:forgefit/features/workouts/presentation/workout_history_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticatedShell extends ConsumerStatefulWidget {
  const AuthenticatedShell({super.key, required this.user});

  final User user;

  @override
  ConsumerState<AuthenticatedShell> createState() => _AuthenticatedShellState();
}

class _AuthenticatedShellState extends ConsumerState<AuthenticatedShell>
    with WidgetsBindingObserver {
  bool _isRecovering = false;
  int _selectedIndex = 0;

  String get _displayName {
    final metadataName = widget.user.userMetadata?['display_name'];
    if (metadataName is String && metadataName.trim().isNotEmpty) {
      return metadataName.trim();
    }
    final emailPrefix = widget.user.email?.split('@').first.trim();
    return emailPrefix?.isNotEmpty == true ? emailPrefix! : 'Athlete';
  }

  String get _weightUnit =>
      widget.user.userMetadata?['preferred_weight_unit'] == 'lb' ? 'lb' : 'kg';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_rememberCompletedOnboarding());
      _restoreAndSync();
    });
  }

  @override
  void didUpdateWidget(AuthenticatedShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.user.id != widget.user.id) {
      _selectedIndex = 0;
      unawaited(_rememberCompletedOnboarding());
      _restoreAndSync();
    }
  }

  Future<void> _rememberCompletedOnboarding() {
    return ref
        .read(appFlowProvider.notifier)
        .rememberAuthenticatedUser(
          displayName: _displayName,
          preferredWeightUnit: WeightUnit.fromValue(_weightUnit),
        );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _restoreAndSync();
    }
  }

  Future<void> _restoreAndSync() async {
    if (_isRecovering || !mounted) return;
    _isRecovering = true;
    final userId = widget.user.id;

    try {
      try {
        await ref.read(authRepositoryProvider).ensureProfile(user: widget.user);
      } on Object {
        // Profile creation is retried at the next authenticated sync trigger.
      }
      try {
        await ref.read(workoutRepositoryProvider).restore(userId);
      } on Object {
        // Offline startup must still render locally stored workout history.
      }
      try {
        await ref.read(planningRepositoryProvider).restore(userId);
      } on Object {
        // Splits and templates remain available from SQLite while offline.
      }
      try {
        await ref.read(sessionRepositoryProvider).restoreFromCloud(userId);
      } on Object {
        // Active and completed sessions remain recoverable from local SQLite.
      }
      await ref.read(syncCoordinatorProvider).sync(userId);
    } on Object {
      // SyncCoordinator publishes a visible failure/pending status.
    } finally {
      _isRecovering = false;
    }
  }

  Future<void> _openStartWorkout() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) =>
            StartWorkoutScreen(userId: widget.user.id, weightUnit: _weightUnit),
      ),
    );
  }

  Future<void> _openActiveWorkout() async {
    final active = await ref
        .read(sessionRepositoryProvider)
        .getActiveWorkout(widget.user.id);
    if (!mounted) return;
    if (active == null) {
      await _openStartWorkout();
      return;
    }
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => ActiveWorkoutScreen(
          userId: widget.user.id,
          weightUnit: _weightUnit,
          repository: ref.read(sessionRepositoryProvider),
          onLocalChangeQueued: _requestSessionSync,
        ),
      ),
    );
  }

  Future<void> _openPersonalRecords() => Navigator.of(context).push<void>(
    MaterialPageRoute(
      builder: (_) => PersonalRecordsScreen(
        userId: widget.user.id,
        weightUnit: _weightUnit,
        repository: ref.read(sessionRepositoryProvider),
        onSyncRequested: _requestSessionSync,
      ),
    ),
  );

  Future<void> _openLegacyHistory() => Navigator.of(context).push<void>(
    MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Legacy Quick Logs')),
        body: WorkoutHistoryScreen(
          userId: widget.user.id,
          weightUnit: _weightUnit,
          onAddWorkout: _openWorkoutForm,
        ),
      ),
    ),
  );

  void _requestSessionSync() {
    unawaited(
      ref
          .read(syncCoordinatorProvider)
          .sync(widget.user.id, forceAfterCurrent: true),
    );
  }

  Future<void> _openTemplateEditor() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => TemplateEditorScreen(userId: widget.user.id),
      ),
    );
  }

  Future<void> _openWorkoutForm() async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) =>
            WorkoutFormScreen(userId: widget.user.id, weightUnit: _weightUnit),
      ),
    );
    if (saved == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Workout saved on this device. Sync will continue automatically.',
          ),
        ),
      );
    }
  }

  Future<void> _logout() async {
    final shouldLogout =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Log out of ForgeFit?'),
            content: const Text(
              'Your cloud workouts will be restored after you log in again. Any locally saved pending changes remain queued on this device.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Log out'),
              ),
            ],
          ),
        ) ??
        false;
    if (!shouldLogout || !mounted) return;

    try {
      await _rememberCompletedOnboarding();
      // Select authentication before Supabase emits signedOut so the gate can
      // never flash onboarding between the auth event and this method return.
      ref.read(appFlowProvider.notifier).showLogin();
      await ref.read(authControllerProvider.notifier).logout();
    } on Object catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(describeAuthError(error))));
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final legacyWorkouts =
        ref.watch(workoutHistoryProvider(widget.user.id)).asData?.value ??
        const [];
    final pages = [
      DashboardScreen(
        userId: widget.user.id,
        displayName: _displayName,
        weightUnit: _weightUnit,
        onStartWorkout: _openStartWorkout,
        onContinueWorkout: _openActiveWorkout,
        onQuickLog: _openWorkoutForm,
        onShowTemplates: () => setState(() => _selectedIndex = 1),
        onShowHistory: () => setState(() => _selectedIndex = 2),
        onShowPersonalRecords: _openPersonalRecords,
      ),
      TemplateLibraryScreen(userId: widget.user.id),
      SessionHistoryScreen(
        userId: widget.user.id,
        weightUnit: _weightUnit,
        repository: ref.watch(sessionRepositoryProvider),
        legacyQuickLogs: legacyWorkouts,
        onOpenLegacyQuickLog: (_) => unawaited(_openLegacyHistory()),
        onStartWorkout: _openStartWorkout,
        onLocalChangeQueued: _requestSessionSync,
        embedded: true,
      ),
    ];

    final floatingAction = switch (_selectedIndex) {
      0 => (
        icon: Icons.play_arrow_rounded,
        label: 'Start workout',
        action: _openStartWorkout,
      ),
      1 => (
        icon: Icons.add_rounded,
        label: 'Create template',
        action: _openTemplateEditor,
      ),
      _ => (
        icon: Icons.add_rounded,
        label: 'Quick log',
        action: _openWorkoutForm,
      ),
    };

    return Scaffold(
      appBar: AppBar(
        title: const ForgeFitBrand(compact: true),
        actions: [
          IconButton(
            tooltip: 'Retry sync',
            onPressed: _restoreAndSync,
            icon: const Icon(Icons.sync_rounded),
          ),
          IconButton(
            tooltip: 'Log out',
            onPressed: ref.watch(authControllerProvider).isLoading
                ? null
                : _logout,
            icon: const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: pages),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: floatingAction.action,
        icon: Icon(floatingAction.icon),
        label: Text(floatingAction.label),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.view_list_outlined),
            selectedIcon: Icon(Icons.view_list_rounded),
            label: 'Templates',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history_rounded),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
