import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/core/logging/tap_log.dart';
import 'package:flutter/material.dart';

/// The quiet button: a way onward that is not the point of the screen.
///
/// The counterpart of [DvButton], which is the one thing a screen is for. This
/// is everything beside it — "already have an account", "copy the code", "sign
/// out". They were a dozen bare `TextButton`s that had drifted apart in icon
/// size and in how a destructive one was coloured, and none of them reached
/// the tap log.
class DvTextButton extends StatelessWidget {
  const DvTextButton({
    required this.label,
    super.key,
    this.onPressed,
    this.icon,
    this.isDestructive = false,
  });

  final String label;

  /// Null disables the control, the same as any other button.
  final VoidCallback? onPressed;

  final IconData? icon;

  /// Paints it in `error` — for the quiet way out that cannot be undone,
  /// such as withdrawing a request.
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final icon = this.icon;
    final onPressed = loggedTap(label, this.onPressed);

    // Null keeps the theme's own foreground; only the destructive case departs
    // from it.
    final style = isDestructive
        ? TextButton.styleFrom(foregroundColor: context.colorScheme.error)
        : null;

    if (icon != null) {
      return TextButton.icon(
        onPressed: onPressed,
        style: style,
        icon: Icon(icon, size: _iconSize),
        label: Text(label),
      );
    }

    return TextButton(onPressed: onPressed, style: style, child: Text(label));
  }

  /// One size for every icon in a quiet button, rather than Material's 18 in
  /// some places and an even 16 where somebody had already said so.
  static const double _iconSize = AppSpacing.md;
}
