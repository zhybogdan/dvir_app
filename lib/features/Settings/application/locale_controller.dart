import 'package:dvir/features/Settings/data/settings_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale_controller.g.dart';

/// The language the app speaks, or null while the phone's own is good enough —
/// read by `MaterialApp`, changed on the settings screen.
@Riverpod(keepAlive: true)
class LocaleController extends _$LocaleController {
  @override
  Locale? build() => ref.watch(settingsRepositoryProvider).locale;

  /// The screen repaints before the choice is written, for the same reason the
  /// theme does: the write is a file on this phone, and the person is looking
  /// at the result rather than waiting for it.
  Future<void> select(Locale locale) {
    final repository = ref.read(settingsRepositoryProvider);
    state = locale;

    return repository.setLocale(locale);
  }
}
