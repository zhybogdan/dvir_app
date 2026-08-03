import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Shared/presentation/dv_text_button.dart';
import 'package:flutter/material.dart';

/// The one control that acts on a section, sitting in its heading.
typedef DvSectionAction = ({String label, VoidCallback onPressed});

/// A section heading, optionally with [action] at its right end.
///
/// Shared rather than an object's own: the hub was the first screen made of
/// sections, and documents are the second feature to need the same heading.
class DvSectionTitle extends StatelessWidget {
  const DvSectionTitle(this.text, {super.key, this.action});

  final String text;
  final DvSectionAction? action;

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
          DvTextButton(
            label: action.label,
            icon: Icons.add,
            onPressed: action.onPressed,
          ),
      ],
    );
  }
}
