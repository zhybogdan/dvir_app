import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/features/Units/presentation/unit_type_l10n.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// What the object is, at the top of its hub.
class UnitSpecsCard extends StatelessWidget {
  const UnitSpecsCard({required this.unit, super.key});

  final Unit unit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final unit = this.unit;
    final area = unit.areaM2;

    // Whatever the object actually carries: a flat has an area, a plot in a
    // village may have neither city nor number.
    //
    // An address is only shown on a top-level object. A room or a garage stands
    // at the address of the house around it, and repeating it here would state
    // the parent's fact as the child's own.
    final isNested = unit.parentId != null;
    final lines = <String>[
      unit.type.label(l10n),
      if (!isNested) ...[?unit.address, ?unit.city],
      if (area != null) l10n.unitAreaValue(_area(area)),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.xs,
        children: [
          Text(unit.label, style: context.textTheme.titleLarge),
          for (final line in lines)
            Text(
              line,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }

  /// Areas are whole numbers far more often than not, and "102 м²" reads
  /// better on a card than "102.0 м²".
  String _area(double value) =>
      value == value.roundToDouble() ? '${value.round()}' : '$value';
}
