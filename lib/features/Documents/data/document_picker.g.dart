// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_picker.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(documentPicker)
final documentPickerProvider = DocumentPickerProvider._();

final class DocumentPickerProvider
    extends $FunctionalProvider<DocumentPicker, DocumentPicker, DocumentPicker>
    with $Provider<DocumentPicker> {
  DocumentPickerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentPickerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentPickerHash();

  @$internal
  @override
  $ProviderElement<DocumentPicker> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DocumentPicker create(Ref ref) {
    return documentPicker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DocumentPicker value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DocumentPicker>(value),
    );
  }
}

String _$documentPickerHash() => r'391b95175677e04189b91ccd7832b6d98c8ae971';
