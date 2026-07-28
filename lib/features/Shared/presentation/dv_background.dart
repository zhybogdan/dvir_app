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

/// Soft vertical wash for the screens inside the app, where [DvBackground]'s
/// watermark would sit under lists and read as noise.
///
/// Starts at the plain surface deliberately. The app bar on these screens is
/// opaque — a list has to scroll *under* something, not through it — and an
/// opaque bar over a tinted top edge is exactly the seam this replaces. Because
/// the first stop is the same colour the bar is filled with, the two meet
/// invisibly and the tint only appears further down, behind the content.
class DvAppGradient extends StatelessWidget {
  const DvAppGradient({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            scheme.surface,
            Color.alphaBlend(
              scheme.primary.withValues(alpha: 0.1),
              scheme.surface,
            ),
          ],
        ),
      ),
    );
  }
}
