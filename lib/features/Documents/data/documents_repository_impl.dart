import 'dart:typed_data';

import 'package:dvir/core/config/supabase_providers.dart';
import 'package:dvir/core/error/supabase_error_guard.dart';
import 'package:dvir/features/Documents/data/document_storage.dart';
import 'package:dvir/features/Documents/data/documents_repository.dart';
import 'package:dvir/features/Documents/domain/models/document.dart';
import 'package:dvir/features/Documents/domain/models/document_upload.dart';
import 'package:dvir/features/Shared/domain/types/scope_ref.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:uuid/uuid.dart';

part 'documents_repository_impl.g.dart';

/// Neither scope id is asked for: a list is read for one scope, so the answer
/// would repeat what the caller passed in. `category` is absent for as long as
/// nothing shows it.
const String _columns =
    'id,title,storage_path,mime_type,size_bytes,original_name,created_at';

class DocumentsRepositoryImpl implements DocumentsRepository {
  DocumentsRepositoryImpl(this._client);

  final sb.SupabaseClient _client;

  sb.StorageFileApi get _bucket => _client.storage.from(documentsBucket);

  @override
  Future<List<Document>> documentsOf(ScopeRef scope) => guardSupabase(() async {
    final rows = await _client
        .from('documents')
        .select(_columns)
        .eq(scope.column, scope.id)
        .order('created_at', ascending: false);

    return rows.map(Document.fromJson).toList();
  });

  @override
  Future<void> upload({
    required ScopeRef scope,
    required DocumentUpload file,
  }) => guardSupabase(() async {
    // The path carries the row's id, so the id has to exist before either
    // write. The column keeps its default for anything inserted without a file.
    final id = const Uuid().v4();
    final path = documentStoragePath(
      scopeId: scope.id,
      documentId: id,
      fileName: file.fileName,
    );

    await _bucket.uploadBinary(
      path,
      file.bytes,
      fileOptions: sb.FileOptions(contentType: file.mimeType),
    );

    try {
      await _client.from('documents').insert({
        'id': id,
        scope.column: scope.id,
        'title': file.title,
        'storage_path': path,
        'mime_type': file.mimeType,
        'size_bytes': file.bytes.length,
        'original_name': file.fileName,
        // Not read by anything yet; recorded because the answer to "who added
        // this" cannot be reconstructed afterwards.
        'uploaded_by': _client.auth.currentUser?.id,
      });
    } catch (_) {
      // The row is what failed, so the object it was going to describe is now
      // unreachable by anything. Its own failure is swallowed deliberately: the
      // one worth reporting is the insert's.
      try {
        await _bucket.remove([path]);
      } catch (_) {
        // Nothing links to it and nobody can see it; a sweeper is its own task.
      }
      rethrow;
    }
  });

  @override
  Future<void> rename({required String id, required String title}) =>
      guardSupabase(
        () => _client.from('documents').update({'title': title}).eq('id', id),
      );

  @override
  Future<void> delete(Document document) => guardSupabase(() async {
    await _client.from('documents').delete().eq('id', document.id);
    await _bucket.remove([document.storagePath]);
  });

  @override
  Future<Uint8List> download(Document document) =>
      guardSupabase(() => _bucket.download(document.storagePath));
}

@Riverpod(keepAlive: true)
DocumentsRepository documentsRepository(Ref ref) =>
    DocumentsRepositoryImpl(ref.watch(supabaseClientProvider));
