import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:dvir/core/database/app_database.dart';
import 'package:dvir/core/error/failures.dart';
import 'package:dvir/core/extensions/date_time_x.dart';
import 'package:dvir/core/logging/app_logger.dart';
import 'package:dvir/features/Backup/domain/models/backup_manifest.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'backup_service.g.dart';

/// Defaults to throwing, and `main_unit.dart` overrides it.
///
/// The mirror of what that file does to `supabaseClientProvider`, for the
/// opposite reason: a copy of the whole phone only means something where the
/// phone is the only place the data lives. A build with a backend behind it
/// backs up on the server, not by zipping a device, so there is nothing here
/// for it to be given.
@Riverpod(keepAlive: true)
BackupService backupService(Ref ref) =>
    throw UnsupportedError('This build has no backup.');

/// Where a copy is written and where one is unpacked.
///
/// The system temp folder on purpose. The copy is handed straight to the share
/// sheet and is of no use afterwards, and the app's own documents folder is
/// where the object's files live — copies accumulating in there would be
/// counted as the weight of the object they are a copy of.
@Riverpod(keepAlive: true)
Future<Directory> backupWorkspace(Ref ref) => getTemporaryDirectory();

/// The tables a copy carries, parents before children.
///
/// Written out rather than taken from `database.allTables`, which has no order
/// and would silently change what a copy contains the day a table is added.
/// `backup_service_test.dart` fails when the schema holds a table this list
/// does not, which is the reminder to decide rather than to find out later.
const List<String> backupTables = [
  'units',
  'unit_attributes',
  'documents',
  'contacts',
];

/// Everything this phone holds, as one file the person keeps somewhere else.
///
/// The `unit` build has no account and no server: what it stores — the scans,
/// the photo of what is now behind a wall — exists on exactly one device, so a
/// lost phone is a lost archive unless this exists.
///
/// It is a **copy**, not synchronisation. Two phones editing the same object
/// and meeting later needs change dates and conflict rules this schema does not
/// have, so restoring replaces, and the screen says so before it does.
class BackupService {
  const BackupService({required this.database, required this.documents});

  final AppDatabase database;

  /// The folder `LocalDocumentFileStore` keeps its files in. Passed in for the
  /// reason the store takes it too: resolving it is an async platform lookup,
  /// and a service that needs one cannot be built inside a provider.
  final Directory documents;

  static const String _databaseEntry = 'dvir.sqlite';
  static const String _manifestEntry = 'manifest.json';
  static const String _documentsEntry = 'documents';

  /// Writes a copy into [into] and returns the file, for the share sheet to
  /// hand onward.
  ///
  /// [appVersion] is carried only to be read by a human looking at a copy from
  /// a year ago; nothing branches on it.
  Future<File> write({
    required Directory into,
    required String appVersion,
  }) async {
    try {
      return await _write(into: into, appVersion: appVersion);
    } on FileSystemException catch (error, stackTrace) {
      // The one refusal the person can act on, and the likeliest one on a phone
      // that has been filling up for two years.
      //
      // sqlite's own refusals do not arrive here — a full disk during
      // `vacuum into` is its exception, not the file system's, and on a device
      // it crosses an isolate boundary wrapped in drift's own. Naming it from
      // here would be a guess at two layers at once, so it stays in the branch
      // below, which logs what actually happened. Map it once a device has
      // shown what it looks like.
      appLogger.d('Could not write a backup: ${error.message} ${error.path}');
      Error.throwWithStackTrace(
        const BackupFailure(BackupFailureReason.cannotWrite),
        stackTrace,
      );
    } catch (error, stackTrace) {
      appLogger.e(
        'Unexpected error writing a backup',
        error: error,
        stackTrace: stackTrace,
      );
      Error.throwWithStackTrace(
        const BackupFailure(BackupFailureReason.unknown),
        stackTrace,
      );
    }
  }

  Future<File> _write({
    required Directory into,
    required String appVersion,
  }) async {
    final work = await _emptyDirectory(p.join(into.path, 'backup-work'));

    try {
      final snapshot = File(p.join(work.path, _databaseEntry));

      // Not a file copy. The database is open and may hold part of itself in a
      // journal, so the only thing that knows when the bytes on disk are a
      // whole database is sqlite — this is it saying so.
      await database.customStatement('vacuum into ?', [snapshot.path]);

      final manifest = File(p.join(work.path, _manifestEntry));
      await manifest.writeAsString(
        jsonEncode(
          BackupManifest(
            formatVersion: backupFormatVersion,
            schemaVersion: database.schemaVersion,
            createdAt: DateTime.now(),
            appVersion: appVersion,
            units: await _countOf('units'),
            attributes: await _countOf('unit_attributes'),
            documents: await _countOf('documents'),
            contacts: await _countOf('contacts'),
          ).toJson(),
        ),
      );

      // Dated, because somebody keeping three copies in one folder has nothing
      // else to tell them apart by.
      final archive = File(
        p.join(into.path, 'dvir-${DateTime.now().asFileStamp}.zip'),
      );
      final encoder = ZipFileEncoder()..create(archive.path);

      try {
        await encoder.addFile(snapshot, _databaseEntry);
        await encoder.addFile(manifest, _manifestEntry);

        for (final file in _filesUnder(documents)) {
          await encoder.addFile(file, _entryFor(file));
        }
      } finally {
        await encoder.close();
      }

      return archive;
    } finally {
      await _discard(work);
    }
  }

