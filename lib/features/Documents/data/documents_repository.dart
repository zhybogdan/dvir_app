import 'package:dvir/features/Documents/domain/models/document.dart';
import 'package:dvir/features/Documents/domain/models/document_upload.dart';
import 'package:dvir/features/Documents/domain/types/document_scope.dart';

/// Contract for the files kept against a scope (Base).
///
/// A feature of its own rather than a corner of `UnitsRepository`: documents
/// serve a community exactly as they serve a house, and the day the ОСББ half
/// gets screens it should find this already written for it.
abstract interface class DocumentsRepository {
  /// One scope's files, newest first.
  Future<List<Document>> documentsOf(DocumentScope scope);

  /// Puts [file] in Storage and records it.
  ///
  /// Two writes with nothing transactional between them, so their order is a
  /// decision: the object goes up first, the row second. Either order can leave
  /// an orphan when the second call fails, and the two orphans are not equal —
  /// a row without a file is a broken line a person has to notice and clear, a
  /// file without a row is invisible and costs a few hundred kilobytes.
  Future<void> upload({
    required DocumentScope scope,
    required DocumentUpload file,
  });

  /// Renames the record. The file keeps its key: the key is a uuid, and the
  /// name a person reads was never part of it.
  Future<void> rename({required String id, required String title});

  /// Drops the record, then the object behind it. Storage has no foreign key to
  /// cascade, so both halves are this repository's job — a delete that removes
  /// only the row is how a bucket fills with files nobody can see.
  Future<void> delete(Document document);

  /// A signed, short-lived link to read [document] with.
  Future<String> readUrl(Document document);
}
