// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documents_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The files one scope keeps, newest first.

@ProviderFor(documents)
final documentsProvider = DocumentsFamily._();

/// The files one scope keeps, newest first.

final class DocumentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Document>>,
          List<Document>,
          FutureOr<List<Document>>
        >
    with $FutureModifier<List<Document>>, $FutureProvider<List<Document>> {
  /// The files one scope keeps, newest first.
  DocumentsProvider._({
    required DocumentsFamily super.from,
    required DocumentScope super.argument,
  }) : super(
         retry: null,
         name: r'documentsProvider',
         isAutoDispose: true,
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

String _$documentsHash() => r'2c21a44d0bb2f4594ff687aecfed3115ef9145c5';

/// The files one scope keeps, newest first.

final class DocumentsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Document>>, DocumentScope> {
  DocumentsFamily._()
    : super(
        retry: null,
        name: r'documentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The files one scope keeps, newest first.

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

String _$documentActionsHash() => r'50daadf7326cd549ef107a79ed04c2e1dc45b5c2';

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
