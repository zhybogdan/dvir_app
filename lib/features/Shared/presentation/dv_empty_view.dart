import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:material_ui/material_ui.dart';

/// Fills the space a list would occupy when there is nothing in it yet.
///
/// The counterpart of [DvErrorView], and its opposite in tone: nothing has gone
/// wrong here. [message] is meant to say what belongs in the space rather than
/// that the space is empty — "a room, a garage, a summer kitchen" answers the
/// question "what do I put here", and "nothing yet" only restates it.
class DvEmptyView extends StatelessWidget {
  const DvEmptyView({required this.message, super.key, this.icon})
    : _page = false;

  /// The whole screen rather than a slot in one: a tab nobody has put anything
  /// in yet, or a list opened before its first row exists.
  ///
  /// The difference is that a screen hands this the entire height. Filled, the
  /// card stops being the shape of a missing list and becomes a white page
  /// with a line of grey at the top of it, which is the one thing the card was
  /// there to avoid. So it keeps its own height, under the heading, where the
  /// first row would have been — and it takes the page's own margins, which a
  /// section gets from the screen around it.
  const DvEmptyView.page({required this.message, super.key, this.icon})
    : _page = true;

  final String message;

  /// Left out on a section inside a screen, where a second icon competes with
  /// the content around it.
  final IconData? icon;

  final bool _page;

  @override
  Widget build(BuildContext context) {
    final card = _card(context);

    if (!_page) return card;

    return Padding(
      padding: context.pagePadding,
      child: Align(alignment: Alignment.topCenter, child: card),
    );
  }

  Widget _card(BuildContext context) {
    final scheme = context.colorScheme;
    final icon = this.icon;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      // The whole card surface, not a 60% wash of it. The wash was there to
      // say "not a row yet"; over a grey page a 60% white says nothing at all.
      // What is missing here is the shape of the list, so it keeps that shape.
      decoration: AppSurfaces.card(scheme),
      child: Column(
        // Its own height, not the slot's: on a screen the slot is the whole
        // page, and a card the height of the page is a white page.
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.sm,
        children: [
          if (icon != null) Icon(icon, color: scheme.onSurfaceVariant),
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
