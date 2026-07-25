import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forgefit/app/providers.dart';
import 'package:forgefit/core/sync/sync_coordinator.dart';
import 'package:forgefit/features/data_tools/data/data_management_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class DataManagementScreen extends ConsumerStatefulWidget {
  const DataManagementScreen({super.key, required this.userId});

  final String userId;

  @override
  ConsumerState<DataManagementScreen> createState() =>
      _DataManagementScreenState();
}

class _DataManagementScreenState extends ConsumerState<DataManagementScreen> {
  String? _running;

  bool get _isBusy => _running != null;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Data Management')),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        Text(
          'Keep a portable copy of your ForgeFit data, restore it safely, or export completed workout sets for a spreadsheet.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 20),
        _ActionCard(
          icon: Icons.sync_rounded,
          title: 'Sync Now',
          detail: 'Upload pending changes and refresh from your account.',
          busy: _running == 'sync',
          onTap: _isBusy ? null : _syncNow,
        ),
        _ActionCard(
          icon: Icons.backup_outlined,
          title: 'Export JSON Backup',
          detail:
              'A complete local backup, including templates and workout history.',
          busy: _running == 'backup',
          onTap: _isBusy ? null : _exportBackup,
        ),
        _ActionCard(
          icon: Icons.restore_page_outlined,
          title: 'Restore JSON Backup',
          detail: 'Replace this device’s local ForgeFit data from a backup.',
          busy: _running == 'restore',
          destructive: true,
          onTap: _isBusy ? null : _restoreBackup,
        ),
        _ActionCard(
          icon: Icons.table_chart_outlined,
          title: 'Export Workout CSV',
          detail: 'One completed set per row for spreadsheet analysis.',
          busy: _running == 'csv',
          onTap: _isBusy ? null : _exportCsv,
        ),
      ],
    ),
  );

  Future<void> _exportBackup() => _run('backup', () async {
    final file = await ref
        .read(dataManagementServiceProvider)
        .createJsonBackup(widget.userId);
    await _share(file, 'ForgeFit backup');
    _message('Backup ready to save or share.');
  });

  Future<void> _exportCsv() => _run('csv', () async {
    final file = await ref
        .read(dataManagementServiceProvider)
        .createWorkoutCsv(widget.userId);
    await _share(file, 'ForgeFit workout history');
    _message('CSV export ready to save or share.');
  });

  Future<void> _restoreBackup() async {
    final selection = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['json'],
      withData: true,
    );
    if (selection == null || selection.files.isEmpty || !mounted) return;
    final file = selection.files.single;
    List<int>? bytes = file.bytes;
    if (bytes == null && file.path != null) {
      bytes = await File(file.path!).readAsBytes();
    }
    if (!mounted) return;
    if (bytes == null) {
      _message('ForgeFit could not read that backup file.', error: true);
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Replace local ForgeFit data?'),
        content: const Text(
          'This replaces all local workouts, templates, exercises, and history on this device with the backup. This cannot be undone on this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Replace data'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await _run('restore', () async {
      await ref
          .read(dataManagementServiceProvider)
          .restoreJsonBackup(
            userId: widget.userId,
            jsonText: utf8.decode(bytes!, allowMalformed: false),
          );
      _refreshData();
      _message(
        'Backup restored. Use Sync Now when you are ready to reconcile cloud data.',
      );
    });
  }

  Future<void> _syncNow() => _run('sync', () async {
    final coordinator = ref.read(syncCoordinatorProvider);
    await coordinator.sync(widget.userId, forceAfterCurrent: true);
    final initial = coordinator.currentStatus;
    if (initial.state == SyncState.syncFailed ||
        initial.state == SyncState.changesWaiting) {
      _message(_syncMessage(initial), error: true);
      return;
    }
    try {
      await ref.read(workoutRepositoryProvider).restore(widget.userId);
      await ref.read(planningRepositoryProvider).restore(widget.userId);
      await ref.read(sessionRepositoryProvider).restoreFromCloud(widget.userId);
    } on Object {
      _refreshData();
      _message(
        'Sync partially completed. Local changes are safe; try again when online.',
        error: true,
      );
      return;
    }
    await coordinator.sync(widget.userId, forceAfterCurrent: true);
    _refreshData();
    final status = coordinator.currentStatus;
    _message(
      _syncMessage(status),
      error: status.state != SyncState.everythingSynced,
    );
  });

  String _syncMessage(SyncStatus status) => switch (status.state) {
    SyncState.everythingSynced => 'Sync complete.',
    SyncState.syncing => 'Sync is still running.',
    SyncState.changesWaiting =>
      status.pendingChanges == 0
          ? 'Nothing to sync.'
          : 'Partially synced: ${status.pendingChanges} changes remain queued.',
    SyncState.syncFailed =>
      'Sync failed: ${status.errorMessage ?? 'try again later'}',
  };

  Future<void> _share(DataExportFile export, String subject) async {
    final directory = await getTemporaryDirectory();
    final output = File(
      '${directory.path}${Platform.pathSeparator}${export.filename}',
    );
    await output.writeAsBytes(export.bytes, flush: true);
    await SharePlus.instance.share(
      ShareParams(files: [XFile(output.path)], subject: subject),
    );
  }

  Future<void> _run(String operation, Future<void> Function() action) async {
    setState(() => _running = operation);
    try {
      await action();
    } on DataManagementException catch (error) {
      _message(error.message, error: true);
    } on FormatException {
      _message('That file is not a valid UTF-8 ForgeFit backup.', error: true);
    } on Object {
      _message(
        'This action could not be completed. Your local data was not changed.',
        error: true,
      );
    } finally {
      if (mounted) setState(() => _running = null);
    }
  }

  void _refreshData() {
    ref.invalidate(workoutHistoryProvider(widget.userId));
    ref.invalidate(completedWorkoutSessionsProvider(widget.userId));
    ref.invalidate(completedWorkoutBundlesProvider(widget.userId));
    ref.invalidate(workoutSplitsProvider(widget.userId));
    ref.invalidate(workoutTemplatesProvider(widget.userId));
    ref.invalidate(customExercisesProvider(widget.userId));
    ref.invalidate(activeWorkoutProvider(widget.userId));
    ref.invalidate(personalRecordsProvider(widget.userId));
  }

  void _message(String text, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: error ? Theme.of(context).colorScheme.error : null,
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.detail,
    required this.busy,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final String detail;
  final bool busy;
  final VoidCallback? onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: ListTile(
      enabled: onTap != null,
      onTap: onTap,
      leading: busy
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(
              icon,
              color: destructive ? Theme.of(context).colorScheme.error : null,
            ),
      title: Text(title),
      subtitle: Text(detail),
      trailing: const Icon(Icons.chevron_right_rounded),
    ),
  );
}
