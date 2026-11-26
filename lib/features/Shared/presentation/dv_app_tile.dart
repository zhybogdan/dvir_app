import 'package:dvir/app/icons.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/features/Shared/presentation/dv_image.dart';
import 'package:dvir/gen/assets.gen.dart';
import 'package:flutter/material.dart';

/// The logo on its rounded tile, with nothing under it.
///
/// Apart from [DvAppMark] because the splash needs the tile alone: the phone
/// has already drawn this exact square, centred, before Flutter starts, and
/// anything sharing a column with it would push it off that centre.
class DvAppTile extends StatelessWidget {
  const DvAppTile({super.key, this.size = 56});

  /// Side of the tile; the logo inside is inset from it by a fixed margin.
  final double size;

  @override
  Widget build(BuildContext context) {
    final logoSize = size - AppSpacing.lg;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.brand,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: DvImage(
        image: Assets.images.logoGlyph.provider(),
        width: logoSize,
        height: logoSize,
        fit: BoxFit.contain,
        fallback: Icon(
          AppIcons.appMark,
          color: AppColors.white,
          size: logoSize,
        ),
      ),
    );
  }
}
