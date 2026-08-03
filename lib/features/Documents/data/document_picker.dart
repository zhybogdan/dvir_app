import 'dart:typed_data';

import 'package:dvir/core/logging/app_logger.dart';
import 'package:dvir/features/Documents/data/document_storage.dart';
import 'package:dvir/features/Documents/domain/models/document_upload.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'document_picker.g.dart';

/// Where a file comes from.
///
/// Three entry points to one upload: the papers a person already has are files,
/// what they photographed before is in the gallery, and what they are looking at
/// right now — a meter, a crack in a wall — is neither until the camera opens.
enum DocumentSource { file, gallery, camera }

/// The extensions the picker offers, matching the bucket's `allowed_mime_types`
/// (`0010`).
///
/// Filtering here is a courtesy — the bucket is what actually refuses — but it
/// is the difference between choosing a file and being told no afterwards.
const List<String> documentExtensions = [
  'pdf',
  'jpg',
  'jpeg',
  'png',
  'webp',
  'heic',
];

/// Choosing a file from the device, ready to upload (Base).
///
/// A data source rather than something a widget does: it talks to three
/// platform plugins and re-encodes what they hand back, none of which belongs
/// in a build method.
abstract interface class DocumentPicker {
  /// Null when the person backed out of the picker.
  Future<DocumentUpload?> pick(DocumentSource source);
}

class DocumentPickerImpl implements DocumentPicker {
  const DocumentPickerImpl();

  @override
  Future<DocumentUpload?> pick(DocumentSource source) => switch (source) {
    DocumentSource.file => _fromFiles(),
    DocumentSource.gallery => _fromCamera(ImageSource.gallery),
    DocumentSource.camera => _fromCamera(ImageSource.camera),
  };

  Future<DocumentUpload?> _fromFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: documentExtensions,
      // Bytes rather than a path: the file may live in a cloud provider the
      // device only streams, and the upload needs the contents either way.
      withData: true,
    );

    final file = result?.files.singleOrNull;
    final bytes = file?.bytes;
    if (file == null || bytes == null) return null;

    return _upload(fileName: file.name, bytes: bytes);
  }

  Future<DocumentUpload?> _fromCamera(ImageSource source) async {
    final shot = await ImagePicker().pickImage(source: source);
    if (shot == null) return null;

    return _upload(fileName: shot.name, bytes: await shot.readAsBytes());
  }

  /// Names the file, works out its type, and shrinks it if it is an image.
  Future<DocumentUpload> _upload({
    required String fileName,
    required Uint8List bytes,
  }) async {
    final mimeType =
        lookupMimeType(fileName, headerBytes: _header(bytes)) ??
        'application/octet-stream';

    final title = suggestedDocumentTitle(fileName);

    if (!mimeType.startsWith('image/')) {
      return DocumentUpload(
        title: title,
        fileName: fileName,
        mimeType: mimeType,
        bytes: bytes,
      );
    }

    return _compressed(title: title, fileName: fileName, bytes: bytes);
  }

  /// An image at a size worth keeping, as JPEG.
  ///
  /// A photo straight off a phone is 3–5 MB and the same picture at 1600 px is
  /// 300–500 KB — still legible as a scan, and the difference between a few
  /// hundred photos in the free tier's gigabyte and a few thousand. The bucket
  /// would take the original; the quota is what would not.
  ///
  /// Failure here is not fatal: the original is uploaded instead, because a
  /// photo that costs too much is better than a photo that was refused.
  Future<DocumentUpload> _compressed({
    required String title,
    required String fileName,
    required Uint8List bytes,
  }) async {
    Uint8List? small;

    try {
      small = await FlutterImageCompress.compressWithList(
        bytes,
        minWidth: 1600,
        minHeight: 1600,
        quality: 80,
      );
    } catch (error) {
      appLogger.d('Could not compress $fileName: $error');
    }

    // Some formats come back bigger than they went in — an already-small JPEG
    // re-encoded, a screenshot that was a PNG of flat colour.
    if (small == null || small.length >= bytes.length) {
      return DocumentUpload(
        title: title,
        fileName: fileName,
        mimeType: lookupMimeType(fileName) ?? 'image/jpeg',
        bytes: bytes,
      );
    }

    // The name has to follow the re-encoding: a `.png` holding JPEG bytes would
    // be stored with the wrong content type and open as a broken image.
    return DocumentUpload(
      title: title,
      fileName: '$title.jpg',
      mimeType: 'image/jpeg',
      bytes: small,
    );
  }

  /// The first bytes, for `lookupMimeType` to read when the name says nothing —
  /// a camera shot on iOS arrives as `image_picker_XXXX` often enough.
  Uint8List _header(Uint8List bytes) =>
      bytes.sublist(0, bytes.length < 64 ? bytes.length : 64);
}

@Riverpod(keepAlive: true)
DocumentPicker documentPicker(Ref ref) => const DocumentPickerImpl();
