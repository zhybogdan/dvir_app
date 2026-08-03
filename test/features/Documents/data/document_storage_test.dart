import 'package:dvir/features/Documents/data/document_storage.dart';
import 'package:flutter_test/flutter_test.dart';

// The storage key is not cosmetic: `0010`'s policies cast its first segment to
// a uuid and hand it to the scope predicates. A key with an extra segment in
// front, or a slash smuggled in from a file name, is read as a different
// scope's folder — and a cast that fails raises inside the policy rather than
// answering false, which breaks every read of the bucket for everyone.
void main() {
  const String scope = '11111111-1111-1111-1111-111111111111';
  const String document = '22222222-2222-2222-2222-222222222222';

  group('documentStoragePath', () {
    test('is the scope, the id and the extension — nothing in front', () {
      expect(
        documentStoragePath(
          scopeId: scope,
          documentId: document,
          fileName: 'Договір.pdf',
        ),
        '$scope/$document.pdf',
      );
    });

    test('a file without an extension still gets a one-segment key', () {
      final path = documentStoragePath(
        scopeId: scope,
        documentId: document,
        fileName: 'scan',
      );

      expect(path, '$scope/$document');
      expect('/'.allMatches(path), hasLength(1));
    });

    test('a name carrying a path cannot add a segment to the key', () {
      final path = documentStoragePath(
        scopeId: scope,
        documentId: document,
        fileName: 'photo.jpg/../../other-scope/x',
      );

      expect('/'.allMatches(path), hasLength(1));
      expect(path, startsWith('$scope/$document'));
    });
  });

  group('documentExtension', () {
    test('is lowercased and loses its dot', () {
      expect(documentExtension('SCAN.PDF'), 'pdf');
    });

    test('takes the last one', () {
      expect(documentExtension('archive.tar.gz'), 'gz');
    });

    test('is empty when there is nothing to take', () {
      expect(documentExtension('scan'), isEmpty);
      expect(documentExtension('scan.'), isEmpty);
      expect(documentExtension('.gitignore'), 'gitignore');
    });

    test('a long tail after a dot is a name, not an extension', () {
      expect(documentExtension('акт від 12.03 про приймання'), isEmpty);
    });
  });
}
