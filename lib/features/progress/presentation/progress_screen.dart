import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forgefit/app/providers.dart';
import 'package:forgefit/core/theme/forgefit_theme.dart';
import 'package:forgefit/features/planning/domain/planning_models.dart';
import 'package:forgefit/features/progress/domain/progress_calculations.dart';
import 'package:forgefit/features/sessions/domain/workout_session_models.dart';
import 'package:intl/intl.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({
    super.key,
    required this.userId,
    required this.weightUnit,
  });

  final String userId;
  final String weightUnit;

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  ProgressTimeRange _range = ProgressTimeRange.threeMonths;
  String? _exerciseKey;

  @override
  Widget build(BuildContext context) {
    final bundles = ref.watch(completedWorkoutBundlesProvider(widget.userId));
    final templates = ref.watch(workoutTemplatesProvider(widget.userId));
    final splits = ref.watch(workoutSplitsProvider(widget.userId));
    final splitNames = _splitNames(
      templates.asData?.value ?? const [],
      splits.asData?.value ?? const [],
    );
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Progress'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Exercise'),
              Tab(text: 'Overview'),
              Tab(text: 'Records'),
            ],
          ),
        ),
        body: bundles.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => _RetryState(
            onRetry: () =>
                ref.invalidate(completedWorkoutBundlesProvider(widget.userId)),
          ),
          data: (allBundles) {
            final range = progressDateRange(_range, DateTime.now());
            final filtered = ProgressCalculator.completedInRange(
              allBundles,
              range,
            );
            final options = ProgressCalculator.exerciseOptions(allBundles);
            final selected = options.any((option) => option.key == _exerciseKey)
                ? _exerciseKey
                : options.firstOrNull?.key;
            final records = ProgressCalculator.personalRecords(allBundles);
            return TabBarView(
              children: [
                _ExerciseTab(
                  range: _range,
                  onRangeChanged: _setRange,
                  options: options,
                  selectedKey: selected,
                  onExerciseChanged: (value) =>
                      setState(() => _exerciseKey = value),
                  bundles: filtered,
                  records: records,
                  weightUnit: widget.weightUnit,
                ),
                _OverviewTab(
                  range: _range,
                  onRangeChanged: _setRange,
                  bundles: filtered,
                  allBundles: allBundles,
                  splitNames: splitNames,
                  weightUnit: widget.weightUnit,
                ),
                _RecordsTab(records: records, weightUnit: widget.weightUnit),
              ],
            );
          },
        ),
      ),
    );
  }

  void _setRange(ProgressTimeRange value) => setState(() => _range = value);
}

