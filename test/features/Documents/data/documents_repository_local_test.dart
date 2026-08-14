import 'dart:io';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:dvir/core/database/app_database.dart';
import 'package:dvir/core/database/local_scope.dart';
import 'package:dvir/core/error/failures.dart';
import 'package:dvir/core/utils/field_lengths.dart';
import 'package:dvir/features/Documents/data/document_file_store.dart';
import 'package:dvir/features/Documents/data/document_storage.dart';
import 'package:dvir/features/Documents/data/documents_repository_local.dart';
import 'package:dvir/features/Documents/domain/models/document_upload.dart';
import 'package:dvir/features/Shared/domain/types/scope_ref.dart';
import 'package:dvir/features/Units/data/units_repository_local.dart';
import 'package:dvir/features/Units/domain/types/unit_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late Directory root;
  late LocalDocumentsRepository repository;
  late ScopeRef scope;

  final bytes = Uint8List.fromList([1, 2, 3, 4]);

  DocumentUpload upload({String title = 'Технічний паспорт'}) => DocumentUpload(
    title: title,
    fileName: 'passport.pdf',
    mimeType: 'application/pdf',
    bytes: bytes,
  );

  List<File> storedFiles() =>
      root.listSync(recursive: true).whereType<File>().toList();

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    root = await Directory.systemTemp.createTemp('dvir_documents');
    repository = LocalDocumentsRepository(
      database,
      LocalDocumentFileStore(root),
    );

    final unit = await LocalUnitsRepository(
      database,
    ).createUnit(label: 'Будинок', type: UnitType.house);
    scope = ScopeRef.unit(unit.id);
  });
  tearDown(() async {
    await database.close();
    await root.delete(recursive: true);
  });

  test('an uploaded file is recorded and reads back', () async {
    await repository.upload(scope: scope, file: upload());

    final stored = (await repository.documentsOf(scope)).single;

    expect(stored.title, 'Технічний паспорт');
    expect(stored.mimeType, 'application/pdf');
    expect(stored.sizeBytes, 4);
    expect(stored.originalName, 'passport.pdf');
    expect(await repository.download(stored), bytes);
  });

  test('the list reads newest first', () async {
    // The dates are written directly rather than by three uploads in a row:
    // those would land within the same millisecond and leave the expected order
    // up to the clock. Written out, this also checks the thing worth checking —
    // that ISO-8601 text in UTC sorts by time and not merely as a string.
    Future<void> recordedOn(String title, DateTime createdAt) => database
        .into(database.documents)
        .insert(
          DocumentsCompanion.insert(
            id: title,
            unitId: scope.unitId,
            title: title,
            storagePath: '${scope.unitId}/$title.pdf',
            createdAt: createdAt,
          ),
        );

    await recordedOn('Перший', DateTime.utc(2026, 8, 9));
    await recordedOn('Третій', DateTime.utc(2026, 8, 10, 23, 59));
    await recordedOn('Другий', DateTime.utc(2026, 8, 10, 8));

    expect((await repository.documentsOf(scope)).map((one) => one.title), [
      'Третій',
      'Другий',
      'Перший',
    ]);
  });

  test('a file past the limit is refused before it reaches the disk', () async {
    await expectLater(
      repository.upload(
        scope: scope,
        file: DocumentUpload(
          title: 'Відео з двору',
          fileName: 'yard.mp4',
          mimeType: 'video/mp4',
          bytes: Uint8List(maxDocumentBytes + 1),
        ),
      ),
      throwsA(
        isA<StorageFailure>().having(
          (failure) => failure.reason,
          'reason',
          StorageFailureReason.tooLarge,
        ),
      ),
    );

    expect(await repository.documentsOf(scope), isEmpty);
    expect(storedFiles(), isEmpty);
  });

  test('a file exactly at the limit is kept', () async {
    await repository.upload(
      scope: scope,
      file: DocumentUpload(
        title: 'Скан',
        fileName: 'scan.pdf',
        mimeType: 'application/pdf',
        bytes: Uint8List(maxDocumentBytes),
      ),
    );

    expect(
      (await repository.documentsOf(scope)).single.sizeBytes,
      maxDocumentBytes,
    );
  });

  test('a file whose row is refused does not stay behind', () async {
    // The row fails on the title's length check, after the bytes are already
    // written — which is the exact case the ordering was chosen for.
    await expectLater(
      repository.upload(
        scope: scope,
        file: upload(title: 'д' * (FieldLength.documentTitle + 1)),
      ),
      throwsA(isA<Exception>()),
    );

    expect(await repository.documentsOf(scope), isEmpty);
    expect(storedFiles(), isEmpty);
  });

  test('deleting takes the row and the file with it', () async {
    await repository.upload(scope: scope, file: upload());
    final stored = (await repository.documentsOf(scope)).single;

    await repository.delete(stored);

    expect(await repository.documentsOf(scope), isEmpty);
    expect(storedFiles(), isEmpty);
  });

  test('renaming leaves the file where it is', () async {
    await repository.upload(scope: scope, file: upload());
    final stored = (await repository.documentsOf(scope)).single;

    await repository.rename(id: stored.id, title: 'Договір');

    final renamed = (await repository.documentsOf(scope)).single;

    expect(renamed.title, 'Договір');
    // The key is a uuid and the name a person reads was never part of it.
    expect(renamed.storagePath, stored.storagePath);
    expect(await repository.download(renamed), bytes);
  });

  test('files of another object are not in this list', () async {
    final other = await LocalUnitsRepository(
      database,
    ).createUnit(label: 'Дача', type: UnitType.summerHouse);

    await repository.upload(scope: scope, file: upload());
    await repository.upload(scope: ScopeRef.unit(other.id), file: upload());

    expect(await repository.documentsOf(scope), hasLength(1));
  });

  test('a community scope refuses rather than answers emptily', () async {
    const community = ScopeRef.community('any');

    expect(() => repository.documentsOf(community), throwsUnsupportedError);
    await expectLater(
      repository.upload(scope: community, file: upload()),
      throwsUnsupportedError,
    );
  });
}
