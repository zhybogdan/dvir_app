// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_thumbnail.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The bytes of a photo, to draw it in place of the icon it would otherwise
/// get; null for anything that is not a picture.
///
/// Ten photos under one grey mark cannot be told apart without opening each,
/// and that is the one thing a picture can say about itself. The whole file is
/// read, not a scaled copy: on the device that is a local read of a few hundred
/// kilobytes, and the widget decodes it at the size it is drawn.
///
/// Auto-disposed, so a list scrolled past does not keep every photo it showed.

@ProviderFor(documentThumbnail)
final documentThumbnailProvider = DocumentThumbnailFamily._();

/// The bytes of a photo, to draw it in place of the icon it would otherwise
/// get; null for anything that is not a picture.
///
/// Ten photos under one grey mark cannot be told apart without opening each,
/// and that is the one thing a picture can say about itself. The whole file is
/// read, not a scaled copy: on the device that is a local read of a few hundred
/// kilobytes, and the widget decodes it at the size it is drawn.
///
/// Auto-disposed, so a list scrolled past does not keep every photo it showed.

final class DocumentThumbnailProvider
    extends
        $FunctionalProvider<
          AsyncValue<Uint8List?>,
          Uint8List?,
          FutureOr<Uint8List?>
        >
    with $FutureModifier<Uint8List?>, $FutureProvider<Uint8List?> {
  /// The bytes of a photo, to draw it in place of the icon it would otherwise
  /// get; null for anything that is not a picture.
  ///
  /// Ten photos under one grey mark cannot be told apart without opening each,
  /// and that is the one thing a picture can say about itself. The whole file is
  /// read, not a scaled copy: on the device that is a local read of a few hundred
  /// kilobytes, and the widget decodes it at the size it is drawn.
  ///
  /// Auto-disposed, so a list scrolled past does not keep every photo it showed.
  DocumentThumbnailProvider._({
    required DocumentThumbnailFamily super.from,
    required Document super.argument,
  }) : super(
         retry: null,
         name: r'documentThumbnailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$documentThumbnailHash();

  @override
  String toString() {
    return r'documentThumbnailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Uint8List?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Uint8List?> create(Ref ref) {
    final argument = this.argument as Document;
    return documentThumbnail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DocumentThumbnailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$documentThumbnailHash() => r'f40e38e877f68969f434c4d0bfcc6d365c2276d0';

/// The bytes of a photo, to draw it in place of the icon it would otherwise
/// get; null for anything that is not a picture.
///
/// Ten photos under one grey mark cannot be told apart without opening each,
/// and that is the one thing a picture can say about itself. The whole file is
/// read, not a scaled copy: on the device that is a local read of a few hundred
/// kilobytes, and the widget decodes it at the size it is drawn.
///
/// Auto-disposed, so a list scrolled past does not keep every photo it showed.

final class DocumentThumbnailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Uint8List?>, Document> {
  DocumentThumbnailFamily._()
    : super(
        retry: null,
        name: r'documentThumbnailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The bytes of a photo, to draw it in place of the icon it would otherwise
  /// get; null for anything that is not a picture.
  ///
  /// Ten photos under one grey mark cannot be told apart without opening each,
  /// and that is the one thing a picture can say about itself. The whole file is
  /// read, not a scaled copy: on the device that is a local read of a few hundred
  /// kilobytes, and the widget decodes it at the size it is drawn.
  ///
  /// Auto-disposed, so a list scrolled past does not keep every photo it showed.

  DocumentThumbnailProvider call(Document document) =>
      DocumentThumbnailProvider._(argument: document, from: this);

  @override
  String toString() => r'documentThumbnailProvider';
}
