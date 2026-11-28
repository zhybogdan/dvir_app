import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:material_ui/material_ui.dart';

/// A word you can tap — an offer, not a state.
///
/// A pill rather than a button because it is one of several and none of them
/// is the thing to do: the button on the sheet below is. Drawn rather than
/// taken from Material's `ActionChip`, whose fill is the tone at low alpha
/// this palette was rebuilt to stop using.
class DvChip extends StatelessWidget {
  const DvChip({
    required this.label,
    required this.onTap,
    super.key,
    this.leading,
    this.selected = false,
    this.minContentHeight,
  });

  final String label;

  /// Null where the chip is shown but cannot be taken — then it draws no ink
  /// under a finger, rather than answering a tap that does nothing.
  final VoidCallback? onTap;

  /// A mark in front of the word, for a chip that stands for a kind of thing
  /// rather than for a word — the object's type.
  final Widget? leading;

  /// One of several, and this is the one. Said by the outline and the ink of
  /// the word, not by a fill: a chip that holds a coloured mark cannot be
  /// filled solid without swallowing it, and the low-alpha wash Material uses
  /// is the dust this palette was rebuilt to stop drawing.
  final bool selected;

  /// The shortest the chip's contents may be — the mark's size, where the
  /// row has marks.
  ///
  /// For a run that mixes chips with a mark and chips without: a word alone
  /// is shorter than a word beside a 28 square, and pills at two heights
  /// read as one of them having slipped. The caller names it because only it
  /// knows what the tallest chip in its row carries, and names the contents
  /// rather than the chip so neither side has to know the other's padding.
  final double? minContentHeight;

  /// The same on both states, so the word does not shift sideways by a pixel
  /// when the choice moves.
  static const double _border = 2;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final selected = this.selected;
    final leading = this.leading;
    final minContentHeight = this.minContentHeight;

    final style = context.textTheme.labelLarge?.copyWith(
      color: selected ? scheme.primary : scheme.onSurfaceVariant,
    );
    final boldStyle = style?.copyWith(fontWeight: FontWeight.w700);

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.sm,
      children: [
        ?leading,
        // The bold word is wider than the plain one, and in a wrapping row
        // that pushed every chip after it along when the choice moved. Both
        // states take the bold width; the hidden copy only holds the space.
        Stack(
          alignment: Alignment.center,
          children: [
            ExcludeSemantics(
              child: Opacity(opacity: 0, child: Text(label, style: boldStyle)),
            ),
            Text(label, style: selected ? boldStyle : style),
          ],
        ),
      ],
    );

    return Material(
      color: Colors.transparent,
      shape: StadiumBorder(
        side: BorderSide(
          color: selected ? scheme.primary : scheme.outlineVariant,
          width: _border,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            leading == null ? AppSpacing.md : AppSpacing.sm,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.sm,
          ),
          child: minContentHeight == null
              ? content
              : ConstrainedBox(
                  constraints: BoxConstraints(minHeight: minContentHeight),
                  child: content,
                ),
        ),
      ),
    );
  }
}
