import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/features/Units/domain/types/unit_type.dart';
import 'package:dvir/features/Units/presentation/components/unit_head.dart';
import 'package:dvir/features/Units/presentation/unit_type_l10n.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:dvir/l10n/app_localizations_uk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// The head answers what the object is called and where it stands, and nothing
// else — every other fact about it is one the keeper wrote down, and those
// live in the record below. What is invisible until it is wrong: a nested
// object must not repeat the address of the house around it, which would state
// the parent's fact as its own.

Unit _unit({String? parentId}) => Unit(
  id: 'u1',
  label: 'Гараж 1',
  type: UnitType.garage,
  parentId: parentId,
  address: 'вул. Сітровська 101',
  city: 'Київ',
  // Still a column, and still filled in on objects created before the form
  // stopped asking. The head must not resurrect it.
  areaM2: 102,
);

Future<void> _pump(WidgetTester tester, Unit unit) => tester.pumpWidget(
  MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: UnitHead(unit: unit)),
  ),
);

void main() {
  final l10n = AppLocalizationsUk();

  // The name moved out of the app bar and onto the page: the screen opens with
  // the word the person gave the place.
  testWidgets('the object opens with its own name', (tester) async {
    await _pump(tester, _unit());

    expect(find.text('Гараж 1'), findsOneWidget);
  });

  testWidgets('an object at its own address shows it', (tester) async {
    await _pump(tester, _unit());

    expect(
      find.text('${UnitType.garage.label(l10n)} · Київ, вул. Сітровська 101'),
      findsOneWidget,
    );
  });

  testWidgets('a garage inside a house does not claim the house address', (
    tester,
  ) async {
    await _pump(tester, _unit(parentId: 'house'));

    expect(find.textContaining('вул. Сітровська 101'), findsNothing);
    expect(find.textContaining('Київ'), findsNothing);

    // Still recognisably the same head, so the absence above is the address
    // being dropped and not the widget failing to build.
    expect(find.text(UnitType.garage.label(l10n)), findsOneWidget);
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
