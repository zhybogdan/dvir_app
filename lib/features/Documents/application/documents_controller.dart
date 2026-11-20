import 'dart:async';

import 'package:dvir/core/riverpod/guarded_actions.dart';
import 'package:dvir/features/Documents/data/document_files.dart';
import 'package:dvir/features/Documents/data/documents_repository.dart';
import 'package:dvir/features/Documents/data/documents_repository_impl.dart';
import 'package:dvir/features/Documents/domain/models/document.dart';
import 'package:dvir/features/Documents/domain/models/document_upload.dart';
import 'package:dvir/features/Home/application/my_scopes_controller.dart';
import 'package:dvir/features/Home/application/object_groups.dart';
import 'package:dvir/features/Shared/domain/types/scope_ref.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'documents_controller.g.dart';

/// The files one scope keeps, newest first.
///
/// Kept alive for the reason `unitChildren` is: the section is one of several
/// in a long scroll, and an auto-disposing provider re-reads the list every
/// time it comes back into view. Uploading, renaming and deleting all
/// invalidate it, as does the hub's pull-to-refresh.
@Riverpod(keepAlive: true)
Future<List<Document>> documents(Ref ref, ScopeRef scope) =>
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
  FutureOr<void> build(ScopeRef scope) {}

  Future<bool> add(DocumentUpload file) =>
      _run((repository) => repository.upload(scope: scope, file: file));

  Future<bool> rename({required String id, required String title}) =>
      _run((repository) => repository.rename(id: id, title: title));

  Future<bool> remove(Document document) =>
      _run((repository) => repository.delete(document));

  /// Downloads [document] and hands it to whatever the device opens that type
  /// with.
  ///
  /// Deliberately not one of the actions above: reading a file changes nothing
  /// about the list, so nothing is invalidated afterwards. It still runs
  /// through the guard, because the wait is long enough to show and the
  /// refusals — a file that is gone, a device with no viewer — are worth
  /// saying out loud.
  Future<bool> open(Document document) {
    final files = ref.read(documentFilesProvider);

    return guardedVoid(() => files.open(document));
  }

  /// Every action here changes the same list, so what to re-read afterwards is
  /// the same too.
  Future<bool> _run(Future<void> Function(DocumentsRepository) call) {
    final repository = ref.read(documentsRepositoryProvider);

    return guardedVoid(
      () => call(repository),
      onSuccess: () {
        ref.invalidate(documentsProvider(scope));
        // The home card counts what this changed, so the list it is drawn from
        // is stale the moment this succeeds. Invalidated rather than awaited:
        // nothing navigates after an upload, and making the caller wait on a
        // second round trip would only slow the screen it is already on.
        ref.invalidate(myScopesProvider);
      },
    );
  }
}

/// Every paper across every object, grouped by object — the second tab.
///
/// Synchronous on purpose: it reads values the per-object lists already hold
/// and composes them, so there is nothing of its own to wait for, and an
/// async build would only add a frame of loading over lists that are loaded.
@riverpod
AsyncValue<List<ObjectGroup<Document>>> allDocuments(Ref ref) => groupByObject(
  ref.watch(myScopesProvider),
  (scope) => ref.watch(documentsProvider(scope)),
);
