import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Shared/presentation/dv_section_title.dart';
import 'package:flutter/material.dart';

/// The heading of a screen that holds one list: what is in here, how much of
/// it, and whose it is.
///
/// Printed on the page rather than in the app bar, as the object's own name is
/// on the hub: a screen that opens with its own heading reads as a place rather
/// than as the row that was tapped. The way to add stays in the bar, as on the
/// list of objects — the drawing put "Додати" on this line, and measured in
/// Inter, "Характеристики" beside it is cut already at 360 wide.
///
/// It stands above the list instead of scrolling away with it, so a list that
/// is empty, still loading or failed is still headed by what it is.
///
/// Every screen's heading starts the same [topGap] under the bar — the tabs,
/// the lists and the object's own screen — so moving between them, the
/// heading stays where the eye left it.
class DvPageHead extends StatelessWidget {
  const DvPageHead(this.text, {super.key, this.count, this.of});

  final String text;

  /// How many things the list holds — the same rule as [DvSectionTitle.count]:
  /// null while there is no number yet, and zero prints nothing either.
  final int? count;

  /// Whose list this is, under the heading. Null while the owner is still
  /// being read, and then the line is simply absent.
  final String? of;

  /// The distance from the bar to the heading, on this widget and on the
  /// object's screen, whose heading scrolls and is not this widget.
  static const double topGap = AppSpacing.sm;

  @override
  Widget build(BuildContext context) {
    final count = this.count;
    final of = this.of;
    final scheme = context.colorScheme;
    final styles = context.textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        topGap,
        AppSpacing.lg,
        0,
      ),
      // Full width on its own account: it sits in a screen's `Column`, which
      // centres a child as narrow as its text.
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // One line that shrinks rather than wraps: a heading is one word,
            // and wrapped it breaks in the middle — "Характеристик / и" at
            // 360 and the 1.4 cap. Shrunk to fit 320 at that cap it is still
            // larger than at 1.0, so nobody who enlarged the font loses it.
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Text.rich(
                TextSpan(
                  text: text,
                  style: styles.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                  children: [
                    if (count != null && count > 0)
                      TextSpan(
                        text: '  $count',
                        style: styles.titleMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
                maxLines: 1,
              ),
            ),
            if (of != null)
              Text(
                of,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: styles.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
