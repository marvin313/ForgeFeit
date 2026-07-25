import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forgefit/app/providers.dart';
import 'package:forgefit/core/sync/sync_coordinator.dart';
import 'package:forgefit/core/theme/forgefit_theme.dart';

class SyncStatusChip extends ConsumerWidget {
  const SyncStatusChip({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncStatus = ref.watch(syncStatusProvider);
    return asyncStatus.when(
      loading: () => _StatusPill(
        label: 'Syncing',
        color: Theme.of(context).colorScheme.primary,
        showProgress: true,
      ),
      error: (_, _) => _StatusPill(
        label: 'Sync failed',
        color: ForgeFitColors.danger,
        icon: Icons.cloud_off_outlined,
        onTap: () => ref.read(syncCoordinatorProvider).sync(userId),
      ),
      data: (status) => switch (status.state) {
        SyncState.everythingSynced => const _StatusPill(
          label: 'Everything synced',
          color: ForgeFitColors.success,
          icon: Icons.cloud_done_outlined,
        ),
        SyncState.syncing => _StatusPill(
          label: 'Syncing',
          color: Theme.of(context).colorScheme.primary,
          showProgress: true,
        ),
        SyncState.changesWaiting => _StatusPill(
          label: status.pendingChanges > 0
              ? '${status.pendingChanges} changes waiting to sync'
              : 'Changes waiting to sync',
          color: ForgeFitColors.warning,
          icon: Icons.cloud_queue_outlined,
          onTap: () => ref.read(syncCoordinatorProvider).sync(userId),
        ),
        SyncState.syncFailed => _StatusPill(
          label: 'Sync failed',
          color: ForgeFitColors.danger,
          icon: Icons.cloud_off_outlined,
          tooltip: status.errorMessage,
          onTap: () => ref.read(syncCoordinatorProvider).sync(userId),
        ),
      },
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.color,
    this.icon,
    this.showProgress = false,
    this.tooltip,
    this.onTap,
  });

  final String label;
  final Color color;
  final IconData? icon;
  final bool showProgress;
  final String? tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final pill = Material(
      color: color.withValues(alpha: 0.11),
      borderRadius: BorderRadius.circular(99),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(99),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showProgress)
                SizedBox.square(
                  dimension: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: color,
                  ),
                )
              else
                Icon(icon, size: 16, color: color),
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (tooltip?.isNotEmpty == true) {
      return Tooltip(message: tooltip!, child: pill);
    }
    return pill;
  }
}
