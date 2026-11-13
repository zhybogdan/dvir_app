import 'package:flutter/material.dart';

/// App-wide Material 3 theme derived from a single seed color.
///
/// Component defaults (inputs, buttons) are set here so shared `Dv*` widgets
/// stay thin and every screen inherits the same look without re-styling.
class AppTheme {
  const AppTheme._();

  static const Color _seed = AppColors.brand;

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = _krayda(
      ColorScheme.fromSeed(seedColor: _seed, brightness: brightness),
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
        // `outline` and not the quiet fill a field used to be bordered with:
        // the field is filled with the same white a card is, so a border of
        // that fill reads 1.21:1 and the field stops looking like a field.
        border: _fieldBorder(BorderSide(color: scheme.outline)),
        enabledBorder: _fieldBorder(BorderSide(color: scheme.outline)),
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

  /// The generated scheme with its surfaces replaced by cold neutrals.
  ///
  /// Every surface M3 derives is a tint of the seed, which is how a teal app
  /// ended up with a teal page and an accent that had nowhere to sound. The
  /// values are measured rather than picked — each one's ratios are in the
  /// design system beside it — and none of them moves a text contrast, because
  /// the text roles move together with the grounds they sit on.
  ///
  /// What stays generated: `primary`, `onPrimary` and the error family. What is
  /// new to the app: `outline`, which nothing read before, and `outlineVariant`
  /// for the hairline the card takes in its own step.
  ///
  /// A card is 1.11:1 against the page here and 1.10:1 in dark. That is not a
  /// value to improve — no pair of light surfaces reaches 3:1 — so the card is
  /// separated by its shadow, its hairline and the gap, and never by its tint.
  static ColorScheme _krayda(ColorScheme base) => switch (base.brightness) {
    Brightness.light => base.copyWith(
      surface: const Color(0xFFF1F4F5),
      onSurface: const Color(0xFF14181A),
      onSurfaceVariant: const Color(0xFF5D676B),
      surfaceContainerLow: const Color(0xFFFFFFFF),
      surfaceContainerHigh: const Color(0xFFFFFFFF),
      surfaceContainerHighest: const Color(0xFFE6EAEC),
      outline: const Color(0xFF7F8A8E),
      outlineVariant: const Color(0xFFDFE3E5),
    ),
    Brightness.dark => base.copyWith(
      surface: const Color(0xFF101314),
      onSurface: const Color(0xFFE4EAEC),
      onSurfaceVariant: const Color(0xFF9AA4A8),
      surfaceContainerLow: const Color(0xFF191D1E),
      surfaceContainerHigh: const Color(0xFF1F2426),
      surfaceContainerHighest: const Color(0xFF242A2C),
      outline: const Color(0xFF79858A),
      outlineVariant: const Color(0xFF2A3032),
    ),
  };

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

/// Bounds on the system text size the app will follow.
///
/// A ceiling rather than a fixed 1.0: someone who set a larger font did it
/// because they need it, and pinning the scale takes that away. The cap is what
/// the layouts were checked against — see `test/app/text_scale_test.dart`.
abstract final class AppTextScale {
  static const double max = 1.4;
}

/// Corner-radius scale for cards, fields and buttons.
abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 20;
}

/// The shadows the app draws for itself, where Material's own elevation gives
/// one soft blur and the palette asks for something tighter.
abstract final class AppShadows {
  /// The lift under a card: two close shadows rather than one wide blur, which
  /// reads as a smudge. The tint is 6% and 4% of the palette's ink and not
  /// `scheme.shadow`, which is pure black and goes muddy over a cold page.
  ///
  /// Empty in dark. A shadow over a near-black page shows nothing, and there
  /// the card's own lighter fill does the separating instead.
  static List<BoxShadow> card(Brightness brightness) =>
      brightness == Brightness.dark ? const [] : _card;

  static const List<BoxShadow> _card = [
    BoxShadow(color: Color(0x0F14181A), blurRadius: 2, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x0A14181A), blurRadius: 3, offset: Offset(0, 1)),
  ];
}

/// What tells a block from the page: the fill, the hairline and the lift.
///
/// All three together, because none of them works alone here. A card is 1.11:1
/// against the page and no better grey exists — that measurement is in
/// `test/app/theme_contrast_test.dart` — so a block given the fill and nothing
/// else is a white hole in a grey page rather than a card. The app draws four
/// of these blocks (a tile, an empty state, the invite code, the object's
/// specs); they are one shape, and this is where that shape is decided.
abstract final class AppSurfaces {
  static BoxDecoration card(ColorScheme scheme) => BoxDecoration(
    color: scheme.surfaceContainerLow,
    borderRadius: BorderRadius.circular(AppRadius.lg),
    border: Border.all(color: scheme.outlineVariant),
    boxShadow: AppShadows.card(scheme.brightness),
  );
}

/// Fixed brand colours that are not derived from the scheme and stay constant
/// across light and dark — e.g. the mark inside an illustration.
abstract final class AppColors {
  static const Color white = Color(0xFFFFFFFF);

  /// The brand teal: the seed the whole scheme grows from, and the fill the
  /// launcher icon is painted in.
  ///
  /// Used directly rather than `colorScheme.primary`, which Material derives per
  /// theme (a deep teal in light, a pale mint in dark). An app icon cannot
  /// follow the theme, so anything meant to read as *the icon* — the app mark,
  /// the splash — has to hold still with it.
  static const Color brand = Color(0xFF0D9488);

  // Status accents the seeded M3 scheme has no role for: `error` lives on the
  // scheme, but success and warning do not. Toasts (and later banners/chips)
  // read these instead of hardcoding a hex in the widget.
  static const Color success = Color(0xFF16A34A); // green 600
  static const Color warning = Color(0xFFD97706); // amber 600
}
