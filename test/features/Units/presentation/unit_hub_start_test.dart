import 'dart:async';

import 'package:dvir/core/config/app_capabilities.dart';
import 'package:dvir/features/Contacts/application/contacts_controller.dart';
import 'package:dvir/features/Contacts/domain/models/contact.dart';
import 'package:dvir/features/Documents/application/documents_controller.dart';
import 'package:dvir/features/Documents/domain/models/document.dart';
import 'package:dvir/features/Members/application/unit_members_controller.dart';
import 'package:dvir/features/Shared/domain/types/scope_ref.dart';
import 'package:dvir/features/Units/application/unit_attributes_controller.dart';
import 'package:dvir/features/Units/application/unit_children_controller.dart';
import 'package:dvir/features/Units/application/unit_controller.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/features/Units/domain/models/unit_attribute.dart';
import 'package:dvir/features/Units/domain/types/unit_type.dart';
import 'package:dvir/features/Units/presentation/screens/unit_hub_screen.dart';
import 'package:dvir/features/Units/presentation/unit_type_l10n.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:dvir/l10n/app_localizations_uk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// The one rule the start block lives by: it stands in for the whole record
// while the object holds nothing at all, and the moment any one section has a
// row the ordinary screen is back. The second half is what breaks quietly — a
// block that outstays its welcome hides a record that exists.

const _unit = Unit(id: 'u1', label: 'Дім', type: UnitType.house);
const _scope = ScopeRef.unit('u1');

/// Stands in for the record itself, so the screen is tested against a list
/// rather than against a database.
class _StubAttributes extends UnitAttributes {
  _StubAttributes(this.attributes);

  final List<UnitAttribute> attributes;

  @override
  Future<List<UnitAttribute>> build(String unitId) async => attributes;
}

Future<void> _pump(
  WidgetTester tester, {
  List<UnitAttribute> attributes = const [],
  List<Document> documents = const [],
  List<Contact> contacts = const [],
  List<Unit> children = const [],
  bool canEdit = true,
  bool documentsPending = false,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        // On-device: the people half of the hub has no screens in this build,
        // and leaving it on drags the members list into a test about empties.
        appCapabilitiesProvider.overrideWithValue(
          const AppCapabilities.onDevice(),
        ),
        unitProvider('u1').overrideWith((ref) async => _unit),
        isUnitKeeperProvider('u1').overrideWithValue(canEdit),
        isUnitOwnerProvider('u1').overrideWithValue(canEdit),
        unitAttributesProvider.overrideWith2(
          (unitId) => _StubAttributes(attributes),
        ),
        documentsProvider(_scope).overrideWith(
          (ref) => documentsPending
              ? Completer<List<Document>>().future
              : Future.value(documents),
        ),
        contactsProvider(_scope).overrideWith((ref) async => contacts),
        unitChildrenProvider('u1').overrideWith((ref) async => children),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: UnitHubScreen(unitId: 'u1'),
      ),
    ),
  );

  await tester.pump();
  await tester.pump();
}

void main() {
  final l10n = AppLocalizationsUk();

  testWidgets('an object that holds nothing offers the first three moves', (
    tester,
  ) async {
    await _pump(tester);

    expect(find.text(l10n.unitStartLead), findsOneWidget);
    expect(
      find.text(l10n.unitStartFacts(UnitType.house.label(l10n).toLowerCase())),
      findsOneWidget,
    );
    expect(find.text(l10n.unitStartDocument), findsOneWidget);
    expect(find.text(l10n.unitStartContact), findsOneWidget);

    // The record it stands in for is not underneath it.
    expect(find.text(l10n.unitAttributes), findsNothing);
    expect(find.text(l10n.documents), findsNothing);
  });

  testWidgets('one fact anywhere brings the record back', (tester) async {
    await _pump(
      tester,
      attributes: const [
        UnitAttribute(id: 'a1', name: 'Рік побудови', value: '1998'),
      ],
    );

    expect(find.text(l10n.unitStartLead), findsNothing);
    expect(find.text(l10n.unitAttributes), findsOneWidget);
    expect(find.text(l10n.documents), findsOneWidget);
  });

  // A section still loading is not an empty one. Without this the block
  // flashes over a record that is on its way, on every open.
  testWidgets('a section still loading is not an empty object', (tester) async {
    await _pump(tester, documentsPending: true);

    expect(find.text(l10n.unitStartLead), findsNothing);
  });

  // The block is three first moves, and a tenant may make none of them: they
  // read the record and write nothing to it.
  testWidgets('a reader who may not write gets the ordinary screen', (
    tester,
  ) async {
    await _pump(tester, canEdit: false);

    expect(find.text(l10n.unitStartLead), findsNothing);
    expect(find.text(l10n.unitAttributes), findsOneWidget);
  });
}
