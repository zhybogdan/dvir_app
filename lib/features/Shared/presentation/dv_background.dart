import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/gen/assets.gen.dart';
import 'package:flutter/material.dart';

/// Full-bleed decorative watermark shared by the pre-app screens (auth,
/// onboarding). Tinted to the theme primary at low opacity so it adapts to
/// light/dark instead of the raw grey baked into the source asset.
class DvBackground extends StatelessWidget {
  const DvBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Assets.images.authBackground.svg(
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        colorFilter: ColorFilter.mode(
          context.colorScheme.primary.withValues(alpha: 0.04),
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
