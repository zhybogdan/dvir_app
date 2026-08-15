import 'dart:math' as math;

import 'package:dvir/app/icons.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/core/logging/tap_log.dart';
import 'package:dvir/features/Shared/presentation/dv_icon_button.dart';
import 'package:flutter/material.dart';

/// One line of a [DvMenu].
///
/// [icon] is required rather than optional: a menu of bare labels reads as a
/// list of settings, and the one row that ends an object needs to look
/// different from the one that renames it before it is tapped, not after.
class DvMenuItem {
  const DvMenuItem({
    required this.label,
    required this.icon,
    required this.onSelected,
    this.isDestructive = false,
  });

  final String label;
  final IconData icon;

  /// Run after the menu is gone, so what it opens next is not layered over a
  /// menu that is still closing.
  final VoidCallback onSelected;

  /// Paints the row in `error` — for what cannot be undone.
  final bool isDestructive;
}

/// The three-dot button and the card it opens.
///
/// Replaces `PopupMenuButton`, which owns its own rows and lets a caller change
/// little more than their text — no icon, no destructive row, and a card whose
/// corners belong to Material rather than to this app. Here the card is ours:
/// it hangs off the button's right edge, flips above it when the bottom of the
/// screen is closer than the menu is tall, and grows out of the corner it is
/// anchored to.
class DvMenu extends StatelessWidget {
  const DvMenu({required this.items, required this.tooltip, super.key});

  final List<DvMenuItem> items;

  /// What the button is for, since three dots say nothing to a screen reader.
  final String tooltip;

  Future<void> _open(BuildContext context) async {
    // The button's own box, which is what the card is positioned against.
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;

    final anchor = box.localToGlobal(Offset.zero) & box.size;

    final selected = await Navigator.of(context).push(
      _DvMenuRoute(
        anchor: anchor,
        items: items,
        barrierLabel: MaterialLocalizations.of(
          context,
        ).modalBarrierDismissLabel,
      ),
    );

    selected?.onSelected();
  }

  @override
  Widget build(BuildContext context) {
    return DvIconButton(
      icon: AppIcons.more,
      tooltip: tooltip,
      onPressed: () => _open(context),
    );
  }
}

/// Height of one row, and the reason the card's height is known before it is
/// laid out — which is what lets the route decide up or down in one place.
const double _rowHeight = 48;

/// Breathing room above the first row and below the last.
const double _cardPadding = AppSpacing.sm;

/// Between the button and the card, and between the card and the screen edge.
const double _gap = AppSpacing.sm;

const double _minWidth = 180;
const double _maxWidth = 280;

double _cardHeight(int rows) => rows * _rowHeight + _cardPadding * 2;

/// The card's own route: a barrier that dismisses on a tap outside, and a
/// result that is the chosen item.
class _DvMenuRoute extends PopupRoute<DvMenuItem> {
  // Named so the route observer logs "DvMenu" rather than an unnamed route.
  _DvMenuRoute({
    required this.anchor,
    required this.items,
    required this.barrierLabel,
  }) : super(settings: const RouteSettings(name: 'DvMenu'));

  /// Where the button sits, in global coordinates.
  final Rect anchor;
  final List<DvMenuItem> items;

  @override
  final String barrierLabel;

  @override
  bool get barrierDismissible => true;

  /// Transparent: a menu is a small decision next to what it acts on, and
  /// dimming the screen behind it makes it read as a page.
  @override
  Color? get barrierColor => null;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 160);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final media = MediaQuery.of(context);

    // Decided here rather than in the delegate so the card and the animation it
    // grows out of cannot disagree about which way it opened.
    final opensDown =
        anchor.bottom + _gap + _cardHeight(items.length) <=
        media.size.height - media.padding.bottom;

    return CustomSingleChildLayout(
      delegate: _DvMenuLayout(
        anchor: anchor,
        insets: media.padding,
        opensDown: opensDown,
      ),
      child: FadeTransition(
        opacity: animation.drive(CurveTween(curve: Curves.easeOut)),
        child: ScaleTransition(
          scale: animation.drive(
            Tween(
              begin: 0.92,
              end: 1.0,
            ).chain(CurveTween(curve: Curves.easeOutCubic)),
          ),
          alignment: opensDown ? Alignment.topRight : Alignment.bottomRight,
          child: _DvMenuCard(items: items),
        ),
      ),
    );
  }

  /// Everything is animated inside [buildPage], where the direction the card
  /// opened in is known.
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => child;
}

/// Hangs the card off the button's right edge, kept inside the screen.
class _DvMenuLayout extends SingleChildLayoutDelegate {
  const _DvMenuLayout({
    required this.anchor,
    required this.insets,
    required this.opensDown,
  });

  final Rect anchor;
  final EdgeInsets insets;
  final bool opensDown;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      BoxConstraints(
        minWidth: _minWidth,
        maxWidth: _maxWidth,
        maxHeight: math.max(
          _rowHeight,
          constraints.maxHeight - insets.vertical - _gap * 2,
        ),
      );

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final left = _clamp(
      anchor.right - childSize.width,
      _gap,
      size.width - childSize.width - _gap,
    );

    final top = opensDown
        ? anchor.bottom + _gap
        : anchor.top - childSize.height - _gap;

    return Offset(
      left,
      _clamp(
        top,
        insets.top + _gap,
        size.height - insets.bottom - childSize.height - _gap,
      ),
    );
  }

  /// `num.clamp` throws when the screen is smaller than the card; here the
  /// lower bound simply wins.
  double _clamp(double value, double min, double max) =>
      math.min(math.max(value, min), math.max(min, max));

  @override
  bool shouldRelayout(_DvMenuLayout oldDelegate) =>
      anchor != oldDelegate.anchor ||
      insets != oldDelegate.insets ||
      opensDown != oldDelegate.opensDown;
}

class _DvMenuCard extends StatelessWidget {
  const _DvMenuCard({required this.items});

  final List<DvMenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colorScheme.surfaceContainerHigh,
      elevation: 8,
      shadowColor: context.colorScheme.shadow,
      borderRadius: BorderRadius.circular(AppRadius.md),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: _cardPadding),
          for (final item in items) _DvMenuRow(item: item),
          const SizedBox(height: _cardPadding),
        ],
      ),
    );
  }
}

class _DvMenuRow extends StatelessWidget {
  const _DvMenuRow({required this.item});

  final DvMenuItem item;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final item = this.item;
    final color = item.isDestructive ? scheme.error : scheme.onSurface;

    return InkWell(
      // Logged here rather than around `onSelected`, so the line lands when the
      // row is pressed and not after the menu has finished closing.
      onTap: loggedTap(item.label, () => Navigator.of(context).pop(item)),
      child: SizedBox(
        height: _rowHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            spacing: AppSpacing.md,
            children: [
              Icon(item.icon, size: AppSpacing.lg, color: color),
              Expanded(
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyMedium?.copyWith(color: color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
