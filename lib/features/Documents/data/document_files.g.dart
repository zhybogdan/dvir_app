// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_files.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(documentFiles)
final documentFilesProvider = DocumentFilesProvider._();

final class DocumentFilesProvider
    extends $FunctionalProvider<DocumentFiles, DocumentFiles, DocumentFiles>
    with $Provider<DocumentFiles> {
  DocumentFilesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentFilesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentFilesHash();

  @$internal
  @override
  $ProviderElement<DocumentFiles> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DocumentFiles create(Ref ref) {
    return documentFiles(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DocumentFiles value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DocumentFiles>(value),
    );
  }
}

String _$documentFilesHash() => r'71b4b74c137bd05fffd96f5c4740e2a3c6b558fe';
