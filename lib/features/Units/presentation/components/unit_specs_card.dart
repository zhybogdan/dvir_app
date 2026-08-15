import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Shared/presentation/dv_icon_badge.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/features/Units/presentation/unit_type_icon.dart';
import 'package:dvir/features/Units/presentation/unit_type_l10n.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// What the object is, at the top of its hub.
///
/// Its name is not repeated here: the app bar carries it, and carries it while
/// the page scrolls, which this card does not. What takes the name's place at
/// the head is the type — with the badge beside it, because a card of evenly
/// grey lines has nothing to look at first, and a nested object has only the
/// one line to show.
class UnitSpecsCard extends StatelessWidget {
  const UnitSpecsCard({required this.unit, super.key});

  final Unit unit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final unit = this.unit;

    // A nested object stands at the address of the house around it, which is
    // its parent's fact rather than its own.
    final isNested = unit.parentId != null;
    final place = <String>[
      if (!isNested) ...[?unit.address, ?unit.city],
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        spacing: AppSpacing.md,
        children: [
          DvIconBadge(icon: unit.type.icon),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.xs,
              children: [
                Text(
                  unit.type.label(l10n),
                  style: context.textTheme.titleMedium,
                ),
                for (final line in place)
                  Text(
                    line,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
