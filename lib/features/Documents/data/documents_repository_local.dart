import 'package:drift/drift.dart';
import 'package:dvir/core/database/app_database.dart';
import 'package:dvir/core/database/local_scope.dart';
import 'package:dvir/features/Documents/data/document_file_store.dart';
import 'package:dvir/features/Documents/data/document_storage.dart';
import 'package:dvir/features/Documents/data/documents_repository.dart';
import 'package:dvir/features/Documents/domain/models/document.dart';
import 'package:dvir/features/Documents/domain/models/document_upload.dart';
import 'package:dvir/features/Shared/domain/types/scope_ref.dart';
import 'package:uuid/uuid.dart';

/// The files an object keeps, on the device (Impl).
///
/// Rows and bytes still live in two places, so the ordering the cloud settled on
/// carries over unchanged: nothing here is transactional across both, and a
/// local disk fills up the same way a bucket does.
class LocalDocumentsRepository implements DocumentsRepository {
  LocalDocumentsRepository(this._database, this._files);

  final AppDatabase _database;
  final DocumentFileStore _files;

  @override
  Future<List<Document>> documentsOf(ScopeRef scope) async {
    // Dates are stored as ISO-8601 in UTC, which sorts the same lexicographically
    // as it does chronologically — so ordering by the column is ordering by time,
    // and the newest-first test is what holds that true.
    final rows =
        await (_database.select(_database.documents)
              ..where((row) => row.unitId.equals(scope.unitId))
              ..orderBy([(row) => OrderingTerm.desc(row.createdAt)]))
            .get();

    return rows.map(_toDocument).toList();
  }

  @override
  Future<void> upload({
    required ScopeRef scope,
    required DocumentUpload file,
  }) async {
    // The path carries the row's id, so the id has to exist before either write.
    final id = const Uuid().v4();
    final path = documentStoragePath(
      scopeId: scope.unitId,
      documentId: id,
      fileName: file.fileName,
    );

    await _files.write(path, file.bytes);

    try {
      await _database
          .into(_database.documents)
          .insert(
            DocumentsCompanion.insert(
              id: id,
              unitId: scope.unitId,
              title: file.title,
              storagePath: path,
              mimeType: Value(file.mimeType),
              sizeBytes: Value(file.bytes.length),
              originalName: Value(file.fileName),
              createdAt: DateTime.now().toUtc(),
            ),
          );
    } catch (_) {
      // The row is what failed, so the file it was going to describe is now
      // unreachable by anything. Its own failure is swallowed deliberately: the
      // one worth reporting is the insert's.
      try {
        await _files.remove(path);
      } catch (_) {
        // Nothing links to it and nobody can see it; a sweeper is its own task.
      }
      rethrow;
    }
  }

  @override
  Future<void> rename({required String id, required String title}) =>
      (_database.update(_database.documents)..where((row) => row.id.equals(id)))
          .write(DocumentsCompanion(title: Value(title)));

  @override
  Future<void> delete(Document document) async {
    await (_database.delete(
      _database.documents,
    )..where((row) => row.id.equals(document.id))).go();

    await _files.remove(document.storagePath);
  }

  @override
  Future<Uint8List> download(Document document) =>
      _files.read(document.storagePath);

  Document _toDocument(DocumentRow row) => Document(
    id: row.id,
    title: row.title,
    storagePath: row.storagePath,
    createdAt: row.createdAt,
    mimeType: row.mimeType,
    sizeBytes: row.sizeBytes,
    originalName: row.originalName,
  );
}
