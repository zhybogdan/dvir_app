import 'package:flutter/material.dart';

/// Contract for what a person chooses about the app itself (Base), as opposed
/// to anything they record in it.
///
/// Kept on the phone in every build: a theme is a property of this device, and
/// a backup that carried it would repaint the next phone without asking.
abstract interface class SettingsRepository {
  /// [ThemeMode.system] until a person picks something else.
  ThemeMode get themeMode;

  Future<void> setThemeMode(ThemeMode mode);

  /// Null until a person picks a language, and that is not the same as a
  /// default: null hands the choice to the phone, so a Ukrainian phone opens
  /// in Ukrainian and an English one in English without anybody choosing.
  /// The control shows whichever won.
  Locale? get locale;

  Future<void> setLocale(Locale locale);
}
