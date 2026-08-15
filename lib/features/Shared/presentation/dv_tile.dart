import 'package:dvir/app/icons.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

/// The card every list in the app is made of.
///
/// A scope on the home screen, an object inside another, a person in a
/// household — three lists that were written separately and came out nearly
/// identical, down to the same radius and the same fill. They are one shape,
/// and this is it, so the fourth list does not become a fourth copy.
///
/// The slots exist because each of those three needs a different part of the
/// same layout: a badge instead of a subtitle, a third quiet line, a control on
/// the right, a row of answers underneath.
class DvTile extends StatelessWidget {
  const DvTile({
    required this.title,
    super.key,
    this.subtitle,
    this.badge,
    this.caption,
    this.leading,
    this.trailing,
    this.footer,
    this.onTap,
    this.dense = false,
  });

  final String title;

  /// The line under the title, in words.
  final String? subtitle;

  /// The line under the title, as something drawn — a role badge, where a role
  /// spelled out in the same grey as everything else would not be found.
  final Widget? badge;

  /// A third and quieter line, for what the row contains rather than what it
  /// is. Kept to one line: a card that grows with its contents makes a list
  /// ragged.
  final String? caption;

  final Widget? leading;

  /// Replaces the chevron that a tappable tile shows by default.
  final Widget? trailing;

  /// Sits below the row, across the full width — where a decision with two
  /// answers goes.
  final Widget? footer;

  final VoidCallback? onTap;

  /// For a list inside a screen rather than a screen that *is* a list.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final radius = BorderRadius.circular(AppRadius.lg);
    final onTap = this.onTap;

    final content = Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ?_leadingOf(),
              Expanded(child: _Lines(tile: this)),
              ?_trailingOf(scheme),
            ],
          ),
          ?footer,
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: scheme.surfaceContainerLow,
        borderRadius: radius,
        child: onTap == null
            ? content
            : InkWell(onTap: onTap, borderRadius: radius, child: content),
      ),
    );
  }

  Widget? _leadingOf() {
    final leading = this.leading;

    return leading == null
        ? null
        : Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: leading,
          );
  }

  Widget? _trailingOf(ColorScheme scheme) {
    final trailing = this.trailing;
    if (trailing != null) return trailing;

    return onTap == null
        ? null
        : Icon(AppIcons.forward, color: scheme.onSurfaceVariant);
  }
}

class _Lines extends StatelessWidget {
  const _Lines({required this.tile});

  final DvTile tile;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final text = context.textTheme;
    final tile = this.tile;
    final subtitle = tile.subtitle;
    final caption = tile.caption;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.xs,
      children: [
        // Two lines, because a nested object carries its parent in its name and
        // one line cuts most of them off. Past that it is a list of cards, and
        // a card that grows with its title makes the list ragged.
        Text(
          tile.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: tile.dense ? text.titleSmall : text.titleMedium,
        ),
        ?tile.badge,
        if (subtitle != null)
          Text(
            subtitle,
            style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
        if (caption != null)
          Text(
            caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
      ],
    );
  }
}
