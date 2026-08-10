import 'dart:io';
import 'dart:typed_data';

import 'package:dvir/core/error/failures.dart';
import 'package:dvir/features/Documents/data/document_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Where a document's bytes live (Base).
///
/// The cloud build has no implementation of this: there the repository talks to
/// the bucket directly, because Storage is one call away from the same client
/// the rows go through. On the device the bytes and the rows live in two
/// different places, and this is the second one.
abstract interface class DocumentFileStore {
  Future<void> write(String storagePath, Uint8List bytes);

  Future<Uint8List> read(String storagePath);

  Future<void> remove(String storagePath);
}

/// A folder inside the app's own directory (Impl).
///
/// Nothing here enforces a size or a type. In the cloud both are the bucket's
/// job and both exist to protect a gigabyte shared by everyone; a phone's
/// storage is the person's own, and refusing their scan to save their disk is
/// not a trade they asked for. The picker still filters by extension, which is
/// what keeps the list to things the app can open.
class LocalDocumentFileStore implements DocumentFileStore {
  LocalDocumentFileStore(this.root);

  /// Resolved by the flavour's start-up, which is async and can wait for it.
  static Future<LocalDocumentFileStore> open() async {
    final directory = await getApplicationDocumentsDirectory();

    // Named after the bucket it replaces, so a path read out of a row means the
    // same thing in either build.
    return LocalDocumentFileStore(
      Directory(p.join(directory.path, documentsBucket)),
    );
  }

  final Directory root;

  @override
  Future<void> write(String storagePath, Uint8List bytes) async {
    final file = _fileAt(storagePath);

    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
  }

  @override
  Future<Uint8List> read(String storagePath) async {
    final file = _fileAt(storagePath);

    // The same answer the cloud gives for a 404: a row that outlived its file.
    if (!file.existsSync()) {
      throw const StorageFailure(StorageFailureReason.missing);
    }

    try {
      return await file.readAsBytes();
    } on FileSystemException {
      throw const StorageFailure(StorageFailureReason.unknown);
    }
  }

  /// A file that is not there is not an error: the caller is getting rid of it,
  /// and it is already gone.
  @override
  Future<void> remove(String storagePath) async {
    final file = _fileAt(storagePath);

    if (file.existsSync()) await file.delete();
  }

  /// The stored path is written with forward slashes because that is what the
  /// bucket's convention uses; splitting it before joining is what keeps it a
  /// real path on Windows too.
  File _fileAt(String storagePath) =>
      File(p.joinAll([root.path, ...p.posix.split(storagePath)]));
}
