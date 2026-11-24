import 'package:dvir/features/Settings/data/settings_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_mode_controller.g.dart';

/// Light, dark, or whatever the phone says — read by `MaterialApp`, changed on
/// the settings screen.
@Riverpod(keepAlive: true)
class ThemeModeController extends _$ThemeModeController {
  @override
  ThemeMode build() => ref.watch(settingsRepositoryProvider).themeMode;

  /// The screen repaints before the choice is written: the write is a file on
  /// the same phone, and the person is looking at the result, not waiting for
  /// it.
  Future<void> select(ThemeMode mode) {
    final repository = ref.read(settingsRepositoryProvider);
    state = mode;

    return repository.setThemeMode(mode);
  }
}
