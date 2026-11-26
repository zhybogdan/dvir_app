import 'package:dvir/core/config/app_locales.dart';
import 'package:dvir/features/Units/application/unit_controller.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/features/Units/domain/types/unit_type.dart';
import 'package:dvir/features/Units/presentation/components/unit_head.dart';
import 'package:dvir/features/Units/presentation/unit_type_l10n.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:dvir/l10n/app_localizations_uk.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

// The head answers what the object is called and where it stands, and nothing
// else — every other fact about it is one the keeper wrote down, and those
// live in the record below. Two things here are invisible until they are
// wrong: a nested object must not repeat the address of the house around it,
// which would state the parent's fact as its own, and it must not repeat its
// own name in the line underneath, which is what a garage called "Гараж" did.

const _house = Unit(
  id: 'house',
  label: 'Дім на Садовій',
  type: UnitType.house,
  address: 'вул. Сітровська 101',
  city: 'Київ',
);

Unit _unit({String? parentId, String label = 'Гараж 1'}) => Unit(
  id: 'u1',
  label: label,
  type: UnitType.garage,
  parentId: parentId,
  address: 'вул. Сітровська 101',
  city: 'Київ',
  // Still a column, and still filled in on objects created before the form
  // stopped asking. The head must not resurrect it.
  areaM2: 102,
);

Future<void> _pump(WidgetTester tester, Unit unit) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [unitProvider('house').overrideWith((ref) async => _house)],
      child: MaterialApp(
        localizationsDelegates: AppLocales.delegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: UnitHead(unit: unit)),
      ),
    ),
  );

  await tester.pump();
}

void main() {
  final l10n = AppLocalizationsUk();
  final garage = UnitType.garage.label(l10n);

  // The name moved out of the app bar and onto the page: the screen opens with
  // the word the person gave the place.
  testWidgets('the object opens with its own name', (tester) async {
    await _pump(tester, _unit());

    expect(find.text('Гараж 1'), findsOneWidget);
  });

  testWidgets('an object at its own address shows it', (tester) async {
    await _pump(tester, _unit());

    expect(find.text('$garage · Київ, вул. Сітровська 101'), findsOneWidget);
  });

  testWidgets('a garage inside a house says which house, not its address', (
    tester,
  ) async {
    await _pump(tester, _unit(parentId: 'house'));

    expect(
      find.text(l10n.unitHeadInside(garage, 'Дім на Садовій')),
      findsOneWidget,
    );
    expect(find.textContaining('вул. Сітровська 101'), findsNothing);
  });

  // A garage somebody called "Гараж" said its own name twice: the line under
  // the name exists to add something, and the kind is not news there.
  testWidgets('a name that is already the kind drops the kind', (tester) async {
    await _pump(tester, _unit(parentId: 'house', label: garage));

    expect(find.text(l10n.scopeNested('Дім на Садовій')), findsOneWidget);
    expect(find.textContaining('$garage ·'), findsNothing);
  });

  // Area left the head when the product became a household record book: it is
  // one fact among many — the plot's area is not the building's, and neither is
  // a room's — and singling it out claimed it was the one that mattered. The
  // column stays for the day communities charge by it.
  testWidgets('the area column is not put back at the top', (tester) async {
    await _pump(tester, _unit());

    expect(find.textContaining('м²'), findsNothing);
    expect(find.textContaining('102'), findsNothing);
  });
}
