import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/core/logging/tap_log.dart';
import 'package:flutter/material.dart';

/// Primary filled button with an inline loading state.
///
/// While [isLoading] the button is disabled and shows a spinner in place of the
/// label, so callers don't juggle a separate progress indicator during async
/// actions (sign in, submit, …).
class DvButton extends StatelessWidget {
  const DvButton({
    required this.label,
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : _variant = _DvButtonVariant.filled;

  /// The quieter half of a pair — the way back out, standing next to the
  /// action it declines. Two filled buttons side by side would ask the same
  /// weight of a yes and a no.
  const DvButton.tonal({
    required this.label,
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : _variant = _DvButtonVariant.tonal;

  /// For the answer that cannot be taken back.
  const DvButton.danger({
    required this.label,
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : _variant = _DvButtonVariant.danger;

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  final _DvButtonVariant _variant;

  @override
  Widget build(BuildContext context) {
    final icon = this.icon;
    final scheme = context.colorScheme;
    final onPressed = loggedTap(label, this.onPressed);

    // Null keeps the theme's own filled style; the other two are the same
    // button in different clothes, so only the colours are overridden.
    final style = switch (_variant) {
      _DvButtonVariant.filled => null,
      _DvButtonVariant.tonal => FilledButton.styleFrom(
        backgroundColor: scheme.surfaceContainerHighest,
        foregroundColor: scheme.onSurface,
      ),
      _DvButtonVariant.danger => FilledButton.styleFrom(
        backgroundColor: scheme.error,
        foregroundColor: scheme.onError,
      ),
    };

    if (isLoading) {
      return FilledButton(
        onPressed: null,
        style: style,
        child: SizedBox.square(
          dimension: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: switch (_variant) {
              _DvButtonVariant.filled => scheme.onPrimary,
              _DvButtonVariant.tonal => scheme.onSurface,
              _DvButtonVariant.danger => scheme.onError,
            },
          ),
        ),
      );
    }

    if (icon != null) {
      return FilledButton.icon(
        onPressed: onPressed,
        style: style,
        icon: Icon(icon),
        label: Text(label),
      );
    }

    return FilledButton(onPressed: onPressed, style: style, child: Text(label));
  }
}

enum _DvButtonVariant { filled, tonal, danger }
