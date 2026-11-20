import 'package:dvir/features/Home/application/my_scopes_controller.dart';
import 'package:dvir/features/Home/domain/models/scope_summary.dart';
import 'package:dvir/features/Home/presentation/screens/scopes_screen.dart';
import 'package:dvir/features/Shared/domain/types/member_status.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/features/Units/domain/models/unit_membership.dart';
import 'package:dvir/features/Units/domain/types/unit_role.dart';
import 'package:dvir/features/Units/domain/types/unit_type.dart';
import 'package:dvir/features/Units/presentation/unit_type_l10n.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:dvir/l10n/app_localizations_uk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// The list holds what stands on its own. What stands inside is counted on its
// parent's card and not drawn as a card of its own — a house with eight rooms
// was eight indented rows of noise. The folding rule itself, including the
// tenant whose only flat must not vanish, is pinned in scope_arrangement_test;
// what is pinned here is that the screen draws what the rule decided.

ScopeSummary _unit(
  String id,
  String label, {
  UnitType type = UnitType.house,
  String? parentId,
  String? city,
  String? address,
  ScopeCounts? counts,
}) => ScopeSummary.unit(
  membership: UnitMembership(
    id: 'um-$id',
    unitId: id,
    userId: 'me',
    role: UnitRole.owner,
    status: MemberStatus.active,
  ),
  unit: Unit(
    id: id,
    label: label,
    type: type,
    parentId: parentId,
    city: city,
    address: address,
  ),
  counts: counts,
);

Future<void> _pump(WidgetTester tester, List<ScopeSummary> scopes) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        myScopesProvider.overrideWith(
          (ref) async => (userId: 'me', scopes: scopes),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const ScopesScreen(),
      ),
    ),
  );

  await tester.pump();
}

void main() {
  final l10n = AppLocalizationsUk();

  testWidgets('an object inside another is counted, not drawn', (tester) async {
    await _pump(tester, [
      _unit('h', 'Дім на Садовій', counts: (documents: 3, attributes: 5)),
      _unit(
        'g',
        'Гараж',
        type: UnitType.garage,
        parentId: 'h',
        counts: (documents: 0, attributes: 0),
      ),
    ]);

    expect(find.text('Дім на Садовій'), findsOneWidget);
    expect(find.text('Гараж'), findsNothing);
    expect(
      find.text(
        '${l10n.scopePapers(3)} · ${l10n.scopeFacts(5)} · '
        '${l10n.scopeInside(1)}',
      ),
      findsOneWidget,
    );
  });

  // On a new object the zeros are the invitation, so they are printed; the
  // count of what is inside appears only when there is something.
  testWidgets('a new object says it holds nothing yet', (tester) async {
    await _pump(tester, [
      _unit('h', 'Дім', counts: (documents: 0, attributes: 0)),
    ]);

    expect(
      find.text('${l10n.scopePapers(0)} · ${l10n.scopeFacts(0)}'),
      findsOneWidget,
    );
  });

  // The region in front of the street pushed the house number onto a line of
  // its own; in one household's list the street is what tells places apart.
  testWidgets('a card names the street, and the city only without one', (
    tester,
  ) async {
    await _pump(tester, [
      _unit(
        'h',
        'Дім на Садовій',
        city: 'Київська обл.',
        address: 'вул. Садова, 14',
      ),
      _unit('f', 'Квартира', type: UnitType.apartment, city: 'Львів'),
    ]);

    final house = UnitType.house.label(l10n);
    final flat = UnitType.apartment.label(l10n);

    expect(find.text('$house · вул. Садова, 14'), findsOneWidget);
    expect(find.text('$flat · Львів'), findsOneWidget);
  });

  test('the counts take the Ukrainian plural forms', () {
    expect(l10n.scopePapers(1), '1 документ');
    expect(l10n.scopePapers(3), '3 документи');
    expect(l10n.scopePapers(12), '12 документів');
    expect(l10n.scopeFacts(21), '21 факт');
    expect(l10n.scopeFacts(0), '0 фактів');
  });
}
