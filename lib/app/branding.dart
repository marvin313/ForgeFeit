import 'package:flutter/material.dart';

class ForgeFitBrand extends StatelessWidget {
  const ForgeFitBrand({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final markSize = compact ? 34.0 : 64.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/branding/forgefit_logo_mark.png',
          width: markSize,
          height: markSize,
          filterQuality: FilterQuality.high,
        ),
        SizedBox(width: compact ? 9 : 16),
        Text(
          'FORGEFIT',
          style: TextStyle(
            color: Colors.white,
            fontSize: compact ? 18 : 34,
            fontWeight: FontWeight.w900,
            letterSpacing: compact ? 0.3 : 1.1,
          ),
        ),
      ],
    );
  }
}
