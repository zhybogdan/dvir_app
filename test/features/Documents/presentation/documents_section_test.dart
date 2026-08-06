import 'package:dvir/features/Documents/application/documents_controller.dart';
import 'package:dvir/features/Documents/domain/models/document.dart';
import 'package:dvir/features/Documents/presentation/components/documents_section.dart';
import 'package:dvir/features/Members/application/unit_members_controller.dart';
import 'package:dvir/features/Shared/domain/types/scope_ref.dart';
import 'package:dvir/features/Shared/presentation/dv_menu.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:dvir/l10n/app_localizations_uk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// Writing is `is_unit_keeper` and reading is `is_unit_member` (`0010`), which
// the database enforces on its own. What it cannot do is stop the app offering
// a tenant a button that ends at a refusal — so what is checked here is that
// the section asks the question and shows only what the answer allows.

const _scope = ScopeRef.unit('u1');

Document _document(int index) => Document(
  id: 'd$index',
  title: 'Документ $index',
  storagePath: 'u1/d$index.pdf',
  createdAt: DateTime(2026, 8, 3),
  mimeType: 'application/pdf',
  sizeBytes: 1024 * 512,
);

List<Document> _many(int count) => [
  for (var index = 0; index < count; index++) _document(index),
];

Future<void> _pump(
  WidgetTester tester, {
  required bool canEdit,
  List<Document>? documents,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        isUnitKeeperProvider('u1').overrideWithValue(canEdit),
        documentsProvider(
          _scope,
        ).overrideWith((ref) async => documents ?? _many(2)),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: SingleChildScrollView(child: DocumentsSection(unitId: 'u1')),
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

  testWidgets('a tenant reads the same files and is offered neither', (
    tester,
  ) async {
    await _pump(tester, canEdit: false);

    expect(find.text('Документ 0'), findsOneWidget);
    expect(find.text(l10n.unitAddCta), findsNothing);
    expect(find.byType(DvMenu), findsNothing);
  });

  testWidgets('an object with no papers says what belongs here', (
    tester,
  ) async {
    await _pump(tester, canEdit: true, documents: const []);

    expect(find.text(l10n.documentsEmpty), findsOneWidget);
  });

  testWidgets('a short list is shown whole, with no way out', (tester) async {
    await _pump(tester, canEdit: true, documents: _many(documentsPreview));

    expect(find.textContaining('Показати всі'), findsNothing);
  });

  // The count is everything kept, not what is left over — the line has to name
  // the total or it reads as an oversight.
  testWidgets('a longer one is cut, and the rest is one tap away', (
    tester,
  ) async {
    await _pump(tester, canEdit: true, documents: _many(8));

    expect(find.text('Документ 4'), findsOneWidget);
    expect(find.text('Документ 5'), findsNothing);
    expect(find.text(l10n.documentsShowAll(8)), findsOneWidget);
  });
}
