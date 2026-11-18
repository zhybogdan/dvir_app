import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Shared/presentation/dv_text_button.dart';
import 'package:flutter/material.dart';

/// The one control that acts on a section, sitting in its heading.
typedef DvSectionAction = ({String label, VoidCallback onPressed});

/// A section heading: what the section is, how much is in it, and the one
/// control that acts on it.
///
/// Shared rather than an object's own: the hub was the first screen made of
/// sections, and documents are the second feature to need the same heading.
///
/// It is the page's own heading, not a label stuck above a card: the sections
/// below it stopped being five identical lists, and a row of capitals over
/// each of them was the last thing still saying they were.
class DvSectionTitle extends StatelessWidget {
  const DvSectionTitle(this.text, {super.key, this.count, this.action});

  final String text;

  /// How many things the section holds, printed beside the label.
  ///
  /// The cheapest piece of information a column of sections can give: how much
  /// is behind a heading, before anyone scrolls into it.
  ///
  /// Null renders no number, which is why the type is nullable rather than
  /// defaulted to zero — while the list is still loading there is no number,
  /// and a `0` printed in its place is a claim. An empty section says what it
  /// is for in the words of its empty state instead, so zero prints nothing
  /// either.
  final int? count;

  final DvSectionAction? action;

  @override
  Widget build(BuildContext context) {
    final action = this.action;

    return Padding(
      // The gap down to the first card belongs to the heading: a heading never
      // stands on its own, and five call sites spacing it themselves are five
      // chances to space it differently.
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: _Label(text: text, count: count),
          ),
          if (action != null)
            DvTextButton(
              label: action.label,
              onPressed: action.onPressed,
              padding: EdgeInsets.zero,
            ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({required this.text, required this.count});

  final String text;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final count = this.count;
    final style = context.textTheme.titleMedium;

    return Row(
      spacing: AppSpacing.sm,
      children: [
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: style?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        if (count != null && count > 0)
          Text(
            '$count',
            style: style?.copyWith(color: context.colorScheme.onSurfaceVariant),
          ),
      ],
    );
  }
}
