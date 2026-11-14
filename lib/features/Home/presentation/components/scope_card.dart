import 'package:dvir/app/icons.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

/// One number a card shows about what a place holds, with the word for it.
///
/// The label is never drawn: three numbers in a row read as a row of numbers
/// to anyone looking, and as nothing at all to a screen reader. It is what the
/// reader is given instead of "12 5 3".
typedef ScopeCount = ({IconData icon, int value, String label});

/// The card the home screen is a list of: an object, or a community.
///
/// Not a [DvTile] with a slot added. The strip runs the full height of the
/// card and starts at its very edge, which is a different shape rather than a
/// different leading widget — and `DvTile` has sixteen consumers that want
/// none of it.
class ScopeCard extends StatelessWidget {
  const ScopeCard({
    required this.icon,
    required this.title,
    super.key,
    this.subtitle,
    this.tone,
    this.counts = const [],
    this.onTap,
    this.dense = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;

  /// The family the place belongs to. Left out for a scope that cannot be
  /// opened yet: colour would say the row is live.
  final Tone? tone;

  /// What the place holds. Empty wherever the contents are unknown — a card
  /// showing nothing says less than a card claiming zero.
  final List<ScopeCount> counts;

  final VoidCallback? onTap;

  /// An object standing inside the one above it, drawn smaller and indented by
  /// whoever places it.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final brightness = Theme.of(context).brightness;
    final tone = this.tone;
    final subtitle = this.subtitle;
    final onTap = this.onTap;
    final width = dense ? 60.0 : 76.0;

    final fill = tone?.of(brightness) ?? scheme.surfaceContainerHighest;
    final glyph = tone == null
        ? scheme.onSurfaceVariant
        : AppTones.on(brightness);

    final content = Stack(
      children: [
        // Positioned rather than a stretched row: inside a list the card has
        // no height to stretch to, and the body is what gives it one.
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          width: width,
          child: ColoredBox(
            color: fill,
            child: Icon(icon, color: glyph, size: dense ? 24 : 30),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: width),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppSpacing.xs,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: dense
                            ? context.textTheme.titleSmall
                            : context.textTheme.titleMedium,
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      if (counts.isNotEmpty) _Counts(counts: counts),
                    ],
                  ),
                ),
                if (onTap != null)
                  Icon(AppIcons.forward, color: scheme.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Container(
        // Clipped, so the strip ends where the corner does. The hairline runs
        // underneath it and is covered along that edge — which is what the
        // strip is there to be.
        clipBehavior: Clip.antiAlias,
        decoration: AppSurfaces.card(scheme),
        child: Material(
          color: Colors.transparent,
          child: onTap == null
              ? content
              : InkWell(onTap: onTap, child: content),
        ),
      ),
    );
  }
}

class _Counts extends StatelessWidget {
  const _Counts({required this.counts});

  final List<ScopeCount> counts;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final style = context.textTheme.labelSmall?.copyWith(
      color: scheme.onSurfaceVariant,
    );

    // Wrapped rather than a row: at the largest font the app follows, three
    // numbers and their glyphs no longer fit one line on a narrow phone.
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.xs,
        children: [
          for (final count in counts)
            Semantics(
              label: '${count.label}: ${count.value}',
              excludeSemantics: true,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: AppSpacing.xs,
                children: [
                  Icon(count.icon, size: 14, color: scheme.onSurfaceVariant),
                  Text('${count.value}', style: style),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
