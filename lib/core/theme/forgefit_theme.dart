import 'package:flutter/material.dart';

abstract final class ForgeFitColors {
  static const background = Color(0xFF0D0F12);
  static const navigation = Color(0xFF101216);
  static const surface = Color(0xFF1A1D22);
  static const surfaceHigh = Color(0xFF24282E);
  static const field = Color(0xFF171A1F);
  static const textPrimary = Color(0xFFF1F3F5);
  static const textSecondary = Color(0xFFA9AFB7);
  static const textTertiary = Color(0xFF747B85);
  static const border = Color(0xFF2A2F36);
  static const success = Color(0xFF64C678);
  static const warning = Color(0xFFF3B24A);
  static const danger = Color(0xFFFF6B78);

  /// Legacy visual default retained for screens that have not yet reached a
  /// BuildContext. The live app accent always comes from ColorScheme.primary.
  static const electricBlue = Color(0xFF9AC7AB);
}

class ForgeFitAccent {
  const ForgeFitAccent._();

  static Color resolve(Color selected) {
    var hsl = HSLColor.fromColor(selected);
    if (hsl.saturation < 0.14) hsl = hsl.withSaturation(0.32);
    if (hsl.lightness < 0.30) hsl = hsl.withLightness(0.56);
    if (hsl.lightness > 0.82) hsl = hsl.withLightness(0.70);
    return hsl.toColor();
  }

  static Color foreground(Color accent) =>
      ThemeData.estimateBrightnessForColor(accent) == Brightness.light
      ? Colors.black
      : Colors.white;
}

ThemeData buildForgeFitTheme({Color accent = ForgeFitColors.electricBlue}) {
  final primary = ForgeFitAccent.resolve(accent);
  final onPrimary = ForgeFitAccent.foreground(primary);
  final colorScheme = ColorScheme.dark(
    primary: primary,
    onPrimary: onPrimary,
    primaryContainer: primary.withValues(alpha: 0.18),
    onPrimaryContainer: ForgeFitColors.textPrimary,
    secondary: primary,
    onSecondary: onPrimary,
    error: ForgeFitColors.danger,
    onError: Colors.black,
    surface: ForgeFitColors.surface,
    onSurface: ForgeFitColors.textPrimary,
    outline: ForgeFitColors.border,
    outlineVariant: const Color(0xFF20242A),
  );
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: ForgeFitColors.background,
    fontFamily: 'sans-serif',
  );
  final mutedLabel = WidgetStateProperty.resolveWith<TextStyle?>((states) {
    final selected = states.contains(WidgetState.selected);
    return TextStyle(
      color: selected ? primary : ForgeFitColors.textTertiary,
      fontSize: 11,
      fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
    );
  });
  final textTheme = base.textTheme.copyWith(
    headlineSmall: base.textTheme.headlineSmall?.copyWith(
      color: ForgeFitColors.textPrimary,
      fontSize: 26,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.4,
    ),
    titleLarge: base.textTheme.titleLarge?.copyWith(
      color: ForgeFitColors.textPrimary,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.2,
    ),
    titleMedium: base.textTheme.titleMedium?.copyWith(
      color: ForgeFitColors.textPrimary,
      fontWeight: FontWeight.w700,
    ),
    bodyMedium: base.textTheme.bodyMedium?.copyWith(
      color: ForgeFitColors.textSecondary,
      height: 1.35,
    ),
    labelMedium: base.textTheme.labelMedium?.copyWith(
      color: ForgeFitColors.textSecondary,
      fontWeight: FontWeight.w700,
    ),
  );

  return base.copyWith(
    textTheme: textTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: ForgeFitColors.background,
      foregroundColor: ForgeFitColors.textPrimary,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: ForgeFitColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
    ),
    cardTheme: CardThemeData(
      color: ForgeFitColors.surface,
      surfaceTintColor: Colors.transparent,
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: ForgeFitColors.border),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ForgeFitColors.field,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      labelStyle: const TextStyle(color: ForgeFitColors.textSecondary),
      hintStyle: const TextStyle(color: ForgeFitColors.textTertiary),
      border: _inputBorder(ForgeFitColors.border),
      enabledBorder: _inputBorder(ForgeFitColors.border),
      focusedBorder: _inputBorder(primary, width: 1.5),
      errorBorder: _inputBorder(ForgeFitColors.danger),
      focusedErrorBorder: _inputBorder(ForgeFitColors.danger, width: 1.5),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        disabledBackgroundColor: ForgeFitColors.surfaceHigh,
        disabledForegroundColor: ForgeFitColors.textTertiary,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ForgeFitColors.textPrimary,
        minimumSize: const Size.fromHeight(52),
        side: const BorderSide(color: ForgeFitColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: ForgeFitColors.navigation,
      indicatorColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      height: 68,
      labelTextStyle: mutedLabel,
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? primary
              : ForgeFitColors.textTertiary,
          size: 22,
        ),
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: ForgeFitColors.surfaceHigh,
      selectedColor: primary.withValues(alpha: 0.20),
      secondarySelectedColor: primary.withValues(alpha: 0.20),
      side: const BorderSide(color: ForgeFitColors.border),
      selectedShadowColor: Colors.transparent,
      labelStyle: const TextStyle(
        color: ForgeFitColors.textSecondary,
        fontWeight: FontWeight.w700,
      ),
      secondaryLabelStyle: TextStyle(
        color: primary,
        fontWeight: FontWeight.w800,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: primary,
      unselectedLabelColor: ForgeFitColors.textTertiary,
      indicatorColor: primary,
      labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: ForgeFitColors.surfaceHigh,
      contentTextStyle: const TextStyle(color: ForgeFitColors.textPrimary),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    dividerTheme: const DividerThemeData(color: ForgeFitColors.border),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: primary),
  );
}

OutlineInputBorder _inputBorder(Color color, {double width = 1}) =>
    OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );
