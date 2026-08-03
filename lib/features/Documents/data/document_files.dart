import 'dart:io';

import 'package:dvir/core/error/failures.dart';
import 'package:dvir/core/logging/app_logger.dart';
import 'package:dvir/features/Documents/data/document_storage.dart';
import 'package:dvir/features/Documents/data/documents_repository.dart';
import 'package:dvir/features/Documents/data/documents_repository_impl.dart';
import 'package:dvir/features/Documents/domain/models/document.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'document_files.g.dart';

/// Opening a stored file on the device (Base).
///
/// Downloading and handing over to whatever opens PDFs, rather than launching a
/// signed URL in a browser: the browser would download it a second time, into a
/// folder the person then has to go looking in.
abstract interface class DocumentFiles {
  Future<void> open(Document document);
}

class DocumentFilesImpl implements DocumentFiles {
  DocumentFilesImpl(this._repository);

  final DocumentsRepository _repository;

  @override
  Future<void> open(Document document) async {
    final bytes = await _repository.download(document);

    // The cache directory, not documents: the copy is a viewer's, and the file
    // it was made from lives in the bucket. The name is the row's id plus its
    // type, so opening the same document twice reuses one file instead of
    // filling the cache with numbered copies.
    final directory = await getTemporaryDirectory();
    final extension = documentExtension(document.storagePath);
    final name = extension.isEmpty ? document.id : '${document.id}.$extension';

    final file = File('${directory.path}/$name');
    await file.writeAsBytes(bytes, flush: true);

    final result = await OpenFilex.open(file.path, type: document.mimeType);
    if (result.type == ResultType.done) return;

    appLogger.d('Could not open ${document.storagePath}: ${result.message}');
    throw const StorageFailure(StorageFailureReason.cannotOpen);
  }
}

@Riverpod(keepAlive: true)
DocumentFiles documentFiles(Ref ref) =>
    DocumentFilesImpl(ref.watch(documentsRepositoryProvider));
