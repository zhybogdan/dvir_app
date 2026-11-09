import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:dvir/core/database/app_database.dart';
import 'package:dvir/core/error/failures.dart';
import 'package:dvir/features/Backup/data/backup_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

/// On a real file, not in memory: both halves of a backup are about files —
/// `vacuum into` writes one and `attach` reads one — and neither would be
/// exercised at all by the in-memory database the schema test uses.
void main() {
  late Directory root;
  late Directory documents;
  late AppDatabase database;
  late BackupService service;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('dvir-backup');
    documents = Directory(p.join(root.path, 'documents'));
    database = AppDatabase(
      NativeDatabase(File(p.join(root.path, 'dvir.sqlite'))),
    );
    service = BackupService(database: database, documents: documents);
  });

  tearDown(() async {
    await database.close();
    await root.delete(recursive: true);
  });

  Future<void> insertUnit({required String id, String? parentId}) => database
      .into(database.units)
      .insert(
        UnitsCompanion.insert(
          id: id,
          parentId: Value(parentId),
          type: 'house',
          label: 'Будинок $id',
        ),
      );

  Future<void> insertAttribute() => database
      .into(database.unitAttributes)
      .insert(
        UnitAttributesCompanion.insert(
          id: 'attribute',
          unitId: 'parent',
          name: 'Рік побудови',
          value: '1998',
          createdAt: DateTime.utc(2026),
        ),
      );

  Future<void> insertDocument() => database
      .into(database.documents)
      .insert(
        DocumentsCompanion.insert(
          id: 'document',
          unitId: 'parent',
          title: 'Техпаспорт',
          storagePath: 'parent/document.jpg',
          createdAt: DateTime.utc(2026),
        ),
      );

  Future<void> insertContact() => database
      .into(database.contacts)
      .insert(
        ContactsCompanion.insert(
          id: 'contact',
          unitId: 'parent',
          name: 'Електрик',
        ),
      );

  Future<File> writeDocumentFile(String relative, String contents) async {
    final file = File(p.join(documents.path, relative));

    await file.parent.create(recursive: true);

    return file.writeAsString(contents);
  }

  /// One object with a nested one inside it, a row in every other table, and a
  /// file on disk — the smallest thing that is still a whole record.
  Future<void> fill() async {
    await insertUnit(id: 'parent');
    await insertUnit(id: 'child', parentId: 'parent');
    await insertAttribute();
    await insertDocument();
    await insertContact();
    await writeDocumentFile('parent/document.jpg', 'scan');
  }

  Future<int> countOf(String table) async {
    final row = await database
        .customSelect('select count(*) as count from $table')
        .getSingle();

    return row.read<int>('count');
  }

  /// Reads [archive] and closes it again. The stream has to be closed by hand
  /// or the temp folder cannot be deleted afterwards on Windows — the same
  /// reason `BackupService.read` closes its own.
  T inside<T>(File archive, T Function(Archive zip) read) {
    final input = InputFileStream(archive.path);
    final zip = ZipDecoder().decodeStream(input);

    try {
      return read(zip);
    } finally {
      zip.clearSync();
      input.closeSync();
    }
  }

  List<String> entriesOf(File archive) =>
      inside(archive, (zip) => zip.files.map((file) => file.name).toList());

  Map<String, dynamic> manifestOf(File archive) => inside(
    archive,
    (zip) =>
        jsonDecode(
              utf8.decode(zip.findFile('manifest.json')?.readBytes() ?? []),
            )
            as Map<String, dynamic>,
  );

  /// A zip that is shaped like a copy but is not one, for the refusals: what
  /// the picker hands over is whatever the person tapped.
  ///
  /// Its sources are written to a folder of their own — one of them is called
  /// `dvir.sqlite`, which beside the test's own database would be the live file.
  Future<File> writeArchive(Map<String, String> entries) async {
    final archive = File(p.join(root.path, 'crafted.zip'));
    final sources = await Directory(
      p.join(root.path, 'crafted'),
    ).create(recursive: true);
    final encoder = ZipFileEncoder()..create(archive.path);

    for (final entry in entries.entries) {
      final source = File(p.join(sources.path, p.basename(entry.key)));
      await source.writeAsString(entry.value);
      await encoder.addFile(source, entry.key);
    }

    await encoder.close();

    return archive;
  }

  Matcher refusedAs(BackupFailureReason reason) => throwsA(
    isA<BackupFailure>().having((failure) => failure.reason, 'reason', reason),
  );

  test(
    'a copy carries the database, the manifest and every document',
    () async {
      await fill();

      final archive = await service.write(into: root, appVersion: '1.0.0 (1)');

      expect(
        entriesOf(archive),
        containsAll([
          'dvir.sqlite',
          'manifest.json',
          'documents/parent/document.jpg',
        ]),
      );
      expect(
        p.basename(archive.path),
        matches(r'^dvir-\d{4}-\d{2}-\d{2}\.zip$'),
      );
    },
  );

  test('the manifest counts what is in the copy', () async {
    await fill();

    final archive = await service.write(into: root, appVersion: '1.0.0 (1)');
    final manifest = manifestOf(archive);

    expect(manifest['format_version'], 1);
    expect(manifest['schema_version'], database.schemaVersion);
    expect(manifest['app_version'], '1.0.0 (1)');
    expect(manifest['units'], 2);
    expect(manifest['attributes'], 1);
    expect(manifest['documents'], 1);
    expect(manifest['contacts'], 1);
  });

  test('the working copy of the snapshot does not outlive the call', () async {
    await fill();

    await service.write(into: root, appVersion: '1.0.0 (1)');

    expect(Directory(p.join(root.path, 'backup-work')).existsSync(), isFalse);
  });

  test('restoring brings back rows that were deleted', () async {
    await fill();
    final archive = await service.write(into: root, appVersion: '1.0.0 (1)');

    // One delete empties every table: each of them references the object with
    // `on delete cascade`.
    await database.customStatement('delete from units');
    expect(await countOf('units'), 0);

    await service.restore(archive, work: root);

    expect(await countOf('units'), 2);
    expect(await countOf('unit_attributes'), 1);
    expect(await countOf('documents'), 1);
    expect(await countOf('contacts'), 1);
  });

  test('a restored nested object still points at its parent', () async {
    await fill();
    final archive = await service.write(into: root, appVersion: '1.0.0 (1)');

    await database.customStatement('delete from units');
    await service.restore(archive, work: root);

    final child = await (database.select(
      database.units,
    )..where((unit) => unit.id.equals('child'))).getSingle();

    expect(child.parentId, 'parent');
  });

  test('restoring replaces the files, it does not merge them', () async {
    await fill();
    final archive = await service.write(into: root, appVersion: '1.0.0 (1)');

    await writeDocumentFile('parent/document.jpg', 'edited after the copy');
    await writeDocumentFile('parent/later.jpg', 'added after the copy');

    await service.restore(archive, work: root);

    expect(
      File(p.join(documents.path, 'parent', 'document.jpg')).readAsStringSync(),
      'scan',
    );
    expect(
      File(p.join(documents.path, 'parent', 'later.jpg')).existsSync(),
      isFalse,
    );
  });

  test('restoring a copy that carries no files leaves none behind', () async {
    await insertUnit(id: 'parent');
    final archive = await service.write(into: root, appVersion: '1.0.0 (1)');

    await writeDocumentFile('parent/document.jpg', 'scan');
    await service.restore(archive, work: root);

    expect(documents.existsSync(), isFalse);
  });

  test('the unpacked copy does not outlive the restore', () async {
    await fill();
    final archive = await service.write(into: root, appVersion: '1.0.0 (1)');

    await service.restore(archive, work: root);

    expect(
      Directory(p.join(root.path, 'backup-restore')).existsSync(),
      isFalse,
    );
  });

  test(
    'a file that is not an archive is refused, and nothing is touched',
    () async {
      await fill();
      final notAnArchive = File(p.join(root.path, 'photo.jpg'));
      await notAnArchive.writeAsString('not a zip at all');

      await expectLater(
        service.read(notAnArchive),
        refusedAs(BackupFailureReason.notABackup),
      );
      await expectLater(
        service.restore(notAnArchive, work: root),
        refusedAs(BackupFailureReason.notABackup),
      );
      expect(await countOf('units'), 2);
    },
  );

  test('an archive without our parts in it is refused', () async {
    final archive = await writeArchive({'notes.txt': 'holiday photos'});

    await expectLater(
      service.read(archive),
      refusedAs(BackupFailureReason.notABackup),
    );
  });

  test('an archive whose manifest is not ours is refused', () async {
    final archive = await writeArchive({
      'dvir.sqlite': 'pretending',
      'manifest.json': '{"hello":"world"}',
    });

    await expectLater(
      service.read(archive),
      refusedAs(BackupFailureReason.notABackup),
    );
  });

  test('a copy from a newer schema is refused rather than read', () async {
    final archive = await writeArchive({
      'dvir.sqlite': 'pretending',
      'manifest.json': jsonEncode({
        'format_version': 1,
        'schema_version': database.schemaVersion + 1,
        'created_at': DateTime.utc(2026).toIso8601String(),
        'app_version': '2.0.0 (9)',
        'units': 1,
        'attributes': 0,
        'documents': 0,
        'contacts': 0,
      }),
    });

    await expectLater(
      service.read(archive),
      refusedAs(BackupFailureReason.fromNewerApp),
    );
  });

  test('a file that is not there is not called a bad copy', () async {
    await expectLater(
      service.read(File(p.join(root.path, 'never-existed.zip'))),
      refusedAs(BackupFailureReason.cannotRead),
    );
  });

  test('nowhere to write the copy is its own refusal', () async {
    await fill();
    // A path whose parent is a file: creating a directory there fails the way a
    // device with no room left fails, which is the branch being checked.
    final blocked = File(p.join(root.path, 'blocked'));
    await blocked.writeAsString('not a directory');

    await expectLater(
      service.write(
        into: Directory(p.join(blocked.path, 'inside')),
        appVersion: '1.0.0 (1)',
      ),
      refusedAs(BackupFailureReason.cannotWrite),
    );
  });

  test('rows restored without their files say exactly that', () async {
    await fill();
    final archive = await service.write(into: root, appVersion: '1.0.0 (1)');

    await database.customStatement('delete from units');
    await documents.delete(recursive: true);

    // A file standing where the documents folder belongs: the rows go in, and
    // then there is nowhere to put the scans.
    await File(documents.path).writeAsString('in the way');

    await expectLater(
      service.restore(archive, work: root),
      refusedAs(BackupFailureReason.filesIncomplete),
    );
    // The half the message promises: the record itself did arrive.
    expect(await countOf('units'), 2);
  });

  /// The guard the list in `backup_service.dart` exists for: a table added to
  /// the schema and forgotten here would be silently absent from every copy,
  /// and nobody would find out until a restore came back short.
  test('a copy carries every table the schema has', () {
    expect(
      database.allTables.map((table) => table.actualTableName).toSet(),
      backupTables.toSet(),
    );
  });
}
