import 'dart:typed_data';

/// A file on its way into Storage.
///
/// A plain class rather than a Freezed model: it carries bytes, and a generated
/// `==` over a `Uint8List` compares identity, so two reads of the same file
/// would answer "not equal". Nothing compares uploads — they live for the
/// length of one call.
class DocumentUpload {
  const DocumentUpload({
    required this.title,
    required this.fileName,
    required this.mimeType,
    required this.bytes,
  });

  /// What the person calls it; [fileName] is what their device called it.
  final String title;
  final String fileName;

  /// Sent to Storage as the object's content type, so a download opens in the
  /// right app instead of arriving as a blob.
  final String mimeType;

  final Uint8List bytes;
}
