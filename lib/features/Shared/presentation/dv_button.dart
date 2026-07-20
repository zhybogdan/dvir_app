import 'package:dvir/core/extensions/build_context_x.dart';
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
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final icon = this.icon;

    if (isLoading) {
      return FilledButton(
        onPressed: null,
        child: SizedBox.square(
          dimension: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: context.colorScheme.onPrimary,
          ),
        ),
      );
    }

    if (icon != null) {
      return FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      );
    }

    return FilledButton(onPressed: onPressed, child: Text(label));
  }
}
