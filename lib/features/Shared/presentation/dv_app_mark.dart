import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Shared/presentation/dv_image.dart';
import 'package:dvir/gen/assets.gen.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// The app's mark — the logo on a rounded primary tile — with the app name
/// under it.
///
/// Shared by every screen that greets the user before the app proper (auth,
/// splash), so the same brand carries across the whole cold start instead of
/// each screen composing its own.
class DvAppMark extends StatelessWidget {
  const DvAppMark({super.key, this.size = 56});

  /// Side of the tile; the logo inside is inset from it by a fixed margin.
  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final logoSize = size - AppSpacing.lg;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: DvImage(
            image: Assets.images.logo.provider(),
            width: logoSize,
            height: logoSize,
            fit: BoxFit.contain,
            fallback: Icon(
              Icons.holiday_village_outlined,
              color: colorScheme.onPrimary,
              size: logoSize,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          AppLocalizations.of(context).appTitle,
          style: context.textTheme.titleLarge,
        ),
      ],
    );
  }
}
