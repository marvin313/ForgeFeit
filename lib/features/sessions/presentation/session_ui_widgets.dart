import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/forgefit_theme.dart';

abstract final class SessionFormat {
  static const poundsPerKilogram = 2.2046226218;

  static String duration(Duration duration) {
    final safe = duration.isNegative ? Duration.zero : duration;
    final hours = safe.inHours;
    final minutes = safe.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = safe.inSeconds.remainder(60).toString().padLeft(2, '0');
    return hours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }

  static String number(num value, {int decimals = 1}) {
    final numeric = value.toDouble();
    return numeric == numeric.roundToDouble()
        ? numeric.toStringAsFixed(0)
        : numeric.toStringAsFixed(decimals);
  }

  static String dateTime(DateTime value) =>
      DateFormat('EEE, d MMM • h:mm a').format(value.toLocal());

  static String date(DateTime value) =>
      DateFormat('EEE, d MMM yyyy').format(value.toLocal());

  static double weightFromKg(double kilograms, String unit) =>
      unit == 'lb' ? kilograms * poundsPerKilogram : kilograms;

  static double weightToKg(double preferredValue, String unit) =>
      unit == 'lb' ? preferredValue / poundsPerKilogram : preferredValue;

  static String weight(double kilograms, String unit) =>
      '${number(weightFromKg(kilograms, unit))} ${unit == 'lb' ? 'lb' : 'kg'}';

  static String volumeKg(double volume) => '${number(volume)} kg volume';
}

class SessionLoadingState extends StatelessWidget {
  const SessionLoadingState({super.key, this.label = 'Loading workout…'});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(label, style: const TextStyle(color: Color(0xFF98A2AE))),
        ],
      ),
    );
  }
}

class SessionErrorState extends StatelessWidget {
  const SessionErrorState({
    super.key,
    required this.title,
    required this.error,
    required this.onRetry,
  });

  final String title;
  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 54,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF98A2AE)),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

class SessionEmptyState extends StatelessWidget {
  const SessionEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 62, color: ForgeFitColors.electricBlue),
              const SizedBox(height: 18),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 9),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF98A2AE), height: 1.45),
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 22),
                FilledButton(onPressed: onAction, child: Text(actionLabel!)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class SessionMetricTile extends StatelessWidget {
  const SessionMetricTile({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.highlight = false,
  });

  final String label;
  final String value;
  final IconData? icon;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: highlight
            ? ForgeFitColors.electricBlue.withValues(alpha: 0.12)
            : ForgeFitColors.surfaceHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlight
              ? ForgeFitColors.electricBlue.withValues(alpha: 0.34)
              : const Color(0xFF29313A),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 19,
              color: highlight
                  ? ForgeFitColors.electricBlue
                  : const Color(0xFFA8B1BC),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xFF8F99A5), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

void showSessionError(BuildContext context, Object error) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(error.toString().replaceFirst('Exception: ', ''))),
    );
}
