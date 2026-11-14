import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

/// Fills the space a list would occupy when there is nothing in it yet.
///
/// The counterpart of [DvErrorView], and its opposite in tone: nothing has gone
/// wrong here. [message] is meant to say what belongs in the space rather than
/// that the space is empty — "a room, a garage, a summer kitchen" answers the
/// question "what do I put here", and "nothing yet" only restates it.
class DvEmptyView extends StatelessWidget {
  const DvEmptyView({required this.message, super.key, this.icon});

  final String message;

  /// Left out on a section inside a screen, where a second icon competes with
  /// the content around it.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
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
