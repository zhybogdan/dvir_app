import 'package:dvir/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// The languages the app speaks, Ukrainian first.
///
/// Ordered by hand rather than taken from `AppLocalizations.supportedLocales`:
/// that list is generated alphabetically, and its first entry is what a phone
/// set to a third language falls back to. For this app that has to be
/// Ukrainian, not whatever sorts first.
///
/// `test/l10n/app_locales_test.dart` holds this list against the generated one,
/// so a new `.arb` cannot arrive without being placed in this order.
abstract final class AppLocales {
  static const Locale uk = Locale('uk');

  static const Locale en = Locale('en');

  static const List<Locale> supported = [uk, en];

  /// Used instead of `AppLocalizations.localizationsDelegates`, which gen-l10n
  /// still fills with `flutter_localizations`' Material strings. Since 3.50 the
  /// widgets come from `material_ui` and look up its own `MaterialLocalizations`
  /// type, so with the generated list every date picker and back button reports
  /// Ukrainian as unsupported.
  static const List<LocalizationsDelegate<dynamic>> delegates = [
    AppLocalizations.delegate,
    ...GlobalMaterialLocalizations.delegates,
  ];
}
