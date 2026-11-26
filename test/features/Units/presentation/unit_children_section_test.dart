import 'package:dvir/app/icons.dart';
import 'package:dvir/core/config/app_locales.dart';
import 'package:dvir/features/Units/application/unit_children_controller.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/features/Units/domain/types/unit_type.dart';
import 'package:dvir/features/Units/presentation/components/unit_children_section.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

// The icon map used to be a private method on the home screen, so the list of
// objects inside another — the same rows, one level down — drew nothing in its
// leading slot. What is pinned here is that a nested object is told apart by
// what it is, not only by what its owner called it.

Unit _unit(String id, UnitType type) =>
    Unit(id: id, label: 'Об’єкт $id', type: type);

Future<void> _pump(WidgetTester tester, List<Unit> children) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        unitChildrenProvider('u1').overrideWith((ref) async => children),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocales.delegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: UnitChildrenSection(unitId: 'u1', canAdd: false),
        ),
      ),
    ),
  );

  await tester.pump();
}

void main() {
  testWidgets('each nested object carries the icon of its type', (
    tester,
  ) async {
    await _pump(tester, [
      _unit('a', UnitType.garage),
      _unit('b', UnitType.pool),
    ]);

    expect(find.byIcon(AppIcons.unitGarage), findsOneWidget);
    expect(find.byIcon(AppIcons.unitPool), findsOneWidget);
  });

  // Two types share a glyph where Material has only one drawing for both, and
  // that is a mapping decision rather than an accident — a room and a corridor
  // are meant to look alike until the icon set can tell them apart.
  testWidgets('types that share a drawing are drawn the same', (tester) async {
    await _pump(tester, [
      _unit('a', UnitType.room),
      _unit('b', UnitType.corridor),
    ]);

    expect(find.byIcon(AppIcons.unitRoom), findsNWidgets(2));
  });

  // The reason heading and list were joined into one widget: written apart,
  // the heading on the hub could not say how many rows were under it.
  testWidgets('the heading counts what is in the section', (tester) async {
    await _pump(tester, [
      _unit('a', UnitType.room),
      _unit('b', UnitType.garage),
      _unit('c', UnitType.pool),
    ]);

    expect(find.text('3'), findsOneWidget);
  });
}
