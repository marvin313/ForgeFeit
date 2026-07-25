import 'package:flutter/material.dart';

class ForgeFitBrand extends StatelessWidget {
  const ForgeFitBrand({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final markSize = compact ? 40.0 : 64.0;
    final accent = Theme.of(context).colorScheme.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: markSize,
          height: markSize,
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(compact ? 13 : 20),
          ),
          child: Icon(
            Icons.fitness_center_rounded,
            color: Theme.of(context).colorScheme.onPrimary,
            size: compact ? 24 : 36,
          ),
        ),
        SizedBox(width: compact ? 12 : 16),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: 'FORGE'),
              TextSpan(
                text: 'FIT',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
          style: TextStyle(
            color: Colors.white,
            fontSize: compact ? 23 : 34,
            fontWeight: FontWeight.w900,
            letterSpacing: compact ? 0.7 : 1.1,
          ),
        ),
      ],
    );
  }
}
