import 'dart:ui';

import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/core/logging/tap_log.dart';
import 'package:material_ui/material_ui.dart';

/// One place the island leads to.
///
/// [label] is never drawn. Four places each with a glyph people already know
/// read faster without words under them — but the word is what a screen reader
/// says and what a long press shows, so every tab carries one.
typedef DvNavItem = ({IconData icon, String label});

/// The app's four places, as a pill floating over the content.
///
/// Translucent with a blur under it, so the list scrolling beneath stays in
/// sight rather than ending at a slab nailed to the bottom edge. The page
/// underneath has to leave it room: [space] is what every scrolling screen in
/// the tabs adds to its bottom padding, which `AppShell` hands them through
/// `MediaQuery` rather than each screen knowing the island exists.
///
/// The chosen tab is the primary colour on a pale pill, as drawn on 2026-11-15.
/// This is the one place a wash stands in for a solid mark: the glyph itself
/// is solid, and a solid pill under a solid glyph would need a second colour
/// the palette does not have.
class DvNavIsland extends StatelessWidget {
  const DvNavIsland({
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final List<DvNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const double height = 56;

  /// The height the island takes above the system's own inset: itself, and
  /// the gap under it.
  static const double space = height + AppSpacing.md;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final dark = scheme.brightness == Brightness.dark;
    final radius = BorderRadius.circular(height / 2);

    return DecoratedBox(
      // The shadow outside the clip, or the clip cuts it off.
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: AppShadows.card(scheme.brightness),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: height,
            decoration: BoxDecoration(
              // A touch more opaque in dark: the same alpha over a dark page
              // lets the cards beneath show through as grey smears.
              color: scheme.surface.withValues(alpha: dark ? 0.72 : 0.78),
              borderRadius: radius,
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Material(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (final (index, item) in items.indexed)
                    _Tab(
                      item: item,
                      selected: index == selectedIndex,
                      onTap: () => onSelected(index),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.item, required this.selected, required this.onTap});

  final DvNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final item = this.item;
    final scheme = context.colorScheme;

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      excludeSemantics: true,
      child: Tooltip(
        message: item.label,
        child: InkResponse(
          onTap: loggedTap('tab: ${item.label}', onTap),
          customBorder: const StadiumBorder(),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: ShapeDecoration(
              shape: const StadiumBorder(),
              color: selected
                  ? scheme.primary.withValues(alpha: 0.12)
                  : Colors.transparent,
            ),
            child: Icon(
              item.icon,
              size: 24,
              color: selected ? scheme.primary : scheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
