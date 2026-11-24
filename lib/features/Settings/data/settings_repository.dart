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
}
