import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/features/Units/domain/types/unit_type.dart';
import 'package:dvir/features/Units/presentation/components/unit_specs_card.dart';
import 'package:dvir/features/Units/presentation/unit_type_l10n.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:dvir/l10n/app_localizations_uk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Two decisions from Phase 4.5 live in this card, and both are invisible until
// they are wrong: a nested object must not repeat the address of the house
// around it — that would state the parent's fact as its own — and an area is
// written the way it is spoken.

Unit _unit({String? parentId, double? areaM2}) => Unit(
  id: 'u1',
  label: 'Гараж 1',
  type: UnitType.garage,
  parentId: parentId,
  address: 'вул. Сітровська 101',
  city: 'Київ',
  areaM2: areaM2,
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
    expect(find.text('Гараж 1'), findsOneWidget);
    expect(find.text(UnitType.garage.label(l10n)), findsOneWidget);
  });

  // "102 м²" reads better on a card than "102.0 м²", and areas are whole
  // numbers far more often than not.
  testWidgets('a whole area loses its decimal point', (tester) async {
    await _pump(tester, _unit(areaM2: 102));

    expect(find.text(l10n.unitAreaValue('102')), findsOneWidget);
  });

  testWidgets('a fractional area keeps it', (tester) async {
    await _pump(tester, _unit(areaM2: 102.5));

    expect(find.text(l10n.unitAreaValue('102.5')), findsOneWidget);
  });

  testWidgets('an object with no area says nothing about it', (tester) async {
    await _pump(tester, _unit());

    expect(find.textContaining('м²'), findsNothing);
  });
}
