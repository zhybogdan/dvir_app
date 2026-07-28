import 'package:dvir/app/routes.dart';
import 'package:dvir/features/Shared/presentation/dv_async_view.dart';
import 'package:dvir/features/Shared/presentation/dv_empty_view.dart';
import 'package:dvir/features/Shared/presentation/dv_tile.dart';
import 'package:dvir/features/Units/application/unit_children_controller.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/features/Units/presentation/components/unit_tiles_skeleton.dart';
import 'package:dvir/features/Units/presentation/unit_type_l10n.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The objects inside this one, each a hub of its own to enter.
class UnitChildrenList extends ConsumerWidget {
  const UnitChildrenList({required this.unitId, super.key});

  final String unitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unitId = this.unitId;

    return DvAsyncView<List<Unit>>(
      value: ref.watch(unitChildrenProvider(unitId)),
      skeleton: const UnitTilesSkeleton(),
      onRetry: () => ref.invalidate(unitChildrenProvider(unitId)),
      builder: (context, children) => children.isEmpty
          ? DvEmptyView(message: l10n.unitNestedEmpty)
          : Column(
              children: [
                for (final child in children)
                  DvTile(
                    title: child.label,
                    subtitle: child.type.label(l10n),
                    dense: true,
                    onTap: () => context.push(AppRoutes.unitPath(child.id)),
                  ),
              ],
            ),
    );
  }
}