Map<String, String> _splitNames(
  List<WorkoutTemplate> templates,
  List<WorkoutSplit> splits,
) {
  final splitById = {for (final split in splits) split.id: split.name};
  return {
    for (final template in templates)
      template.id: template.splitId == null
          ? 'No split'
          : splitById[template.splitId!] ?? 'No split',
  };
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({
    required this.range,
    required this.onRangeChanged,
    required this.bundles,
    required this.allBundles,
    required this.splitNames,
    required this.weightUnit,
  });

  final ProgressTimeRange range;
  final ValueChanged<ProgressTimeRange> onRangeChanged;
  final List<CompletedWorkoutBundle> bundles;
  final List<CompletedWorkoutBundle> allBundles;
  final Map<String, String> splitNames;
  final String weightUnit;

  @override
  Widget build(BuildContext context) {
    final consistency = ProgressCalculator.consistency(
      allBundles: allBundles,
      filteredBundles: bundles,
      now: DateTime.now(),
      splitNameByTemplateId: splitNames,
    );
    final perWorkout = ProgressCalculator.trainingVolume(
      bundles: bundles,
      grouping: ProgressVolumeGrouping.workout,
    );
    final weekly = ProgressCalculator.trainingVolume(
      bundles: bundles,
      grouping: ProgressVolumeGrouping.week,
    );
    final monthly = ProgressCalculator.trainingVolume(
      bundles: bundles,
      grouping: ProgressVolumeGrouping.month,
    );
    return _ScrollableTab(
      children: [
        _RangeFilter(value: range, onChanged: onRangeChanged),
        if (bundles.isEmpty)
          const _EmptyProgress(
            title: 'No completed workouts in this range',
            detail: 'Finish a workout to start building useful progress data.',
          )
        else ...[
          const _SectionTitle('Consistency'),
          _MetricGrid(
            values: [
              _MetricValue('Workouts', '${consistency.workoutsCompleted}'),
              _MetricValue(
                'Average / week',
                consistency.averageWorkoutsPerWeek.toStringAsFixed(1),
              ),
              _MetricValue(
                'Working sets',
                '${consistency.completedWorkingSets}',
              ),
              _MetricValue(
                'Completed reps',
                '${consistency.completedRepetitions}',
              ),
              _MetricValue(
                'Current streak',
                '${consistency.currentStreakDays} days',
              ),
              _MetricValue(
                'Longest streak',
                '${consistency.longestStreakDays} days',
              ),
            ],
          ),
          const SizedBox(height: 24),
          const _SectionTitle('Volume per workout'),
          _ProgressBarChart(points: perWorkout, unit: weightUnit),
          const SizedBox(height: 24),
          const _SectionTitle('Weekly volume'),
          _ProgressBarChart(points: weekly, unit: weightUnit),
          const SizedBox(height: 24),
          const _SectionTitle('Monthly volume'),
          _ProgressBarChart(points: monthly, unit: weightUnit),
          const SizedBox(height: 24),
          _FrequencyList(
            title: 'Most trained exercises',
            entries: consistency.mostFrequentExercises,
          ),
          const SizedBox(height: 16),
          _FrequencyList(
            title: 'Most used splits',
            entries: consistency.mostFrequentSplits,
          ),
        ],
      ],
    );
  }
}

class _ExerciseTab extends StatelessWidget {
  const _ExerciseTab({
    required this.range,
    required this.onRangeChanged,
    required this.options,
    required this.selectedKey,
    required this.onExerciseChanged,
    required this.bundles,
    required this.records,
    required this.weightUnit,
  });

  final ProgressTimeRange range;
  final ValueChanged<ProgressTimeRange> onRangeChanged;
  final List<ProgressExerciseOption> options;
  final String? selectedKey;
  final ValueChanged<String?> onExerciseChanged;
  final List<CompletedWorkoutBundle> bundles;
  final List<ExercisePersonalRecords> records;
  final String weightUnit;

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) {
      return _ScrollableTab(
        children: [
          _RangeFilter(value: range, onChanged: onRangeChanged),
          const _EmptyProgress(
            title: 'No exercise progress yet',
            detail: 'Complete weighted working sets to see strength progress.',
          ),
        ],
      );
    }
    final points = ProgressCalculator.exerciseWeightProgress(
      bundles: bundles,
      exerciseKey: selectedKey!,
    );
    final record = records
        .where((entry) => entry.exerciseKey == selectedKey)
        .firstOrNull;
    return _ScrollableTab(
      children: [
        _RangeFilter(value: range, onChanged: onRangeChanged),
        DropdownButtonFormField<String>(
          initialValue: selectedKey,
          decoration: const InputDecoration(labelText: 'Exercise'),
          items: options
              .map(
                (option) => DropdownMenuItem(
                  value: option.key,
                  child: Text(option.name, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(growable: false),
          onChanged: onExerciseChanged,
        ),
        const SizedBox(height: 24),
        const _SectionTitle('Weight progress'),
        _WeightProgressSummary(points: points, unit: 'kg'),
        const SizedBox(height: 16),
        _ProgressLineChart(points: points, unit: 'kg'),
        const SizedBox(height: 24),
        _RecordSummary(record: record, weightUnit: weightUnit),
      ],
    );
  }
}

class _RecordsTab extends StatelessWidget {
  const _RecordsTab({required this.records, required this.weightUnit});

  final List<ExercisePersonalRecords> records;
  final String weightUnit;

  @override
  Widget build(BuildContext context) => _ScrollableTab(
    children: [
      const _SectionTitle('Personal records'),
      if (records.isEmpty)
        const _EmptyProgress(
          title: 'No personal records yet',
          detail: 'Records appear after valid completed working sets.',
        )
      else
        ...records.map(
          (record) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _RecordSummary(record: record, weightUnit: weightUnit),
          ),
        ),
    ],
  );
}

