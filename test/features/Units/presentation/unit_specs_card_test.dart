import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/features/Units/domain/types/unit_type.dart';
import 'package:dvir/features/Units/presentation/components/unit_specs_card.dart';
import 'package:dvir/features/Units/presentation/unit_type_l10n.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:dvir/l10n/app_localizations_uk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// The card answers where the object stands and what it is, and nothing else —
// every other fact about it is one the keeper wrote down, and those live in the
// record below. What is invisible until it is wrong: a nested object must not
// repeat the address of the house around it, which would state the parent's
// fact as its own.

Unit _unit({String? parentId}) => Unit(
  id: 'u1',
  label: 'Гараж 1',
  type: UnitType.garage,
  parentId: parentId,
  address: 'вул. Сітровська 101',
  city: 'Київ',
  // Still a column, and still filled in on objects created before the form
  // stopped asking. The card must not resurrect it.
  areaM2: 102,
);

Future<void> _pump(WidgetTester tester, Unit unit) => tester.pumpWidget(
  MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: UnitSpecsCard(unit: unit)),
  ),
);

void main() {
  final l10n = AppLocalizationsUk();

  testWidgets('an object at its own address shows it', (tester) async {
    await _pump(tester, _unit());

    expect(find.text('вул. Сітровська 101'), findsOneWidget);
    expect(find.text('Київ'), findsOneWidget);
  });

  testWidgets('a garage inside a house does not claim the house address', (
    tester,
  ) async {
    await _pump(tester, _unit(parentId: 'house'));

    expect(find.text('вул. Сітровська 101'), findsNothing);
    expect(find.text('Київ'), findsNothing);

    // Still recognisably the same card, so the absence above is the address
    // being dropped and not the card failing to build.
    expect(find.text(UnitType.garage.label(l10n)), findsOneWidget);
  });

  // The app bar above the card already carries the name, and carries it while
  // the page scrolls — printing it twice made the hub open on the same word
  // said twice.
  testWidgets('the name is left to the app bar', (tester) async {
    await _pump(tester, _unit());

    expect(find.text('Гараж 1'), findsNothing);
  });

  // Area left the card when the product became a household record book: it is
  // one fact among many — the plot's area is not the building's, and neither is
  // a room's — and singling it out claimed it was the one that mattered. The
  // column stays for the day communities charge by it.
  testWidgets('the area column is not put back on the card', (tester) async {
    await _pump(tester, _unit());

    expect(find.textContaining('м²'), findsNothing);
    expect(find.textContaining('102'), findsNothing);
  });
}
