import 'package:dvir/app/icons.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

/// Shared image with consistent loading and error states.
///
/// Wraps [Image] so every asset / remote image across the app shows the same
/// skeleton while loading and the same fallback when it fails, instead of each
/// call site re-implementing `loadingBuilder` / `errorBuilder`.
///
/// For a flutter_gen asset pass `Assets.images.x.provider()`; for a Supabase
/// Storage link use the [DvImage.network] constructor.
class DvImage extends StatelessWidget {
  const DvImage({
    required this.image,
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.fallback,
  });

  /// Remote image by URL (e.g. a Supabase Storage public / signed link).
  DvImage.network(
    String url, {
    Key? key,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
    Widget? fallback,
  }) : this(
         image: NetworkImage(url),
         key: key,
         width: width,
         height: height,
         fit: fit,
         borderRadius: borderRadius,
         fallback: fallback,
       );

  final ImageProvider image;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  /// Shown when the image fails to load. Defaults to a neutral broken-image box.
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius;
    final fallback = this.fallback;

    Widget result = Image(
      image: image,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : _DvImageBox(width: width, height: height),
      errorBuilder: (context, error, stackTrace) =>
          fallback ??
          _DvImageBox(
            width: width,
            height: height,
            child: Icon(
              AppIcons.brokenImage,
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
    );

    if (borderRadius != null) {
      result = ClipRRect(borderRadius: borderRadius, child: result);
    }
    return result;
  }
}

/// Neutral box used for both the loading skeleton and the error state.
class _DvImageBox extends StatelessWidget {
  const _DvImageBox({this.width, this.height, this.child});

  final double? width;
  final double? height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      color: context.colorScheme.surfaceContainerHighest,
      child: child,
    );
  }
}
