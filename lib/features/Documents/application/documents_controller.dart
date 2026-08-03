import 'dart:async';

import 'package:dvir/core/riverpod/guarded_actions.dart';
import 'package:dvir/features/Documents/data/documents_repository.dart';
import 'package:dvir/features/Documents/data/documents_repository_impl.dart';
import 'package:dvir/features/Documents/domain/models/document.dart';
import 'package:dvir/features/Documents/domain/models/document_upload.dart';
import 'package:dvir/features/Documents/domain/types/document_scope.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'documents_controller.g.dart';

/// The files one scope keeps, newest first.
@riverpod
Future<List<Document>> documents(Ref ref, DocumentScope scope) =>
    ref.watch(documentsRepositoryProvider).documentsOf(scope);

/// Adding, renaming, removing and opening the files of one scope.
///
/// Keyed by the scope so a refusal on one screen cannot light up another, and
/// so what to re-read afterwards is known without being passed in.
///
/// **A screen driving this must also listen to it** — nothing watches it for a
/// value, so without a listener it is disposed the moment it is read, and its
/// failures reach nobody.
@riverpod
class DocumentActions extends _$DocumentActions with GuardedActions {
  @override
  FutureOr<void> build(DocumentScope scope) {}

  Future<bool> add(DocumentUpload file) =>
      _run((repository) => repository.upload(scope: scope, file: file));

  Future<bool> rename({required String id, required String title}) =>
      _run((repository) => repository.rename(id: id, title: title));

  Future<bool> remove(Document document) =>
      _run((repository) => repository.delete(document));

  /// A link to open [document] with, or null when it could not be signed.
  ///
  /// Deliberately not one of the actions above: reading a file changes nothing
  /// about the list, so nothing is invalidated afterwards.
  Future<String?> readUrl(Document document) {
    final repository = ref.read(documentsRepositoryProvider);

    return guarded(() => repository.readUrl(document));
  }

  /// Every action here changes the same list, so what to re-read afterwards is
  /// the same too.
  Future<bool> _run(Future<void> Function(DocumentsRepository) call) {
    final repository = ref.read(documentsRepositoryProvider);

    return guardedVoid(
      () => call(repository),
      onSuccess: () => ref.invalidate(documentsProvider(scope)),
    );
  }
}
