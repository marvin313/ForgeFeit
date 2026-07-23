import 'package:flutter/material.dart';

abstract final class ForgeFitColors {
  static const background = Color(0xFF090B0E);
  static const surface = Color(0xFF14181D);
  static const surfaceHigh = Color(0xFF1D2229);
  static const electricBlue = Color(0xFF00A8FF);
  static const success = Color(0xFF56D78C);
  static const warning = Color(0xFFFFBF4B);
  static const danger = Color(0xFFFF6B78);
}

ThemeData buildForgeFitTheme() {
  const colorScheme = ColorScheme.dark(
    primary: ForgeFitColors.electricBlue,
    onPrimary: Color(0xFF001D2D),
    secondary: Color(0xFF73D1FF),
    onSecondary: Color(0xFF00263A),
    error: ForgeFitColors.danger,
    onError: Color(0xFF330009),
    surface: ForgeFitColors.surface,
    onSurface: Color(0xFFF5F7FA),
    outline: Color(0xFF424A55),
    outlineVariant: Color(0xFF292F37),
  );

  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: ForgeFitColors.background,
    fontFamily: 'sans-serif',
  );

  return base.copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: ForgeFitColors.background,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: ForgeFitColors.surface,
      surfaceTintColor: Colors.transparent,
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFF242A32)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ForgeFitColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
      labelStyle: const TextStyle(color: Color(0xFFA7AFBA)),
      hintStyle: const TextStyle(color: Color(0xFF69727E)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF303741)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF303741)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: ForgeFitColors.electricBlue,
          width: 1.6,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: ForgeFitColors.danger),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: ForgeFitColors.danger, width: 1.6),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(54),
        side: const BorderSide(color: Color(0xFF39414B)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ForgeFitColors.electricBlue,
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: ForgeFitColors.surface,
      indicatorColor: Color(0xFF073B55),
      surfaceTintColor: Colors.transparent,
      height: 72,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: ForgeFitColors.surfaceHigh,
      contentTextStyle: const TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    dividerTheme: const DividerThemeData(color: Color(0xFF282E36)),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: ForgeFitColors.electricBlue,
    ),
  );
}
