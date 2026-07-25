import 'package:flutter/material.dart';

import '../../../core/theme/forgefit_theme.dart';
import '../domain/workout_session_models.dart';

/// Groups completed-session UTC instants by a device-local calendar day.
/// [toLocal] is injectable so date boundaries can be tested independently of
/// the host runner's timezone.
class WorkoutCalendarData {
  const WorkoutCalendarData._();

  static Map<DateTime, List<CompletedWorkoutSession>> groupByLocalDay(
    Iterable<CompletedWorkoutSession> sessions, {
    DateTime Function(DateTime value)? toLocal,
  }) {
    final convert = toLocal ?? (DateTime value) => value.toLocal();
    final grouped = <DateTime, List<CompletedWorkoutSession>>{};
    for (final session in sessions.where((item) => !item.isDeleted)) {
      final local = convert(session.endedAt);
      final day = DateTime(local.year, local.month, local.day);
      (grouped[day] ??= <CompletedWorkoutSession>[]).add(session);
    }
    for (final values in grouped.values) {
      values.sort((a, b) => a.endedAt.compareTo(b.endedAt));
    }
    return grouped;
  }
}

class WorkoutCalendar extends StatefulWidget {
  const WorkoutCalendar({
    super.key,
    required this.sessions,
    required this.onOpenSession,
    this.now,
  });

  final List<CompletedWorkoutSession> sessions;
  final ValueChanged<CompletedWorkoutSession> onOpenSession;
  final DateTime? now;

  @override
  State<WorkoutCalendar> createState() => _WorkoutCalendarState();
}

class _WorkoutCalendarState extends State<WorkoutCalendar> {
  late DateTime _month;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    final now = (widget.now ?? DateTime.now()).toLocal();
    _month = DateTime(now.year, now.month);
    _selectedDay = DateTime(now.year, now.month, now.day);
  }

  @override
  Widget build(BuildContext context) {
    final grouped = WorkoutCalendarData.groupByLocalDay(widget.sessions);
    final current = (widget.now ?? DateTime.now()).toLocal();
    final firstWeekday = DateTime(_month.year, _month.month).weekday % 7;
    final days = DateUtils.getDaysInMonth(_month.year, _month.month);
    final cells = <Widget>[
      for (var index = 0; index < firstWeekday; index++) const SizedBox(),
      for (var day = 1; day <= days; day++)
        _dayCell(DateTime(_month.year, _month.month, day), grouped),
    ];
    final selected = _selectedDay == null
        ? const <CompletedWorkoutSession>[]
        : grouped[_selectedDay!] ?? const <CompletedWorkoutSession>[];

    return ListView(
      key: const ValueKey('workout-calendar-view'),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      key: const ValueKey('calendar-previous-month'),
                      tooltip: 'Previous month',
                      onPressed: () => setState(() {
                        _month = DateTime(_month.year, _month.month - 1);
                        _selectedDay = null;
                      }),
                      icon: const Icon(Icons.chevron_left_rounded),
                    ),
                    Expanded(
                      child: Text(
                        MaterialLocalizations.of(
                          context,
                        ).formatMonthYear(_month),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                    IconButton(
                      key: const ValueKey('calendar-current-month'),
                      tooltip: 'Current month',
                      onPressed: () => setState(() {
                        _month = DateTime(current.year, current.month);
                        _selectedDay = DateTime(
                          current.year,
                          current.month,
                          current.day,
                        );
                      }),
                      icon: const Icon(Icons.today_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    for (final label in ['S', 'M', 'T', 'W', 'T', 'F', 'S'])
                      Expanded(
                        child: Text(
                          label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF9099A5),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                GridView.count(
                  crossAxisCount: 7,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1,
                  children: cells,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _selectedDay == null
              ? 'Select a day'
              : MaterialLocalizations.of(
                  context,
                ).formatMediumDate(_selectedDay!),
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),
        if (selected.isEmpty)
          const Text(
            'No completed workouts on this date.',
            style: TextStyle(color: Color(0xFF9099A5)),
          )
        else
          ...selected.map(
            (session) => Card(
              child: ListTile(
                key: ValueKey('calendar-workout-${session.id}'),
                onTap: () => widget.onOpenSession(session),
                leading: Text(
                  '${session.endedAt.toLocal().day}',
                  style: const TextStyle(
                    color: ForgeFitColors.electricBlue,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                title: Text(session.name),
                subtitle: Text(
                  MaterialLocalizations.of(context).formatTimeOfDay(
                    TimeOfDay.fromDateTime(session.endedAt.toLocal()),
                  ),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
              ),
            ),
          ),
      ],
    );
  }

  Widget _dayCell(
    DateTime day,
    Map<DateTime, List<CompletedWorkoutSession>> grouped,
  ) {
    final hasWorkout = grouped.containsKey(day);
    final selected = day == _selectedDay;
    return InkWell(
      key: ValueKey('calendar-day-${day.toIso8601String().split('T').first}'),
      borderRadius: BorderRadius.circular(18),
      onTap: () => setState(() => _selectedDay = day),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: selected
              ? ForgeFitColors.electricBlue.withValues(alpha: 0.22)
              : Colors.transparent,
          shape: BoxShape.circle,
          border: hasWorkout
              ? Border.all(color: ForgeFitColors.electricBlue, width: 1.5)
              : null,
        ),
        child: Center(
          child: Text(
            '${day.day}',
            style: TextStyle(
              fontWeight: hasWorkout ? FontWeight.w900 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
