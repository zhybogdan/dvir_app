import 'package:dvir/core/config/preferences.dart';
import 'package:dvir/features/Settings/data/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_repository_impl.g.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._preferences);

  final SharedPreferencesWithCache _preferences;

  /// Every key this repository owns, which is what the store is opened with:
  /// a cache told its keys loads only those, and refuses a key nobody listed
  /// instead of quietly writing it.
  static const Set<String> keys = {_themeModeKey};

  static const String _themeModeKey = 'settings.theme_mode';

  /// Stored by name rather than by index, so reordering the enum one day does
  /// not turn everybody's dark theme into a light one.
  @override
  ThemeMode get themeMode {
    final stored = _preferences.getString(_themeModeKey);

    return ThemeMode.values.firstWhere(
      (mode) => mode.name == stored,
      orElse: () => ThemeMode.system,
    );
  }

  @override
  Future<void> setThemeMode(ThemeMode mode) =>
      _preferences.setString(_themeModeKey, mode.name);
}

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) =>
    SettingsRepositoryImpl(ref.watch(sharedPreferencesProvider));