class _ScrollableTab extends StatelessWidget {
  const _ScrollableTab({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
    children: children,
  );
}

class _RangeFilter extends StatelessWidget {
  const _RangeFilter({required this.value, required this.onChanged});

  final ProgressTimeRange value;
  final ValueChanged<ProgressTimeRange> onChanged;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ProgressTimeRange.values
            .map(
              (range) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(range.label),
                  selected: range == value,
                  onSelected: (_) => onChanged(range),
                ),
              ),
            )
            .toList(growable: false),
      ),
    ),
  );
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.values});

  final List<_MetricValue> values;

  @override
  Widget build(BuildContext context) => GridView.count(
    crossAxisCount: 2,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    childAspectRatio: 1.9,
    mainAxisSpacing: 10,
    crossAxisSpacing: 10,
    children: values
        .map(
          (value) => DecoratedBox(
            decoration: BoxDecoration(
              color: ForgeFitColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value.label,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value.value,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList(growable: false),
  );
}

class _MetricValue {
  const _MetricValue(this.label, this.value);
  final String label;
  final String value;
}

class _ProgressLineChart extends StatelessWidget {
  const _ProgressLineChart({required this.points, required this.unit});

  final List<ProgressPoint> points;
  final String unit;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return const _ChartEmpty('No valid weighted sets in this range.');
    }
    final maxValue = points.map((point) => point.value).reduce(_max);
    return SizedBox(
      height: 230,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: maxValue == 0 ? 1 : maxValue * 1.15,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (items) => items
                  .map(
                    (item) => LineTooltipItem(
                      '${points[item.x.toInt()].label}\n${_formatMetric(item.y, unit)}',
                      const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
          titlesData: _chartTitles(points),
          lineBarsData: [
            LineChartBarData(
              isCurved: points.length > 2,
              color: ForgeFitColors.electricBlue,
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: ForgeFitColors.electricBlue.withValues(alpha: 0.12),
              ),
              spots: [
                for (var index = 0; index < points.length; index++)
                  FlSpot(index.toDouble(), points[index].value),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressBarChart extends StatelessWidget {
  const _ProgressBarChart({required this.points, required this.unit});

  final List<ProgressPoint> points;
  final String unit;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return const _ChartEmpty('No weighted volume in this range.');
    }
    final maxValue = points.map((point) => point.value).reduce(_max);
    return SizedBox(
      height: 230,
      child: BarChart(
        BarChartData(
          maxY: maxValue == 0 ? 1 : maxValue * 1.15,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, _, rod, _) => BarTooltipItem(
                '${points[group.x].label}\n${_formatMetric(rod.toY, unit)}',
                const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          titlesData: _chartTitles(points),
          barGroups: [
            for (var index = 0; index < points.length; index++)
              BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: points[index].value,
                    color: ForgeFitColors.electricBlue,
                    width: 14,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

FlTitlesData _chartTitles(List<ProgressPoint> points) => FlTitlesData(
  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
  leftTitles: AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      reservedSize: 42,
      getTitlesWidget: (value, _) => Text(
        NumberFormat.compact().format(value),
        style: const TextStyle(fontSize: 10),
      ),
    ),
  ),
  bottomTitles: AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      reservedSize: 28,
      interval: points.length <= 4 ? 1 : (points.length / 4).ceilToDouble(),
      getTitlesWidget: (value, _) {
        final index = value.toInt();
        if (index < 0 || index >= points.length) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            DateFormat('d MMM').format(points[index].date),
            style: const TextStyle(fontSize: 10),
          ),
        );
      },
    ),
  ),
);

class _RecordSummary extends StatelessWidget {
  const _RecordSummary({required this.record, required this.weightUnit});

  final ExercisePersonalRecords? record;
  final String weightUnit;

  @override
  Widget build(BuildContext context) {
    if (record == null) {
      return const _EmptyProgress(
        title: 'No records yet',
        detail: 'Use valid completed working sets to establish a record.',
      );
    }
    final values = <String>[
      if (record!.heaviestWeight != null)
        _recordLabel('Heaviest', record!.heaviestWeight!, weightUnit),
      if (record!.bestRepetitions != null)
        _recordLabel('Best reps', record!.bestRepetitions!, null),
      if (record!.estimatedOneRepMax != null)
        _recordLabel('Est. 1RM', record!.estimatedOneRepMax!, weightUnit),
      if (record!.highestSingleWorkoutVolume != null)
        _recordLabel(
          'Best workout',
          record!.highestSingleWorkoutVolume!,
          weightUnit,
        ),
    ];
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ForgeFitColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              record!.exerciseName,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            if (values.isEmpty)
              const Text(
                'No weight-based record is available for this exercise.',
              )
            else
              ...values.map(
                (value) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(value),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _WeightProgressSummary extends StatelessWidget {
  const _WeightProgressSummary({required this.points, required this.unit});

  final List<ProgressPoint> points;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final summary = ProgressCalculator.weightProgressSummary(points);
    if (summary == null) return const SizedBox.shrink();
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ForgeFitColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Wrap(
          spacing: 18,
          runSpacing: 8,
          children: [
            _SummaryValue(
              'Start',
              _formatMetric(summary.startingWeightKg, unit),
            ),
            _SummaryValue(
              'Latest',
              _formatMetric(summary.latestWeightKg, unit),
            ),
            _SummaryValue('Change', _signedMetric(summary.changeKg, unit)),
            if (summary.changePercentage != null)
              _SummaryValue(
                'Progress',
                '${_signed(summary.changePercentage!)}%',
              ),
          ],
        ),
      ),
    );
  }
}

class _SummaryValue extends StatelessWidget {
  const _SummaryValue(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(label, style: Theme.of(context).textTheme.labelMedium),
      const SizedBox(height: 2),
      Text(
        value,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
      ),
    ],
  );
}

class _FrequencyList extends StatelessWidget {
  const _FrequencyList({required this.title, required this.entries});
  final String title;
  final List<NamedProgressValue> entries;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: ForgeFitColors.surface,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          if (entries.isEmpty)
            const Text('No completed working sets yet.')
          else
            ...entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('${entry.name} — ${entry.value} workouts'),
              ),
            ),
        ],
      ),
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
    ),
  );
}

