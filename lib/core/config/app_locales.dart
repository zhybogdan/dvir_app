import 'package:flutter/material.dart';

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
}
