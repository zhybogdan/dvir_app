import 'package:dvir/features/Shared/presentation/dv_icon.dart';
import 'package:dvir/gen/assets.gen.dart';
import 'package:flutter/material.dart';

/// Shared icon-only control — app bar actions, a field's suffix, a close
/// button.
///
/// [tooltip] is required rather than optional, which is the reason this exists
/// as much as the styling is: an icon-only control carries no text, so without
/// a label it is unreadable to a screen reader and ambiguous to everyone whose
/// guess about the glyph is wrong. Making it a named optional would mean
/// remembering it every time.
class DvIconButton extends StatelessWidget {
  const DvIconButton({
    required this.icon,
    required this.tooltip,
    super.key,
    this.onPressed,
    this.color,
  }) : _asset = null;

  /// For the project's own SVGs, which are assets rather than [IconData].
  const DvIconButton.svg(
    this._asset, {
    required this.tooltip,
    super.key,
    this.onPressed,
    this.color,
  }) : icon = null;

  /// Null on the [DvIconButton.svg] variant, which draws an asset instead.
  final IconData? icon;
  final SvgGenImage? _asset;

  final String tooltip;

  /// Null disables the control, the same as any other button.
  final VoidCallback? onPressed;

  /// Overrides the themed foreground; for a semantic tint such as `error`.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final asset = _asset;

    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      color: color,
      icon: asset != null
          ? DvIcon(asset, color: color)
          : Icon(icon, color: color),
    );
  }
}
