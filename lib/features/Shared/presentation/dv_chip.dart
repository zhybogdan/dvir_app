import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

/// A word you can tap — an offer, not a state.
///
/// A pill rather than a button because it is one of several and none of them
/// is the thing to do: the button on the sheet below is. Drawn rather than
/// taken from Material's `ActionChip`, whose fill is the tone at low alpha
/// this palette was rebuilt to stop using.
class DvChip extends StatelessWidget {
  const DvChip({required this.label, required this.onTap, super.key});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;

    return Material(
      color: Colors.transparent,
      shape: StadiumBorder(side: BorderSide(color: scheme.outlineVariant)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Text(
            label,
            style: context.textTheme.labelLarge?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
