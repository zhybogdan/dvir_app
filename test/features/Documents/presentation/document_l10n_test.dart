import 'package:dvir/app/icons.dart';
import 'package:dvir/features/Documents/domain/models/document.dart';
import 'package:dvir/features/Documents/presentation/document_l10n.dart';
import 'package:dvir/l10n/app_localizations_uk.dart';
import 'package:flutter_test/flutter_test.dart';

// The second line of a row answers one question — is this the scan or the
// thumbnail — and `0010` made both halves of it nullable, because the columns
// were added to a table that already existed. A row that predates them must
// still read as a row.

Document _document({
  String path = 'scope/doc.pdf',
  String? mimeType = 'application/pdf',
  int? sizeBytes = 2516582,
}) => Document(
  id: 'd1',
  title: 'Техпаспорт',
  storagePath: path,
  createdAt: DateTime(2026, 8, 3),
  mimeType: mimeType,
  sizeBytes: sizeBytes,
);

void main() {
  final l10n = AppLocalizationsUk();

  group('documentSize', () {
    test('megabytes keep one decimal, with this locale comma', () {
      expect(documentSize(2516582, l10n), '2,4 МБ');
    });

    test('anything under a megabyte is whole kilobytes', () {
      expect(documentSize(831488, l10n), '812 КБ');
    });

    // Rounding up, not down: a 400-byte file reading "0 KB" looks like the
    // upload lost it.
    test('a tiny file is still a kilobyte', () {
      expect(documentSize(400, l10n), '1 КБ');
    });

    test('a size nobody recorded is not invented', () {
      expect(documentSize(null, l10n), isNull);
      expect(documentSize(0, l10n), isNull);
    });
  });

  group('documentSubtitle', () {
    test('is the type and the size', () {
      expect(documentSubtitle(_document(), l10n), 'PDF · 2,4 МБ');
    });

    test('drops the half it does not have instead of leaving a separator', () {
      expect(documentSubtitle(_document(sizeBytes: null), l10n), 'PDF');
      expect(documentSubtitle(_document(path: 'scope/doc'), l10n), '2,4 МБ');
    });

    test('a row from before 0010 has no second line at all', () {
      final bare = _document(
        path: 'scope/doc',
        mimeType: null,
        sizeBytes: null,
      );

      expect(documentSubtitle(bare, l10n), isEmpty);
    });
  });

  group('documentIcon', () {
    test('tells a photo from the paper about it', () {
      expect(
        documentIcon(_document(mimeType: 'image/jpeg')),
        AppIcons.documentImage,
      );
      expect(documentIcon(_document()), AppIcons.documentPdf);
      expect(documentIcon(_document(mimeType: null)), AppIcons.documentGeneric);
    });
  });

  test('the date is padded, so a list of them lines up', () {
    expect(documentAddedOn(DateTime(2026, 8, 3), l10n), contains('03.08.2026'));
  });
}
