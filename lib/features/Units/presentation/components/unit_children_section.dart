import 'package:dvir/app/routes.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Shared/presentation/dv_async_view.dart';
import 'package:dvir/features/Shared/presentation/dv_empty_view.dart';
import 'package:dvir/features/Shared/presentation/dv_icon_badge.dart';
import 'package:dvir/features/Shared/presentation/dv_section_title.dart';
import 'package:dvir/features/Shared/presentation/dv_tiles_skeleton.dart';
import 'package:dvir/features/Units/application/unit_children_controller.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/features/Units/presentation/unit_type_icon.dart';
import 'package:dvir/features/Units/presentation/unit_type_l10n.dart';
import 'package:dvir/features/Units/presentation/unit_type_tone.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// The objects inside this one, each a hub of its own to enter.
///
/// Heading and list in one widget, where the hub used to write the heading and
/// put the list under it: the number in the heading is the length of the list
/// below, so apart they could only agree by asking for the same rows twice.
///
/// Drawn as a grid, two to a row, where the sections above it are pairs and a
/// row of papers: the family colour does the telling, and a shape unlike its
/// neighbours is what keeps the hub from reading as five lists in a column.
class UnitChildrenSection extends ConsumerWidget {
  const UnitChildrenSection({
    required this.unitId,
    required this.canAdd,
    super.key,
  });

  final String unitId;

  /// Whether this reader may put another object inside this one.
  ///
  /// Passed in rather than asked for here, unlike the sections next to it: the
  /// answer depends on the type of the object as well as on who is looking,
  /// and the hub is already holding the object.
  final bool canAdd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unitId = this.unitId;
    final children = ref.watch(unitChildrenProvider(unitId));

    return Column(
      children: [
        DvSectionTitle(
          l10n.unitNested,
          count: children.value?.length,
          action: canAdd
              ? (
                  label: l10n.unitAddCta,
                  onPressed: () => context.push(AppRoutes.unitAddPath(unitId)),
                )
              : null,
        ),
        DvAsyncView<List<Unit>>(
          value: children,
          skeleton: const DvTilesSkeleton(),
          onRetry: () => ref.invalidate(unitChildrenProvider(unitId)),
          builder: (context, children) => children.isEmpty
              ? DvEmptyView(message: l10n.unitNestedEmpty)
              : Column(
                  spacing: AppSpacing.md,
                  children: [
                    for (var i = 0; i < children.length; i += 2)
                      _InsideRow(
                        left: children[i],
                        right: children.elementAtOrNull(i + 1),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

/// Two objects side by side, as tall as the taller of them.
///
/// A row rather than a `Wrap`: a garage called "Гараж" drops its second line
/// and came out shorter than the bedroom beside it, and two cards of different
/// heights in one row read as a mistake. Half the width each, so the grid stays
/// two to a row on a narrow phone and leaves no strip of nothing on a wide one.
class _InsideRow extends StatelessWidget {
  const _InsideRow({required this.left, this.right});

  final Unit left;
  final Unit? right;

  @override
  Widget build(BuildContext context) {
    final right = this.right;

    // Intrinsic height for two cards is a measurement twice, not a cost: it is
    // the only way a row learns how tall its taller card is before laying out.
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.md,
        children: [
          Expanded(child: _InsideCard(unit: left)),
          Expanded(
            child: right == null
                ? const SizedBox.shrink()
                : _InsideCard(unit: right),
          ),
        ],
      ),
    );
  }
}

/// One object inside this one, as a card to enter.
class _InsideCard extends StatelessWidget {
  const _InsideCard({required this.unit});

  final Unit unit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final unit = this.unit;
    final type = unit.type.label(l10n);
    final scheme = context.colorScheme;
    final radius = BorderRadius.circular(AppRadius.lg);

    return DecoratedBox(
      decoration: AppSurfaces.card(scheme),
      // Transparent, so the ink lands above the card's own fill — the same
      // reason DvTile gives for it.
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: () => context.push(AppRoutes.unitPath(unit.id)),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DvIconBadge(
                  icon: unit.type.icon,
                  tone: unit.type.tone,
                  dense: true,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  unit.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // The kind only where the name has not already said it — a
                // garage called "Гараж" read its own name twice, the same
                // repetition the object's head drops.
                if (type.toLowerCase() != unit.label.toLowerCase())
                  Text(
                    type,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
