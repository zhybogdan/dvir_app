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

    final isNested = unit.parentId != null;
    final lines = <String>[
      unit.type.label(l10n),
      if (!isNested) ...[?unit.address, ?unit.city],
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
}
