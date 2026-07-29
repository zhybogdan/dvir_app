import 'package:dvir/features/Members/application/unit_members_controller.dart';
import 'package:dvir/features/Shared/presentation/dv_menu.dart';
import 'package:dvir/features/Units/application/unit_attributes_controller.dart';
import 'package:dvir/features/Units/domain/models/unit_attribute.dart';
import 'package:dvir/features/Units/presentation/components/unit_attributes_section.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:dvir/l10n/app_localizations_uk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// The rule is covered in unit_keeper_test. What is checked here is the other
// half: that the section asks it, and offers only what the answer allows. A
// tenant handed an "Додати" button ends at a refusal from the database, and no
// amount of testing the rule as a function catches that.

const _facts = [
  UnitAttribute(id: 'a1', name: 'Рік побудови', value: '1998'),
  UnitAttribute(id: 'a2', name: 'Матеріал стін', value: 'Цегла'),
];

Future<void> _pump(
  WidgetTester tester, {
  required bool canEdit,
  List<UnitAttribute> attributes = _facts,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        isUnitKeeperProvider('u1').overrideWithValue(canEdit),
        unitAttributesProvider.overrideWith((ref, unitId) => attributes),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: UnitAttributesSection(unitId: 'u1')),
      ),
    ),
  );

  await tester.pump();
}

void main() {
  final l10n = AppLocalizationsUk();

  testWidgets('a keeper is offered a way to add and to change each fact', (
    tester,
  ) async {
    await _pump(tester, canEdit: true);

    expect(find.text(l10n.unitAddCta), findsOneWidget);
    expect(find.byType(DvMenu), findsNWidgets(_facts.length));
  });

  testWidgets('a tenant reads the same facts and is offered neither', (
    tester,
  ) async {
    await _pump(tester, canEdit: false);

    expect(find.text('Рік побудови'), findsOneWidget);
    expect(find.text('1998'), findsOneWidget);
    expect(find.text(l10n.unitAddCta), findsNothing);
    expect(find.byType(DvMenu), findsNothing);
  });

  // An empty record is the state every object starts in, and the one place the
  // section says what it is for.
  testWidgets('an object with nothing written down says so', (tester) async {
    await _pump(tester, canEdit: true, attributes: const []);

    expect(find.text(l10n.unitAttributesEmpty), findsOneWidget);
    expect(find.text(l10n.unitAddCta), findsOneWidget);
  });
}
