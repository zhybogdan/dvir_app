import 'package:dvir/app/app_shell.dart';
import 'package:dvir/core/config/app_capabilities.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:dvir/l10n/app_localizations_uk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

// What the island promises: a tap goes to that place, each place remembers
// where it was left, and a tap on the place already open goes back to its
// first page. The real router's routes are not needed for that, only the shell
// around four plain pages — the first of which can open a page of its own.

GoRouter _router() => GoRouter(
  initialLocation: '/one',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/one',
              builder: (context, state) => Scaffold(
                body: TextButton(
                  onPressed: () => context.go('/one/deeper'),
                  child: const Text('page one'),
                ),
              ),
              routes: [
                GoRoute(
                  path: 'deeper',
                  builder: (context, state) =>
                      const Scaffold(body: Text('deeper in one')),
                ),
              ],
            ),
          ],
        ),
        for (final name in ['two', 'three', 'four'])
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/$name',
                builder: (context, state) => Scaffold(body: Text('page $name')),
              ),
            ],
          ),
      ],
    ),
  ],
);

Future<void> _pump(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appCapabilitiesProvider.overrideWithValue(
          const AppCapabilities.onDevice(),
        ),
      ],
      child: MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: _router(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  final l10n = AppLocalizationsUk();

  testWidgets('a tab goes to its place', (tester) async {
    await _pump(tester);

    await tester.tap(find.byTooltip(l10n.documents));
    await tester.pumpAndSettle();

    expect(find.text('page two'), findsOneWidget);
  });

  // Leaving a house for the papers and coming back finds the house.
  testWidgets('a place remembers where it was left', (tester) async {
    await _pump(tester);

    await tester.tap(find.text('page one'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip(l10n.documents));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip(l10n.navObjects));
    await tester.pumpAndSettle();

    expect(find.text('deeper in one'), findsOneWidget);
  });

  testWidgets('the open tab tapped again goes back to its first page', (
    tester,
  ) async {
    await _pump(tester);

    await tester.tap(find.text('page one'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip(l10n.navObjects));
    await tester.pumpAndSettle();

    expect(find.text('page one'), findsOneWidget);
    expect(find.text('deeper in one'), findsNothing);
  });

  // An on-device build has nobody to be: the fourth place is the settings.
  testWidgets('the fourth tab is settings where there are no people', (
    tester,
  ) async {
    await _pump(tester);

    expect(find.byTooltip(l10n.settingsTitle), findsOneWidget);
    expect(find.byTooltip(l10n.profileTitle), findsNothing);
  });
}
