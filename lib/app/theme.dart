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

  /// The app's typeface, named once because two places need it by name: the
  /// theme itself, and the button style that does not inherit from it.
  static const String fontFamily = 'Inter';

  static ThemeData _build(Brightness brightness) {
    final scheme = _krayda(
      ColorScheme.fromSeed(seedColor: _seed, brightness: brightness),
    );

    final base = ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      fontFamily: fontFamily,
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
          // The family is spelled out although the theme already carries it.
          // A button's label is not merged with the text theme the way a
          // field's label is: `ButtonStyle.textStyle` is handed to the label
          // as it stands, so a null family here is the platform's font — and
          // the one string in the app not drawn in Inter.
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: scheme.primary),
      ),
    );
  }

  /// The generated scheme with its accent and its surfaces replaced.
  ///
  /// Every surface M3 derives is a tint of the seed, which is how the app once
  /// ended up with a tinted page and an accent that had nowhere to sound. The
  /// values are measured rather than picked — `theme_contrast_test.dart` holds
  /// every pair of them to its floor — and the text roles move together with
  /// the grounds they sit on, so no reading gets worse.
  ///
  /// `primary` is pinned rather than left generated, which it was while the
  /// accent happened to be what the seed derived. It no longer is: the accent
  /// is a chosen value, and a seed that lands near it by luck is not a
  /// decision. What stays generated is the error family and the roles nothing
  /// reads.
  ///
  /// A card is 1.11:1 against the page here and 1.09:1 in dark. That is not a
  /// value to improve — no pair of light surfaces reaches 3:1 — so the card is
  /// separated by its shadow, its hairline and the gap, and never by its tint.
  static ColorScheme _krayda(ColorScheme base) => switch (base.brightness) {
    Brightness.light => base.copyWith(
      primary: const Color(0xFF3730A3),
      onPrimary: const Color(0xFFFFFFFF),
      surface: const Color(0xFFF1F3F7),
      onSurface: const Color(0xFF13161C),
      onSurfaceVariant: const Color(0xFF5B6170),
      surfaceContainerLow: const Color(0xFFFFFFFF),
      surfaceContainerHigh: const Color(0xFFFFFFFF),
      surfaceContainerHighest: const Color(0xFFE4E7EF),
      outline: const Color(0xFF7A8295),
      outlineVariant: const Color(0xFFDDE0E8),
    ),
    // The accent inverts in dark, as `onPrimary` does with it: a label drawn
    // white on this periwinkle would read 1.8:1.
    Brightness.dark => base.copyWith(
      primary: const Color(0xFFB9BDFF),
      onPrimary: const Color(0xFF222063),
      surface: const Color(0xFF0F1115),
      onSurface: const Color(0xFFE5E7EE),
      onSurfaceVariant: const Color(0xFF9AA0B0),
      surfaceContainerLow: const Color(0xFF171A21),
      surfaceContainerHigh: const Color(0xFF1D2029),
      surfaceContainerHighest: const Color(0xFF232733),
      outline: const Color(0xFF7B8294),
      outlineVariant: const Color(0xFF2A2E3A),
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

/// A colour that says what kind of thing a row is, in both themes.
///
/// Two values and not one, for the reason `primary` has two: a fill that reads
/// at 9.9:1 on a white card is 1.75:1 on a dark one, and the badge stops being
/// a badge. The glyph drawn on it reads [AppTones.on], which inverts with it.
@immutable
class Tone {
  const Tone({required this.light, required this.dark});

  final Color light;
  final Color dark;

  Color of(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;
}

/// The colour of each kind of row.
///
/// This is the rule "difference is carried by form, not by colour" being
/// lifted — by the owner, on 2026-11-13, after the screens read as one grey
/// sheet. The glyph still says *what* the thing is; the colour says which
/// family it belongs to, and there are seven of them rather than one per type:
/// a colour per type would multiply the single accent into fifteen, which is
/// why the rule existed in the first place.
///
/// The grouping is not new either — [place], [room] and [building] are the
/// three groups `UnitTypeL10n.groupLabel` already draws in the type picker.
///
/// Every pair below was measured: white on the light fill never drops under
/// 5:1, the fill never drops under 5:1 against a white card, and in dark the
/// fill clears 8:1 against the card with near-black on it.
abstract final class AppTones {
  /// What stands at an address — a house, a flat, a plot. The brand itself,
  /// because the object is what the app is about.
  static const Tone place = Tone(
    light: Color(0xFF3730A3),
    dark: Color(0xFFB9BDFF),
  );

  /// What is inside the walls — a room, a bathroom, a cellar.
  static const Tone room = Tone(
    light: Color(0xFF0F766E),
    dark: Color(0xFF6AD6C8),
  );

  /// What stands apart in the yard — a garage, a shed, a summer kitchen.
  static const Tone building = Tone(
    light: Color(0xFFB45309),
    dark: Color(0xFFF0B35E),
  );

  /// Everything unforeseen, and a file that is neither picture nor paper.
  static const Tone other = Tone(
    light: Color(0xFF475569),
    dark: Color(0xFFAAB4C4),
  );

  /// A document that proves something — the contract, the passport.
  static const Tone paper = Tone(
    light: Color(0xFFB4342C),
    dark: Color(0xFFFF9D93),
  );

  /// A photograph: the meter cabinet, the boiler, the crack in the wall.
  static const Tone picture = Tone(
    light: Color(0xFF0369A1),
    dark: Color(0xFF7CC4F0),
  );

  /// A telephone number, and the person behind it.
  static const Tone person = Tone(
    light: Color(0xFF15803D),
    dark: Color(0xFF74D48F),
  );

  /// What is drawn **on** a tone — never a literal white, which in dark would
  /// read 1.3:1 on these fills.
  static Color on(Brightness brightness) => brightness == Brightness.dark
      ? const Color(0xFF0F1115)
      : const Color(0xFFFFFFFF);
}

/// Fixed brand colours that are not derived from the scheme and stay constant
/// across light and dark — e.g. the mark inside an illustration.
abstract final class AppColors {
  static const Color white = Color(0xFFFFFFFF);

  /// The brand indigo: the seed the whole scheme grows from, and the fill the
  /// launcher icon is painted in.
  ///
  /// Used directly rather than `colorScheme.primary`, which inverts per theme
  /// (deep in light, a pale periwinkle in dark). An app icon cannot follow the
  /// theme, so anything meant to read as *the icon* — the app mark, the
  /// splash — has to hold still with it.
  ///
  /// The artwork under `tool/branding/` is still the old teal, so until it is
  /// redrawn the app reads indigo inside and teal on the home screen. That is
  /// a missing drawing, not a value to change back.
  static const Color brand = Color(0xFF3730A3);

  // Status accents the seeded M3 scheme has no role for: `error` lives on the
  // scheme, but success and warning do not. Toasts (and later banners/chips)
  // read these instead of hardcoding a hex in the widget.
  static const Color success = Color(0xFF16A34A); // green 600
  static const Color warning = Color(0xFFD97706); // amber 600
}
