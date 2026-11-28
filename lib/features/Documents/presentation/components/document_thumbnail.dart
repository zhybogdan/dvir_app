import 'package:dvir/features/Documents/application/document_thumbnail.dart';
import 'package:dvir/features/Documents/domain/models/document.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// A photo drawn as itself, filling the box it is given; [fallback] for
/// anything else.
///
/// The fallback also stands in while the file is read and when it cannot be
/// decoded — a HEIC on a phone that does not speak it — so the row never
/// shows an empty square, and a failure looks like the icon it always had.
class DocumentThumbnail extends ConsumerWidget {
  const DocumentThumbnail({
    required this.document,
    required this.fallback,
    super.key,
  });

  final Document document;
  final Widget fallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fallback = this.fallback;
    final bytes = ref.watch(documentThumbnailProvider(document)).value;

    if (bytes == null) return fallback;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Decoded at the size it is drawn: a 1600 px photo held whole in
        // memory for a 44 square is most of a megabyte per row.
        final pixelRatio = MediaQuery.devicePixelRatioOf(context);
        final width = constraints.maxWidth.isFinite
            ? (constraints.maxWidth * pixelRatio).round()
            : null;

        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          cacheWidth: width,
          gaplessPlayback: true,
          errorBuilder: (_, _, _) => fallback,
        );
      },
    );
  }
}
