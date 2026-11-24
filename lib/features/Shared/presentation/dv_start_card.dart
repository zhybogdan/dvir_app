import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/core/logging/tap_log.dart';
import 'package:dvir/features/Shared/presentation/dv_icon_badge.dart';
import 'package:flutter/material.dart';

/// One first move, offered where there is nothing yet: a solid mark, what to
/// do, and why it is worth doing.
///
/// The shape an empty screen invites with in this app — on an object that
/// holds nothing, and on the list of objects before the first one exists. No
/// chevron: a chevron here means a list opens, and these open a sheet or a
/// form.
///
/// [text] is the reason rather than examples. The sheet that opens leads with
/// the examples anyway, and a person reading an empty screen is deciding
/// whether to start at all.
class DvStartCard extends StatelessWidget {
  const DvStartCard({
    required this.icon,
    required this.tone,
    required this.title,
    required this.text,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final Tone tone;
  final String title;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final radius = BorderRadius.circular(AppRadius.lg);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: DecoratedBox(
        decoration: AppSurfaces.card(scheme),
        // Transparent, so the ink of a tap lands above the card's own fill
        // rather than painting over its hairline — the same reason DvTile
        // gives for it.
        child: Material(
          color: Colors.transparent,
          borderRadius: radius,
          child: InkWell(
            onTap: loggedTap(title, onTap),
            borderRadius: radius,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                spacing: AppSpacing.md,
                children: [
                  DvIconBadge(icon: icon, tone: tone),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: context.textTheme.titleSmall),
                        Text(
                          text,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
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
