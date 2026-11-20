import 'package:dvir/app/icons.dart';
import 'package:dvir/features/Contacts/domain/models/contact.dart';
import 'package:dvir/features/Contacts/presentation/components/contact_tile.dart';
import 'package:dvir/features/Shared/domain/types/scope_ref.dart';
import 'package:dvir/features/Shared/presentation/dv_menu.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// A row of the full list says who, the number, and the call. What is pinned is
// who is offered what: the handset for everyone with a number to dial, the
// menu in sight for whoever keeps the list, and nothing that promises a call
// on a row that has no number.

Future<void> _pump(
  WidgetTester tester, {
  required Contact contact,
  required bool canEdit,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: ContactTile(
            scope: const ScopeRef.unit('u1'),
            contact: contact,
            canEdit: canEdit,
          ),
        ),
      ),
    ),
  );
}

const _electrician = Contact(
  id: 'c1',
  name: 'Сергій',
  role: 'електрик',
  phone: '+380671234567',
);

void main() {
  testWidgets('a keeper sees who, the number, the handset and the menu', (
    tester,
  ) async {
    await _pump(tester, contact: _electrician, canEdit: true);

    expect(find.text('Сергій · електрик'), findsOneWidget);
    expect(find.text('+380671234567'), findsOneWidget);
    expect(find.byIcon(AppIcons.call), findsOneWidget);
    expect(find.byType(DvMenu), findsOneWidget);
  });

  testWidgets('a tenant gets the handset and no menu', (tester) async {
    await _pump(tester, contact: _electrician, canEdit: false);

    expect(find.byIcon(AppIcons.call), findsOneWidget);
    expect(find.byType(DvMenu), findsNothing);
  });

  testWidgets('a row with no number promises no call', (tester) async {
    await _pump(
      tester,
      contact: const Contact(id: 'c2', name: 'Олена'),
      canEdit: false,
    );

    expect(find.text('Олена'), findsOneWidget);
    expect(find.byIcon(AppIcons.call), findsNothing);
    expect(tester.widget<InkWell>(find.byType(InkWell)).onTap, isNull);
  });
}
