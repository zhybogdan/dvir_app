import 'dart:io';

import 'package:dvir/core/error/failures.dart';
import 'package:dvir/core/logging/app_logger.dart';
import 'package:dvir/core/utils/share.dart';
import 'package:dvir/features/Documents/data/document_storage.dart';
import 'package:dvir/features/Documents/data/documents_repository.dart';
import 'package:dvir/features/Documents/data/documents_repository_impl.dart';
import 'package:dvir/features/Documents/domain/models/document.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'document_files.g.dart';

/// Taking a stored file out of the app — to look at it, or to send it (Base).
///
/// Downloading and handing over to whatever opens PDFs, rather than launching a
/// signed URL in a browser: the browser would download it a second time, into a
/// folder the person then has to go looking in.
abstract interface class DocumentFiles {
  Future<void> open(Document document);

  Future<void> share(Document document);
}

class DocumentFilesImpl implements DocumentFiles {
  DocumentFilesImpl(this._repository);

  final DocumentsRepository _repository;

  /// Characters a file name cannot hold on one system or another.
  static final RegExp _unsafeInName = RegExp(r'[\\/:*?"<>|\x00-\x1F]');

  @override
  Future<void> open(Document document) async {
    // Named by the row's id, so opening the same document twice reuses one
    // file instead of filling the cache with numbered copies.
    final file = await _copy(document, directory: '', name: document.id);

    final result = await OpenFilex.open(file.path, type: document.mimeType);
    if (result.type == ResultType.done) return;

    appLogger.d('Could not open ${document.storagePath}: ${result.message}');
    throw const StorageFailure(StorageFailureReason.cannotOpen);
  }

  /// Named by the title, unlike [open]: the name is what the other side sees
  /// in the chat, and a uuid there tells the notary nothing. A folder per
  /// document keeps two papers both called «Договір» from overwriting each
  /// other.
  @override
  Future<void> share(Document document) async {
    final title = document.title.replaceAll(_unsafeInName, '_').trim();
    final file = await _copy(
      document,
      directory: 'share/${document.id}',
      name: title.isEmpty ? document.id : title,
    );

    await shareFile(file.path);
  }

  /// The cache directory, not documents: the copy is a viewer's, and the file
  /// it was made from lives in the store.
  Future<File> _copy(
    Document document, {
    required String directory,
    required String name,
  }) async {
    final bytes = await _repository.download(document);

    final cache = await getTemporaryDirectory();
    final folder = Directory('${cache.path}/$directory');
    await folder.create(recursive: true);

    final extension = documentExtension(document.storagePath);
    final fileName = extension.isEmpty ? name : '$name.$extension';

    final file = File('${folder.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);

    return file;
  }
}

@Riverpod(keepAlive: true)
DocumentFiles documentFiles(Ref ref) =>
    DocumentFilesImpl(ref.watch(documentsRepositoryProvider));
