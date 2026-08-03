// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documents_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The files one scope keeps, newest first.
///
/// Kept alive for the reason `unitChildren` is: the section is one of several
/// in a long scroll, and an auto-disposing provider re-reads the list every
/// time it comes back into view. Uploading, renaming and deleting all
/// invalidate it, as does the hub's pull-to-refresh.

@ProviderFor(documents)
final documentsProvider = DocumentsFamily._();

/// The files one scope keeps, newest first.
///
/// Kept alive for the reason `unitChildren` is: the section is one of several
/// in a long scroll, and an auto-disposing provider re-reads the list every
/// time it comes back into view. Uploading, renaming and deleting all
/// invalidate it, as does the hub's pull-to-refresh.

final class DocumentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Document>>,
          List<Document>,
          FutureOr<List<Document>>
        >
    with $FutureModifier<List<Document>>, $FutureProvider<List<Document>> {
  /// The files one scope keeps, newest first.
  ///
  /// Kept alive for the reason `unitChildren` is: the section is one of several
  /// in a long scroll, and an auto-disposing provider re-reads the list every
  /// time it comes back into view. Uploading, renaming and deleting all
  /// invalidate it, as does the hub's pull-to-refresh.
  DocumentsProvider._({
    required DocumentsFamily super.from,
    required DocumentScope super.argument,
  }) : super(
         retry: null,
         name: r'documentsProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$documentsHash();

  @override
  String toString() {
    return r'documentsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Document>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Document>> create(Ref ref) {
    final argument = this.argument as DocumentScope;
    return documents(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DocumentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$documentsHash() => r'f6a49a28e5858cc02c426a4e1d8afc9f62aebc55';

/// The files one scope keeps, newest first.
///
/// Kept alive for the reason `unitChildren` is: the section is one of several
/// in a long scroll, and an auto-disposing provider re-reads the list every
/// time it comes back into view. Uploading, renaming and deleting all
/// invalidate it, as does the hub's pull-to-refresh.

final class DocumentsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Document>>, DocumentScope> {
  DocumentsFamily._()
    : super(
        retry: null,
        name: r'documentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// The files one scope keeps, newest first.
  ///
  /// Kept alive for the reason `unitChildren` is: the section is one of several
  /// in a long scroll, and an auto-disposing provider re-reads the list every
  /// time it comes back into view. Uploading, renaming and deleting all
  /// invalidate it, as does the hub's pull-to-refresh.

  DocumentsProvider call(DocumentScope scope) =>
      DocumentsProvider._(argument: scope, from: this);

  @override
  String toString() => r'documentsProvider';
}

/// Adding, renaming, removing and opening the files of one scope.
///
/// Keyed by the scope so a refusal on one screen cannot light up another, and
/// so what to re-read afterwards is known without being passed in.
///
/// **A screen driving this must also listen to it** — nothing watches it for a
/// value, so without a listener it is disposed the moment it is read, and its
/// failures reach nobody.

@ProviderFor(DocumentActions)
final documentActionsProvider = DocumentActionsFamily._();

/// Adding, renaming, removing and opening the files of one scope.
///
/// Keyed by the scope so a refusal on one screen cannot light up another, and
/// so what to re-read afterwards is known without being passed in.
///
/// **A screen driving this must also listen to it** — nothing watches it for a
/// value, so without a listener it is disposed the moment it is read, and its
/// failures reach nobody.
final class DocumentActionsProvider
    extends $AsyncNotifierProvider<DocumentActions, void> {
  /// Adding, renaming, removing and opening the files of one scope.
  ///
  /// Keyed by the scope so a refusal on one screen cannot light up another, and
  /// so what to re-read afterwards is known without being passed in.
  ///
  /// **A screen driving this must also listen to it** — nothing watches it for a
  /// value, so without a listener it is disposed the moment it is read, and its
  /// failures reach nobody.
  DocumentActionsProvider._({
    required DocumentActionsFamily super.from,
    required DocumentScope super.argument,
  }) : super(
         retry: null,
         name: r'documentActionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$documentActionsHash();

  @override
  String toString() {
    return r'documentActionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DocumentActions create() => DocumentActions();

  @override
  bool operator ==(Object other) {
    return other is DocumentActionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$documentActionsHash() => r'3b8d807508418f267cecc83f7c001d35c2c6c35a';

/// Adding, renaming, removing and opening the files of one scope.
///
/// Keyed by the scope so a refusal on one screen cannot light up another, and
/// so what to re-read afterwards is known without being passed in.
///
/// **A screen driving this must also listen to it** — nothing watches it for a
/// value, so without a listener it is disposed the moment it is read, and its
/// failures reach nobody.

final class DocumentActionsFamily extends $Family
    with
        $ClassFamilyOverride<
          DocumentActions,
          AsyncValue<void>,
          void,
          FutureOr<void>,
          DocumentScope
        > {
  DocumentActionsFamily._()
    : super(
        retry: null,
        name: r'documentActionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Adding, renaming, removing and opening the files of one scope.
  ///
  /// Keyed by the scope so a refusal on one screen cannot light up another, and
  /// so what to re-read afterwards is known without being passed in.
  ///
  /// **A screen driving this must also listen to it** — nothing watches it for a
  /// value, so without a listener it is disposed the moment it is read, and its
  /// failures reach nobody.

  DocumentActionsProvider call(DocumentScope scope) =>
      DocumentActionsProvider._(argument: scope, from: this);

  @override
  String toString() => r'documentActionsProvider';
}

/// Adding, renaming, removing and opening the files of one scope.
///
/// Keyed by the scope so a refusal on one screen cannot light up another, and
/// so what to re-read afterwards is known without being passed in.
///
/// **A screen driving this must also listen to it** — nothing watches it for a
/// value, so without a listener it is disposed the moment it is read, and its
/// failures reach nobody.

abstract class _$DocumentActions extends $AsyncNotifier<void> {
  late final _$args = ref.$arg as DocumentScope;
  DocumentScope get scope => _$args;

  FutureOr<void> build(DocumentScope scope);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
