import 'package:dvir/features/Settings/application/theme_mode_controller.dart';
import 'package:dvir/features/Settings/data/settings_repository.dart';
import 'package:dvir/features/Settings/data/settings_repository_impl.dart';
import 'package:dvir/features/Settings/presentation/components/theme_picker.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:dvir/l10n/app_localizations_uk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Holds the choice in memory, and remembers what was written so a test can
/// tell "the screen changed" from "the choice will outlive a restart".
class _Settings implements SettingsRepository {
  _Settings([this.themeMode = ThemeMode.system]);

  @override
  ThemeMode themeMode;

  @override
  Future<void> setThemeMode(ThemeMode mode) async => themeMode = mode;
}

void main() {
  final l10n = AppLocalizationsUk();

  ProviderContainer containerWith(_Settings settings) {
    final container = ProviderContainer(
      overrides: [settingsRepositoryProvider.overrideWithValue(settings)],
    );
    addTearDown(container.dispose);

    return container;
  }

  test('starts from what was stored', () {
    final container = containerWith(_Settings(ThemeMode.dark));

    expect(container.read(themeModeControllerProvider), ThemeMode.dark);
  });

  test('a choice repaints at once and is written down', () async {
    final settings = _Settings();
    final container = containerWith(settings);

    final written = container
        .read(themeModeControllerProvider.notifier)
        .select(ThemeMode.light);

    expect(container.read(themeModeControllerProvider), ThemeMode.light);

    await written;
    expect(settings.themeMode, ThemeMode.light);
  });

  testWidgets('the picker offers all three and changes the theme', (
    tester,
  ) async {
    final settings = _Settings();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [settingsRepositoryProvider.overrideWithValue(settings)],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: ThemePicker()),
        ),
      ),
    );

    expect(find.text(l10n.settingsTheme), findsOneWidget);
    for (final label in [
      l10n.settingsThemeLight,
      l10n.settingsThemeDark,
      l10n.settingsThemeSystem,
    ]) {
      expect(find.text(label), findsOneWidget);
    }

    await tester.tap(find.text(l10n.settingsThemeDark));
    await tester.pump();

    expect(settings.themeMode, ThemeMode.dark);
  });
}
