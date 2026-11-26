import 'package:dvir/core/config/app_locales.dart';
import 'package:dvir/features/Settings/application/locale_controller.dart';
import 'package:dvir/features/Settings/data/settings_repository.dart';
import 'package:dvir/features/Settings/data/settings_repository_impl.dart';
import 'package:dvir/features/Settings/presentation/components/language_picker.dart';
import 'package:dvir/l10n/app_localizations_en.dart';
import 'package:dvir/l10n/app_localizations_uk.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// Holds the choice in memory, and remembers what was written so a test can
/// tell "the screen changed" from "the choice will outlive a restart".
class _Settings implements SettingsRepository {
  _Settings([this.locale]);

  @override
  ThemeMode themeMode = ThemeMode.system;

  @override
  Locale? locale;

  @override
  Future<void> setThemeMode(ThemeMode mode) async => themeMode = mode;

  @override
  Future<void> setLocale(Locale value) async => locale = value;
}

/// The wiring under test: the language a person picked is what `MaterialApp`
/// is given, and null leaves the phone's own in force.
class _App extends ConsumerWidget {
  const _App();

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp(
    locale: ref.watch(localeControllerProvider),
    localizationsDelegates: AppLocales.delegates,
    supportedLocales: AppLocales.supported,
    home: const Scaffold(body: LanguagePicker()),
  );
}

void main() {
  final uk = AppLocalizationsUk();
  final en = AppLocalizationsEn();

  ProviderContainer containerWith(_Settings settings) {
    final container = ProviderContainer(
      overrides: [settingsRepositoryProvider.overrideWithValue(settings)],
    );
    addTearDown(container.dispose);

    return container;
  }

  test('nothing stored leaves the choice to the phone', () {
    final container = containerWith(_Settings());

    expect(container.read(localeControllerProvider), isNull);
  });

  test('starts from what was stored', () {
    final container = containerWith(_Settings(AppLocales.en));

    expect(container.read(localeControllerProvider), AppLocales.en);
  });

  test('a choice repaints at once and is written down', () async {
    final settings = _Settings();
    final container = containerWith(settings);

    final written = container
        .read(localeControllerProvider.notifier)
        .select(AppLocales.en);

    expect(container.read(localeControllerProvider), AppLocales.en);

    await written;
    expect(settings.locale, AppLocales.en);
  });

  testWidgets('both languages are named in their own, and tapping switches', (
    tester,
  ) async {
    final settings = _Settings();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [settingsRepositoryProvider.overrideWithValue(settings)],
        child: const _App(),
      ),
    );

    // Ukrainian until something says otherwise: the test platform's language is
    // pinned to it in `test/flutter_test_config.dart`.
    expect(find.text(uk.settingsLanguage), findsOneWidget);
    expect(find.text(uk.settingsLanguageUk), findsOneWidget);
    expect(find.text(uk.settingsLanguageEn), findsOneWidget);

    await tester.tap(find.text(en.settingsLanguageEn));
    await tester.pumpAndSettle();

    expect(settings.locale, AppLocales.en);
    expect(find.text(en.settingsLanguage), findsOneWidget);
    expect(find.text(uk.settingsLanguage), findsNothing);
  });
}
