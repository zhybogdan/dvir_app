import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

/// The one control that acts on a section, sitting in its heading.
typedef UnitSectionAction = ({String label, VoidCallback onPressed});

/// A section heading, optionally with [action] at its right end.
class UnitSectionTitle extends StatelessWidget {
  const UnitSectionTitle(this.text, {super.key, this.action});

  final String text;
  final UnitSectionAction? action;

  @override
  Widget build(BuildContext context) {
    final action = this.action;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text.toUpperCase(),
          style: context.textTheme.labelSmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
            letterSpacing: 1,
          ),
        ),
        if (action != null)
          TextButton.icon(
            onPressed: action.onPressed,
            icon: const Icon(Icons.add, size: AppSpacing.md),
            label: Text(action.label),
          ),
      ],
    );
  }
}
