import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

/// Sweeps a highlight band across its child, turning a group of
/// [DvSkeletonBox]es into a loading placeholder.
///
/// Wraps a whole skeleton layout rather than each box: the sweep is one gradient
/// painted over the subtree, so the band travels across the screen as a single
/// wave instead of every box pulsing on its own.
///
/// The child supplies shape only — `BlendMode.srcATop` repaints whatever it
/// draws with the gradient while keeping its alpha, so rounded corners survive.
class DvShimmer extends StatefulWidget {
  const DvShimmer({required this.child, super.key});

  final Widget child;

  @override
  State<DvShimmer> createState() => _DvShimmerState();
}

class _DvShimmerState extends State<DvShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final base = scheme.skeletonBase;
    final highlight = scheme.skeletonHighlight;

    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) => ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) {
          final shift = -2 + 4 * _controller.value;

          return LinearGradient(
            colors: [base, highlight, base],
            begin: Alignment(shift - 1, 0),
            end: Alignment(shift + 1, 0),
          ).createShader(bounds);
        },
        child: child,
      ),
    );
  }
}

/// One placeholder block, standing in for a line of text, an avatar or a
/// thumbnail while data loads.
///
/// Paints a flat fill; put it under a [DvShimmer] to pick up the sweep. Leave
/// [width] null to take the full width the parent offers.
class DvSkeletonBox extends StatelessWidget {
  const DvSkeletonBox({
    super.key,
    this.width,
    this.height = AppSpacing.md,
    this.radius = AppRadius.sm,
  });

  /// Square block with a fully rounded outline, for avatars and icon slots.
  const DvSkeletonBox.circle({required double size, super.key})
    : width = size,
      height = size,
      radius = size / 2;

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.colorScheme.skeletonBase,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// Skeleton fills, derived from the scheme so both themes stay in step.
///
/// The highlight is always *lighter* than the base — that is what reads as a
/// sweep of light — so it blends white in either way; a dark surface needs far
/// less of it before the band starts to glare.
extension _SkeletonColors on ColorScheme {
  Color get skeletonBase => surfaceContainerHigh;

  Color get skeletonHighlight => Color.alphaBlend(
    AppColors.white.withValues(
      alpha: brightness == Brightness.dark ? 0.08 : 0.56,
    ),
    skeletonBase,
  );
}
