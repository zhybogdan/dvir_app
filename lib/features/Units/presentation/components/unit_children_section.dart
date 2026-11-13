import 'package:dvir/app/routes.dart';
import 'package:dvir/features/Shared/presentation/dv_async_view.dart';
import 'package:dvir/features/Shared/presentation/dv_empty_view.dart';
import 'package:dvir/features/Shared/presentation/dv_icon_badge.dart';
import 'package:dvir/features/Shared/presentation/dv_section_title.dart';
import 'package:dvir/features/Shared/presentation/dv_tile.dart';
import 'package:dvir/features/Shared/presentation/dv_tiles_skeleton.dart';
import 'package:dvir/features/Units/application/unit_children_controller.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/features/Units/presentation/unit_type_icon.dart';
import 'package:dvir/features/Units/presentation/unit_type_l10n.dart';
import 'package:dvir/features/Units/presentation/unit_type_tone.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The objects inside this one, each a hub of its own to enter.
///
/// Heading and list in one widget, where the hub used to write the heading and
/// put the list under it: the number in the heading is the length of the list
/// below, so apart they could only agree by asking for the same rows twice.
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
                  children: [
                    for (final child in children)
                      DvTile(
                        title: child.label,
                        subtitle: child.type.label(l10n),
                        leading: DvIconBadge(
                          icon: child.type.icon,
                          tone: child.type.tone,
                          dense: true,
                        ),
                        dense: true,
                        onTap: () => context.push(AppRoutes.unitPath(child.id)),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}
