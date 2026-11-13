import 'package:dvir/app/icons.dart';
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
class DvSectionTitle extends StatelessWidget {
  const DvSectionTitle(this.text, {super.key, this.count, this.action});

  final String text;

  /// How many things the section holds, shown in a pill beside the label.
  ///
  /// The cheapest piece of information a column of sections can give: how much
  /// is behind a heading, before anyone scrolls into it.
  ///
  /// Null renders no pill, which is why the type is nullable rather than
  /// defaulted to zero — while the list is still loading there is no number,
  /// and a `0` printed in its place is a claim. An empty section says what it
  /// is for in the words of its empty state instead, so zero draws no pill
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
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: _Label(text: text, count: count),
          ),
          if (action != null)
            DvTextButton(
              label: action.label,
              icon: AppIcons.add,
              onPressed: action.onPressed,
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

    return Row(
      spacing: AppSpacing.sm,
      children: [
        // Capitals are what keep a heading from competing with a card title at
        // the same size, and the one thing that may have to give at a large
        // text scale is the length of the words, never the number beside them.
        Flexible(
          child: Text(
            text.toUpperCase(),
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
              letterSpacing: 1,
            ),
          ),
        ),
        if (count != null && count > 0) _CountPill(count: count),
      ],
    );
  }
}

class _CountPill extends StatelessWidget {
  const _CountPill({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        '$count',
        style: context.textTheme.labelSmall?.copyWith(
          color: scheme.onSurfaceVariant,
          // No letter-spacing, which the heading's capitals need and digits do
          // not, and tabular figures so a column of sections does not jitter
          // as one of them goes from 9 to 10.
          letterSpacing: 0,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}
