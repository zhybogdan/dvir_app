import 'package:dvir/features/Home/application/my_scopes_controller.dart';
import 'package:dvir/features/Home/domain/models/scope_summary.dart';
import 'package:dvir/features/Shared/presentation/dv_app_tile.dart';
import 'package:dvir/features/Shared/presentation/splash_screen.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// `flutter_native_splash` paints the tile centred on the screen before Flutter
// runs, so this screen's one job is to take over without anything moving. Both
// halves of that are pinned here: where the tile sits, and that the spinner is
// not part of the opening.
//
// Never `pumpAndSettle` in this file: the progress indicator animates forever
// and would hold the pump until the suite gives up.

const Size _screen = Size(390, 844);

Future<void> _pump(WidgetTester tester) async {
  tester.view
    ..devicePixelRatio = 1
    ..physicalSize = _screen;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        myScopesProvider.overrideWith(
          (ref) async => (userId: 'me', scopes: <ScopeSummary>[]),
        ),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SplashScreen(),
      ),
    ),
  );

  await tester.pump();
}

void main() {
  testWidgets('the tile keeps the centre the phone drew it on', (tester) async {
    await _pump(tester);

    expect(
      tester.getCenter(find.byType(DvAppTile)).dy,
      _screen.height / 2,
      reason: 'the native frame centres the tile; anything else is a jump',
    );
  });

  testWidgets('the name is under the tile without having moved it', (
    tester,
  ) async {
    await _pump(tester);

    final tile = tester.getRect(find.byType(DvAppTile));
    final name = tester.getRect(find.text('Двір'));

    expect(name.top, greaterThanOrEqualTo(tile.bottom));
  });

  testWidgets('a start that is simply fast never shows a spinner', (
    tester,
  ) async {
    await _pump(tester);

    expect(
      tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
      0,
    );

    await tester.pump(const Duration(milliseconds: 700));

    expect(
      tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
      1,
    );
  });
}
