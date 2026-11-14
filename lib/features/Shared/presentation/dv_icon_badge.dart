import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

/// An icon on a tinted rounded square, for the leading slot of a [DvTile].
///
/// A bare glyph beside a title reads as decoration; the same glyph on a filled
/// square reads as what the row *is*. Shared rather than private to the home
/// screen because the objects nested inside another are the same kind of row,
/// one level down.
class DvIconBadge extends StatelessWidget {
  const DvIconBadge({
    required this.icon,
    super.key,
    this.tone,
    this.muted = false,
    this.dense = false,
  });

  final IconData icon;

  /// What kind of thing the row is. Given one, the square is filled with it
  /// solid and the glyph is drawn in [AppTones.on]; left out, the badge keeps
  /// the quiet wash of the accent it has always had.
  final Tone? tone;

  /// For a row that cannot be opened yet — a scope still waiting for approval,
  /// which reads as a request rather than as a place this person already lives
  /// in.
  final bool muted;

  /// Matches `DvTile.dense`: a list inside a screen, where the full-size badge
  /// stands taller than the two lines beside it.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final brightness = Theme.of(context).brightness;
    final box = dense ? 36.0 : 44.0;
    final glyph = dense ? 20.0 : 24.0;

    // A muted row is one that cannot be opened yet, so it keeps the wash
    // whatever kind of thing it is: colour here would say the row is live.
    final tone = muted ? null : this.tone;
    final fill = tone?.of(brightness);
    final color = muted ? scheme.onSurfaceVariant : scheme.primary;

    return Container(
      width: box,
      height: box,
      decoration: BoxDecoration(
        color: fill ?? color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Icon(
        icon,
        color: fill == null ? color : AppTones.on(brightness),
        size: glyph,
      ),
    );
  }
}
