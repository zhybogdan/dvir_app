import 'package:flutter/material.dart';

/// App-wide Material 3 theme derived from a single seed color.
///
/// Component defaults (inputs, buttons) are set here so shared `Dv*` widgets
/// stay thin and every screen inherits the same look without re-styling.
class AppTheme {
  const AppTheme._();

  static const Color _seed = Color(0xFF0D9488);

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: brightness,
    );

    final base = ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      fontFamily: 'Inter',
    );

    return base.copyWith(
      scaffoldBackgroundColor: scheme.surface,
      textTheme: _headings(base.textTheme),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        hintStyle: TextStyle(
          color: scheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
        border: _fieldBorder(BorderSide(color: scheme.surfaceContainerHighest)),
        enabledBorder: _fieldBorder(
          BorderSide(color: scheme.surfaceContainerHighest),
        ),
        focusedBorder: _fieldBorder(
          BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: _fieldBorder(BorderSide(color: scheme.error)),
        focusedErrorBorder: _fieldBorder(
          BorderSide(color: scheme.error, width: 2),
        ),
        errorStyle: TextStyle(
          color: scheme.error,
          fontSize: 12,
          height: 1.3,
          fontWeight: FontWeight.w500,
        ),
        helperStyle: const TextStyle(fontSize: 12, height: 1.3),
        errorMaxLines: 1,
        helperMaxLines: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: scheme.primary),
      ),
    );
  }

  /// Heavier weights for titles and headlines; body and label keep the M3
  /// defaults (Regular / Medium) so running text stays comfortable to read.
  static TextTheme _headings(TextTheme base) => base.copyWith(
    displayLarge: base.displayLarge?.copyWith(fontWeight: FontWeight.w700),
    displayMedium: base.displayMedium?.copyWith(fontWeight: FontWeight.w700),
    displaySmall: base.displaySmall?.copyWith(fontWeight: FontWeight.w600),
    headlineLarge: base.headlineLarge?.copyWith(fontWeight: FontWeight.w700),
    headlineMedium: base.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
    headlineSmall: base.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
    titleLarge: base.titleLarge?.copyWith(fontWeight: FontWeight.w600),
    titleMedium: base.titleMedium?.copyWith(fontWeight: FontWeight.w600),
  );

  static OutlineInputBorder _fieldBorder(BorderSide side) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppRadius.md),
    borderSide: side,
  );
}

/// Spacing scale (multiples of 4) — use instead of raw `EdgeInsets` numbers.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

/// Corner-radius scale for cards, fields and buttons.
abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 20;
}
