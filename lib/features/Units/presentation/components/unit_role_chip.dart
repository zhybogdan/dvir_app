import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Units/domain/types/unit_role.dart';
import 'package:dvir/features/Units/presentation/unit_role_l10n.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// A resident's role, told apart at a glance.
///
/// The owner is filled and tinted, everyone else outlined. A residents list is
/// read to find out who decides here — and the same grey caption under all
/// three roles never answered that.
class UnitRoleChip extends StatelessWidget {
  const UnitRoleChip({required this.role, super.key});

  final UnitRole role;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = context.colorScheme;
    final role = this.role;

    final isOwner = role == UnitRole.owner;
    final color = isOwner ? scheme.primary : scheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isOwner ? color.withValues(alpha: 0.12) : Colors.transparent,
        border: isOwner
            ? null
            : Border.all(color: scheme.surfaceContainerHighest),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.xs,
        children: [
          Icon(_iconFor(role), size: AppSpacing.md, color: color),
          Text(
            role.label(l10n),
            style: context.textTheme.labelSmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(UnitRole role) => switch (role) {
    UnitRole.owner => Icons.key_rounded,
    UnitRole.family => Icons.people_alt_outlined,
    UnitRole.tenant => Icons.badge_outlined,
  };
}
