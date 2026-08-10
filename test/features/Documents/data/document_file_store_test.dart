import 'dart:io';
import 'dart:typed_data';

import 'package:dvir/core/error/failures.dart';
import 'package:dvir/features/Documents/data/document_file_store.dart';
import 'package:dvir/features/Documents/data/document_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory root;
  late LocalDocumentFileStore store;

  final bytes = Uint8List.fromList([1, 2, 3, 4]);

  final path = documentStoragePath(
    scopeId: 'unit',
    documentId: 'document',
    fileName: 'Технічний паспорт.pdf',
  );

  setUp(() async {
    root = await Directory.systemTemp.createTemp('dvir_documents');
    store = LocalDocumentFileStore(root);
  });
  tearDown(() => root.delete(recursive: true));

  test('bytes come back the way they went in', () async {
    await store.write(path, bytes);

    expect(await store.read(path), bytes);
  });

  test('the folder a path implies is created on the way', () async {
    // The scope's folder does not exist until its first document does, and a
    // write that assumed otherwise would fail on the very first one.
    expect(root.listSync(), isEmpty);

    await store.write(path, bytes);

    expect(File('${root.path}/unit/document.pdf').existsSync(), isTrue);
  });

  test('a row that outlived its file reads as missing', () async {
    await expectLater(
      store.read(path),
      throwsA(
        isA<StorageFailure>().having(
          (failure) => failure.reason,
          'reason',
          StorageFailureReason.missing,
        ),
      ),
    );
  });

  test('removing takes the file', () async {
    await store.write(path, bytes);

    await store.remove(path);

    expect(File('${root.path}/unit/document.pdf').existsSync(), isFalse);
  });

  test('removing what is already gone is not an error', () async {
    // The caller is getting rid of it either way, and the cloud's own delete
    // does not complain about an object that has already left.
    await expectLater(store.remove(path), completes);
  });

  test('a second document of the same object joins the first', () async {
    final other = documentStoragePath(
      scopeId: 'unit',
      documentId: 'second',
      fileName: 'meter.jpg',
    );

    await store.write(path, bytes);
    await store.write(other, bytes);

    expect(
      Directory('${root.path}/unit').listSync().map(
        (entity) => entity.path.split(Platform.pathSeparator).last,
      ),
      containsAll(['document.pdf', 'second.jpg']),
    );
  });
}