class _EmptyProgress extends StatelessWidget {
  const _EmptyProgress({required this.title, required this.detail});
  final String title;
  final String detail;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 56),
    child: Column(
      children: [
        const Icon(Icons.insights_outlined, size: 42),
        const SizedBox(height: 12),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(detail, textAlign: TextAlign.center),
      ],
    ),
  );
}

class _ChartEmpty extends StatelessWidget {
  const _ChartEmpty(this.message);
  final String message;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 160,
    child: Center(child: Text(message, textAlign: TextAlign.center)),
  );
}

class _RetryState extends StatelessWidget {
  const _RetryState({required this.onRetry});
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Center(
    child: FilledButton.icon(
      onPressed: onRetry,
      icon: const Icon(Icons.refresh_rounded),
      label: const Text('Retry loading progress'),
    ),
  );
}

double _max(double left, double right) => left > right ? left : right;

String _formatMetric(double value, String unit) =>
    '${NumberFormat.decimalPattern().format(value)} $unit';

String _signedMetric(double value, String unit) => '${_signed(value)} $unit';

String _signed(double value) => value >= 0
    ? '+${NumberFormat.decimalPattern().format(value)}'
    : NumberFormat.decimalPattern().format(value);

String _recordLabel(String label, ProgressSetRecord record, String? unit) {
  final value = unit == null
      ? record.value.toInt().toString()
      : _formatMetric(record.value, unit);
  return '$label $value · ${DateFormat('d MMM y').format(record.achievedAt.toLocal())}';
}
