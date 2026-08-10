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
// tenant handed an "Add" button ends at a refusal from the database, and no
// amount of testing the rule as a function catches that.

const _facts = [
  UnitAttribute(id: 'a1', name: 'Рік побудови', value: '1998'),
  UnitAttribute(id: 'a2', name: 'Матеріал стін', value: 'Цегла'),
];

/// Enough facts to overflow the hub's preview, named so a row can be looked up
/// by its position in the record.
List<UnitAttribute> _many(int count) => [
  for (var index = 0; index < count; index++)
    UnitAttribute(id: 'a$index', name: 'Факт $index', value: '$index'),
];

/// Stands in for the record itself, so the section is tested against a list
/// rather than against Supabase.
class _StubAttributes extends UnitAttributes {
  _StubAttributes(this.attributes);

  final List<UnitAttribute> attributes;

  @override
  Future<List<UnitAttribute>> build(String unitId) async => attributes;
}

Future<void> _pump(
  WidgetTester tester, {
  required bool canEdit,
  List<UnitAttribute> attributes = _facts,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        isUnitKeeperProvider('u1').overrideWithValue(canEdit),
        unitAttributesProvider.overrideWith2(
          (unitId) => _StubAttributes(attributes),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        // Scrollable, like both places that carry the section: a record long
        // enough to test the cut is longer than a test viewport.
        home: const Scaffold(
          body: SingleChildScrollView(
            child: UnitAttributesSection(unitId: 'u1'),
          ),
        ),
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

  // The hub is a column of sections, and a long record would push the ones
  // below it off the screen.
  testWidgets('a record that fits is shown whole, with no way out', (
    tester,
  ) async {
    await _pump(tester, canEdit: true, attributes: _many(5));

    expect(find.text('Факт 4'), findsOneWidget);
    expect(find.textContaining('Показати всі'), findsNothing);
  });

  testWidgets('a longer one is cut, and the rest is one tap away', (
    tester,
  ) async {
    await _pump(tester, canEdit: true, attributes: _many(12));

    expect(find.text('Факт 4'), findsOneWidget);
    expect(find.text('Факт 5'), findsNothing);
    // The whole record, not what is left over.
    expect(find.text(l10n.unitAttributesShowAll(12)), findsOneWidget);
  });
}
