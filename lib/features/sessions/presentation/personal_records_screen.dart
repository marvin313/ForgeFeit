import 'package:flutter/material.dart';

import '../../../core/theme/forgefit_theme.dart';
import '../../planning/domain/planning_models.dart';
import '../data/offline_first_session_repository.dart';
import '../domain/workout_session_models.dart';
import 'session_ui_widgets.dart';

class PersonalRecordsScreen extends StatefulWidget {
  const PersonalRecordsScreen({
    super.key,
    required this.userId,
    required this.weightUnit,
    required this.repository,
    this.onOpenWorkout,
    this.onSyncRequested,
  });

  final String userId;
  final String weightUnit;
  final OfflineFirstSessionRepository repository;
  final ValueChanged<String>? onOpenWorkout;
  final VoidCallback? onSyncRequested;

  @override
  State<PersonalRecordsScreen> createState() => _PersonalRecordsScreenState();
}

class _PersonalRecordsScreenState extends State<PersonalRecordsScreen> {
  final _search = TextEditingController();
  late Stream<List<PersonalRecord>> _stream;

  @override
  void initState() {
    super.initState();
    _stream = widget.repository.watchPersonalRecords(widget.userId);
    _search.addListener(_changed);
  }

  @override
  void didUpdateWidget(covariant PersonalRecordsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId ||
        oldWidget.repository != widget.repository) {
      _stream = widget.repository.watchPersonalRecords(widget.userId);
    }
  }

  @override
  void dispose() {
    _search
      ..removeListener(_changed)
      ..dispose();
    super.dispose();
  }

  void _changed() => setState(() {});

  void _retry() => setState(
    () => _stream = widget.repository.watchPersonalRecords(widget.userId),
  );

  Future<void> _refresh() async {
    try {
      await widget.repository.restoreFromCloud(widget.userId);
    } finally {
      widget.onSyncRequested?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personal Records')),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: TextField(
                controller: _search,
                decoration: InputDecoration(
                  hintText: 'Search exercises or record types',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _search.text.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Clear search',
                          onPressed: _search.clear,
                          icon: const Icon(Icons.close_rounded),
                        ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<PersonalRecord>>(
                stream: _stream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return SessionErrorState(
                      title: 'Personal records could not be loaded',
                      error: snapshot.error!,
                      onRetry: _retry,
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SessionLoadingState(
                      label: 'Loading personal records…',
                    );
                  }
                  return _buildRecords(snapshot.data ?? const []);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecords(List<PersonalRecord> records) {
    final query = normalizeExerciseSearchText(_search.text);
    final filtered = records.where((record) {
      if (query.isEmpty) return true;
      return normalizeExerciseSearchText(
        '${record.exerciseName} ${record.recordKind.label} ${record.recordScope}',
      ).contains(query);
    }).toList();

    if (filtered.isEmpty) {
      return SessionEmptyState(
        icon: query.isEmpty
            ? Icons.emoji_events_outlined
            : Icons.search_off_rounded,
        title: query.isEmpty
            ? 'No personal records yet'
            : 'No matching records',
        message: query.isEmpty
            ? 'Complete working sets to establish your first records. Warm-up and incomplete sets never count.'
            : 'Try another exercise name or record type.',
      );
    }

    final grouped = <String, List<PersonalRecord>>{};
    for (final record in filtered) {
      grouped.putIfAbsent(record.exerciseKey, () => []).add(record);
    }
    final groups = grouped.values.toList()
      ..sort(
        (a, b) => a.first.exerciseName.toLowerCase().compareTo(
          b.first.exerciseName.toLowerCase(),
        ),
      );

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 30),
        itemCount: groups.length,
        separatorBuilder: (_, _) => const SizedBox(height: 11),
        itemBuilder: (context, index) {
          final group = groups[index]
            ..sort((a, b) => a.recordKind.index.compareTo(b.recordKind.index));
          return _RecordGroupCard(
            records: group,
            weightUnit: widget.weightUnit,
            onOpenWorkout: widget.onOpenWorkout,
          );
        },
      ),
    );
  }
}

class _RecordGroupCard extends StatelessWidget {
  const _RecordGroupCard({
    required this.records,
    required this.weightUnit,
    required this.onOpenWorkout,
  });

  final List<PersonalRecord> records;
  final String weightUnit;
  final ValueChanged<String>? onOpenWorkout;

  @override
  Widget build(BuildContext context) {
    final newest = records.reduce(
      (a, b) => a.achievedAt.isAfter(b.achievedAt) ? a : b,
    );
    return Card(
      child: ExpansionTile(
        shape: const Border(),
        collapsedShape: const Border(),
        leading: Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ForgeFitColors.warning.withValues(alpha: 0.11),
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(
            Icons.emoji_events_rounded,
            color: ForgeFitColors.warning,
          ),
        ),
        title: Text(
          records.first.exerciseName,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        subtitle: Text(
          '${records.length} current record${records.length == 1 ? '' : 's'} • '
          'latest ${SessionFormat.date(newest.achievedAt)}',
        ),
        children: records
            .map(
              (record) => InkWell(
                onTap: onOpenWorkout == null
                    ? null
                    : () => onOpenWorkout!(record.completedSessionId),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 13),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              record.recordKind.label,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              _recordContext(record, weightUnit),
                              style: const TextStyle(
                                color: Color(0xFF909AA6),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _recordValue(record, weightUnit),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      if (onOpenWorkout != null)
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0xFF717B87),
                        ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

String _recordValue(PersonalRecord record, String unit) {
  return switch (record.recordKind) {
    PersonalRecordKind.mostRepsAtWeight => '${record.repetitions ?? 0} reps',
    PersonalRecordKind.heaviestWeight ||
    PersonalRecordKind.estimatedOneRepMax => SessionFormat.weight(
      record.recordValue,
      unit,
    ),
    PersonalRecordKind.setVolume || PersonalRecordKind.exerciseWorkoutVolume =>
      SessionFormat.volumeKg(record.recordValue),
  };
}

String _recordContext(PersonalRecord record, String unit) {
  final context = <String>[SessionFormat.date(record.achievedAt)];
  if (record.recordKind == PersonalRecordKind.mostRepsAtWeight &&
      record.weightKg != null) {
    context.add(SessionFormat.weight(record.weightKg!, unit));
  }
  if (record.recordKind == PersonalRecordKind.estimatedOneRepMax &&
      record.repetitions != null) {
    context.add('${record.repetitions} reps • Epley estimate');
  }
  return context.join(' • ');
}
