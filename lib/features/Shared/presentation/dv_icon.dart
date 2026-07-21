import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/gen/assets.gen.dart';
import 'package:flutter/material.dart';

/// Shared SVG icon, tinted to the theme.
///
/// The counterpart of [DvImage] for vector assets: `DvImage` wraps raster
/// `Image`, this wraps flutter_svg. Every icon goes through here so the colour
/// comes from the scheme (not the near-black baked into the source files) and
/// reads in both light and dark from one place.
///
/// Pass a generated `Assets.icons.x`; override [color] only for a semantic tint
/// (e.g. `error`), otherwise it follows the current foreground.
class DvIcon extends StatelessWidget {
  const DvIcon(this.asset, {super.key, this.size = AppSpacing.lg, this.color});

  final SvgGenImage asset;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return asset.svg(
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(
        color ?? context.colorScheme.onSurface,
        BlendMode.srcIn,
      ),
    );
  }
}
