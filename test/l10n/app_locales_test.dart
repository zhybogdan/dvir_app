import 'package:dvir/core/config/app_locales.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

// `AppLocales.supported` is what `MaterialApp` is given, and the generated list
// is what the app actually has translations for. They are two lists that have
// to hold the same languages, so a new `.arb` cannot arrive without being
// placed in the order below.
void main() {
  test('the app offers exactly the languages it has translations for', () {
    expect(
      AppLocales.supported.toSet(),
      AppLocalizations.supportedLocales.toSet(),
    );
  });

  test('Ukrainian is first, because the first one is the fallback', () {
    // A phone set to a third language is handed `supportedLocales.first`. The
    // generated list is alphabetical and starts with English, which is why this
    // app passes its own order instead.
    expect(AppLocales.supported.first, AppLocales.uk);
  });
}