  /// What [file] claims to be, or a [BackupFailure] saying why it is not a copy
  /// of ours.
  ///
  /// Separate from [restore] because the person is shown this and then decides:
  /// a copy made three months ago is a different answer than one made today.
  Future<BackupManifest> read(File file) async {
    try {
      return await _read(file);
    } on BackupFailure {
      rethrow;
    } on FileSystemException catch (error, stackTrace) {
      // Deliberately not "this is not a backup": the file may be a perfectly
      // good copy that is simply out of reach, and telling someone their copy
      // is rubbish when it is not is the worst sentence this screen could say.
      appLogger.d('Could not read a backup: ${error.message} ${error.path}');
      Error.throwWithStackTrace(
        const BackupFailure(BackupFailureReason.cannotRead),
        stackTrace,
      );
    } catch (error, stackTrace) {
      appLogger.e(
        'Unexpected error reading a backup',
        error: error,
        stackTrace: stackTrace,
      );
      Error.throwWithStackTrace(
        const BackupFailure(BackupFailureReason.unknown),
        stackTrace,
      );
    }
  }

  Future<BackupManifest> _read(File file) async {
    final input = InputFileStream(file.path);

    try {
      final archive = _decode(input);

      try {
        final manifest = archive.findFile(_manifestEntry)?.readBytes();

        if (manifest == null || archive.findFile(_databaseEntry) == null) {
          throw const BackupFailure(BackupFailureReason.notABackup);
        }

        return _checked(_parse(manifest));
      } finally {
        archive.clearSync();
      }
    } finally {
      // Closed by hand, and in a `finally` that also covers a file that turned
      // out not to be an archive at all: until something closes the stream the
      // file stays open, and on Windows an open handle is a file that nothing —
      // including the unpacking a restore does next — can delete.
      input.closeSync();
    }
  }

  /// Replaces everything this phone holds with what [file] carries, unpacking
  /// through [work].
  ///
  /// Rows first and in one transaction, then the files. A failure among the
  /// files leaves rows pointing at documents that are not there, which is a
  /// case the app already answers (a row that outlived its file); the reverse
  /// order would delete the person's own scans under rows that never arrived.
  Future<void> restore(File file, {required Directory work}) async {
    // Checked again rather than trusting that the caller called [read]: this is
    // the method that deletes, so what it refuses it must refuse on its own.
    await read(file);

    final unpacked = await _emptyDirectory(p.join(work.path, 'backup-restore'));

    try {
      // Unpacking and the rows together: both happen before anything the person
      // has is touched, so whatever goes wrong in here leaves the record as it
      // was — the rows go in one transaction, and it rolls back.
      try {
        await extractFileToDisk(file.path, unpacked.path);

        final snapshot = File(p.join(unpacked.path, _databaseEntry));
        if (!snapshot.existsSync()) {
          throw const BackupFailure(BackupFailureReason.notABackup);
        }

        await _replaceRows(snapshot);
      } on BackupFailure {
        rethrow;
      } catch (error, stackTrace) {
        appLogger.e(
          'Could not restore the rows of a backup',
          error: error,
          stackTrace: stackTrace,
        );
        Error.throwWithStackTrace(
          const BackupFailure(BackupFailureReason.restoreFailed),
          stackTrace,
        );
      }

      // Past this line the rows are already the copy's, so a failure is not
      // "nothing changed" and must not be reported as one: the record is
      // restored and some of the documents behind it are missing. Restoring
      // from the same copy again is what fixes it, which is what it says.
      try {
        await _replaceFiles(Directory(p.join(unpacked.path, _documentsEntry)));
      } catch (error, stackTrace) {
        appLogger.e(
          'Restored the rows of a backup but not all of its files',
          error: error,
          stackTrace: stackTrace,
        );
        Error.throwWithStackTrace(
          const BackupFailure(BackupFailureReason.filesIncomplete),
          stackTrace,
        );
      }
    } finally {
      await _discard(unpacked);
    }
  }

