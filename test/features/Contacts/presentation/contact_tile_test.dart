import 'package:dvir/app/icons.dart';
import 'package:dvir/core/config/app_locales.dart';
import 'package:dvir/features/Contacts/domain/models/contact.dart';
import 'package:dvir/features/Contacts/presentation/components/contact_tile.dart';
import 'package:dvir/features/Shared/domain/types/scope_ref.dart';
import 'package:dvir/features/Shared/presentation/dv_menu.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:dvir/l10n/app_localizations_uk.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

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
        localizationsDelegates: AppLocales.delegates,
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

  testWidgets('the menu copies the number', (tester) async {
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map<Object?, Object?>)['text'] as String?;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );

    await _pump(tester, contact: _electrician, canEdit: true);
    await tester.tap(find.byType(DvMenu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Скопіювати номер'));
    // Past the toast's own timer, which would otherwise outlive the test.
    await tester.pumpAndSettle(const Duration(seconds: 10));

    expect(copied, '+380671234567');
  });

  testWidgets('a contact with no number offers nothing to copy', (
    tester,
  ) async {
    await _pump(
      tester,
      contact: const Contact(id: 'c2', name: 'Олена'),
      canEdit: true,
    );
    await tester.tap(find.byType(DvMenu));
    await tester.pumpAndSettle();

    expect(find.text('Скопіювати номер'), findsNothing);
  });

  test('a contact goes to a chat with who it is and the number', () {
    final l10n = AppLocalizationsUk();

    expect(
      ContactTile.shareTextFor(_electrician, '+380671234567', l10n),
      'Сергій, електрик: +380671234567',
    );
    expect(
      ContactTile.shareTextFor(
        const Contact(id: 'c3', name: 'Олена'),
        '104',
        l10n,
      ),
      'Олена: 104',
    );
  });

  testWidgets('the menu offers to send the number as well as copy it', (
    tester,
  ) async {
    await _pump(tester, contact: _electrician, canEdit: true);
    await tester.tap(find.byType(DvMenu));
    await tester.pumpAndSettle();

    expect(find.text('Поділитися'), findsOneWidget);
  });
}
