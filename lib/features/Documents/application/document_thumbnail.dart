import 'dart:typed_data';

import 'package:dvir/features/Documents/data/documents_repository_impl.dart';
import 'package:dvir/features/Documents/domain/models/document.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'document_thumbnail.g.dart';

/// The bytes of a photo, to draw it in place of the icon it would otherwise
/// get; null for anything that is not a picture.
///
/// Ten photos under one grey mark cannot be told apart without opening each,
/// and that is the one thing a picture can say about itself. The whole file is
/// read, not a scaled copy: on the device that is a local read of a few hundred
/// kilobytes, and the widget decodes it at the size it is drawn.
///
/// Auto-disposed, so a list scrolled past does not keep every photo it showed.
@riverpod
Future<Uint8List?> documentThumbnail(Ref ref, Document document) async {
  final mimeType = document.mimeType ?? '';
  if (!mimeType.startsWith('image/')) return null;

  return ref.watch(documentsRepositoryProvider).download(document);
}
