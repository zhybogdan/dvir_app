import 'package:dvir/app/icons.dart';
import 'package:dvir/features/Contacts/application/contacts_controller.dart';
import 'package:dvir/features/Contacts/domain/models/contact.dart';
import 'package:dvir/features/Contacts/presentation/components/contacts_section.dart';
import 'package:dvir/features/Members/application/unit_members_controller.dart';
import 'package:dvir/features/Shared/domain/types/scope_ref.dart';
import 'package:dvir/features/Shared/presentation/dv_menu.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:dvir/l10n/app_localizations_uk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// Writing is `is_unit_keeper` and reading is `is_unit_member` (`0011`), which
// the database enforces on its own. What it cannot do is stop the app offering
// a tenant a button that ends at a refusal — and a tenant must still be able to
// call the plumber, which is the whole point of the list.

const _scope = ScopeRef.unit('u1');

Contact _contact(int index) =>
    Contact(id: 'c$index', name: 'Контакт $index', phone: '+3806712345$index');

List<Contact> _many(int count) => [
  for (var index = 0; index < count; index++) _contact(index),
];

Future<void> _pump(
  WidgetTester tester, {
  required bool canEdit,
  List<Contact>? contacts,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        isUnitKeeperProvider('u1').overrideWithValue(canEdit),
        contactsProvider(
          _scope,
        ).overrideWith((ref) async => contacts ?? _many(2)),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: SingleChildScrollView(child: ContactsSection(unitId: 'u1')),
        ),
      ),
    ),
  );

  await tester.pump();
}

void main() {
  final l10n = AppLocalizationsUk();

  testWidgets('a keeper is offered a way to add, and a menu on each row', (
    tester,
  ) async {
    await _pump(tester, canEdit: true);

    expect(find.text(l10n.unitAddCta), findsOneWidget);
    expect(find.byType(DvMenu), findsNWidgets(2));
  });

  // The row still dials — the handset in its place says so, where a keeper sees
  // the menu instead.
  testWidgets('a tenant reads the same numbers and is offered no menu', (
    tester,
  ) async {
    await _pump(tester, canEdit: false);

    expect(find.text('Контакт 0'), findsOneWidget);
    expect(find.text(l10n.unitAddCta), findsNothing);
    expect(find.byType(DvMenu), findsNothing);
    expect(find.byIcon(AppIcons.call), findsNWidgets(2));
  });

  testWidgets('an object with no numbers says what belongs here', (
    tester,
  ) async {
    await _pump(tester, canEdit: true, contacts: const []);

    expect(find.text(l10n.contactsEmpty), findsOneWidget);
  });

  testWidgets('a short list is shown whole, with no way out', (tester) async {
    await _pump(tester, canEdit: true, contacts: _many(contactsPreview));

    expect(find.textContaining('Показати всі'), findsNothing);
  });

  testWidgets('a longer one is cut, and the rest is one tap away', (
    tester,
  ) async {
    await _pump(tester, canEdit: true, contacts: _many(8));

    expect(find.text('Контакт 4'), findsOneWidget);
    expect(find.text('Контакт 5'), findsNothing);
    expect(find.text(l10n.contactsShowAll(8)), findsOneWidget);
  });
}
