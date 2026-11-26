import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/core/logging/tap_log.dart';
import 'package:material_ui/material_ui.dart';

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
    this.isLoading = false,
    this.padding,
  });

  final String label;

  /// Null disables the control, the same as any other button.
  final VoidCallback? onPressed;

  final IconData? icon;

  /// Paints it in `error` — for the quiet way out that cannot be undone,
  /// such as withdrawing a request.
  final bool isDestructive;

  /// Swaps the icon for a spinner and disables the control — for the quiet
  /// action that still takes a while, such as restoring from a copy.
  final bool isLoading;

  /// Overrides Material's own 12dp on each side.
  ///
  /// `EdgeInsets.zero` is what a button standing at the edge of the page needs:
  /// in a section heading the label has to end on the same line as the content
  /// under it, and Material's padding leaves it hanging short of the gutter.
  /// The height of the tap target is untouched.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final icon = this.icon;
    final onPressed = isLoading ? null : loggedTap(label, this.onPressed);

    // Null keeps the theme's own foreground and padding; only a caller that
    // asked, and the destructive case, depart from it.
    final padding = this.padding;
    final style = isDestructive || padding != null
        ? TextButton.styleFrom(
            foregroundColor: isDestructive ? context.colorScheme.error : null,
            padding: padding,
          )
        : null;

    if (isLoading) {
      return TextButton.icon(
        onPressed: null,
        style: style,
        icon: const SizedBox.square(
          dimension: _iconSize,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        label: Text(label),
      );
    }

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
