import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

/// Recolours a multi-colour SVG to [tint], leaving any colour in [keep] as-is.
///
/// For illustrations where a single `colorFilter` would flatten everything into
/// one colour — a badge whose fill should follow the theme but whose inner mark
/// must stay white. One-colour icons don't need this; use [DvIcon].
class SvgTint extends ColorMapper {
  const SvgTint(this.tint, {this.keep = const {}});

  final Color tint;
  final Set<Color> keep;

  @override
  Color substitute(
    String? id,
    String elementName,
    String attributeName,
    Color color,
  ) => keep.contains(color) ? color : tint;
}