  /// Copies the snapshot's rows over the live ones.
  ///
  /// `attach` cannot run inside a transaction, which is why only the copying is
  /// wrapped in one — and wrapped it must be, or a failure halfway through
  /// leaves the record half replaced.
  Future<void> _replaceRows(File snapshot) async {
    await database.customStatement('attach database ? as backup', [
      snapshot.path,
    ]);

    try {
      await database.transaction(() async {
        // A nested object references its parent in the same table, and nothing
        // promises the order rows come back in: an index scan is free to hand
        // back a child before the parent two rows further on. Deferring moves
        // every foreign-key check to the commit, where the table is whole
        // again. It lasts as long as the transaction, which is why it is set
        // inside one.
        await database.customStatement('pragma defer_foreign_keys = on');

        for (final table in backupTables.reversed) {
          await database.customStatement('delete from $table');
        }

        for (final table in backupTables) {
          await database.customStatement(
            'insert into $table select * from backup.$table',
          );
        }
      });
    } finally {
      await database.customStatement('detach database backup');
    }
  }

  /// The documents folder, as the copy has it.
  ///
  /// The live folder goes even when the copy carries none: the rows have
  /// already been replaced, and a scan left over from the old data would sit
  /// under a row that knows nothing about it.
  Future<void> _replaceFiles(Directory from) async {
    if (documents.existsSync()) await documents.delete(recursive: true);
    if (!from.existsSync()) return;

    for (final file in _filesUnder(from)) {
      final target = File(
        p.join(documents.path, p.relative(file.path, from: from.path)),
      );

      await target.parent.create(recursive: true);
      await file.copy(target.path);
    }
  }

  BackupManifest _checked(BackupManifest manifest) {
    // Equality rather than a range, and the line to revisit the day the local
    // schema gets its first migration: from then on a *lower* version is an
    // older copy worth migrating, not a file to refuse.
    if (manifest.formatVersion != backupFormatVersion ||
        manifest.schemaVersion != database.schemaVersion) {
      throw const BackupFailure(BackupFailureReason.fromNewerApp);
    }

    return manifest;
  }

  /// A manifest that does not parse is not a manifest: the archive came through
  /// the device's own picker, so it is whatever the person tapped.
  ///
  /// [TypeError] alongside the format errors because a field of the wrong type,
  /// or missing where it is required, is how a generated `fromJson` says so —
  /// an `Error` rather than an `Exception`, but still a statement about foreign
  /// data and not about this code.
  BackupManifest _parse(List<int> manifest) {
    try {
      return BackupManifest.fromJson(
        jsonDecode(utf8.decode(manifest)) as Map<String, dynamic>,
      );
    } on FormatException {
      throw const BackupFailure(BackupFailureReason.notABackup);
    } on TypeError {
      throw const BackupFailure(BackupFailureReason.notABackup);
    }
  }

  /// `ArchiveException` is a [FormatException], so one branch covers both a file
  /// that is no zip at all and a zip that is damaged. Anything else is left to
  /// the caller, which logs it rather than calling it the wrong file.
  Archive _decode(InputFileStream input) {
    try {
      return ZipDecoder().decodeStream(input);
    } on FormatException {
      throw const BackupFailure(BackupFailureReason.notABackup);
    }
  }

  Future<int> _countOf(String table) async {
    final row = await database
        .customSelect('select count(*) as count from $table')
        .getSingle();

    return row.read<int>('count');
  }

  /// Forward slashes and a prefix of its own rather than the folder's name: an
  /// entry's path inside the archive is part of the format, and it must not
  /// change because the directory it came from was renamed.
  String _entryFor(File file) => p.posix.joinAll([
    _documentsEntry,
    ...p.split(p.relative(file.path, from: documents.path)),
  ]);

  Iterable<File> _filesUnder(Directory directory) => directory.existsSync()
      ? directory.listSync(recursive: true).whereType<File>()
      : const [];

  /// Gets rid of a working folder, and says so rather than failing if it
  /// cannot.
  ///
  /// A folder left in the app's own temp space is harmless. Letting its
  /// deletion throw is not: it runs in a `finally`, so it would turn a copy
  /// that was written, or a restore that finished, into an error.
  Future<void> _discard(Directory directory) async {
    try {
      await directory.delete(recursive: true);
    } on FileSystemException catch (error) {
      appLogger.d('Left a backup folder behind: ${error.message}');
    }
  }

  Future<Directory> _emptyDirectory(String path) async {
    final directory = Directory(path);

    if (directory.existsSync()) await directory.delete(recursive: true);

    return directory.create(recursive: true);
  }
}
