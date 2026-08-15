import 'package:dvir/app/icons.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/async_value_x.dart';
import 'package:dvir/features/Members/application/unit_members_controller.dart';
import 'package:dvir/features/Shared/presentation/dv_app_bar.dart';
import 'package:dvir/features/Shared/presentation/dv_async_view.dart';
import 'package:dvir/features/Shared/presentation/dv_background.dart';
import 'package:dvir/features/Shared/presentation/dv_empty_view.dart';
import 'package:dvir/features/Shared/presentation/dv_icon_button.dart';
import 'package:dvir/features/Shared/presentation/dv_scaffold.dart';
import 'package:dvir/features/Shared/presentation/dv_tiles_skeleton.dart';
import 'package:dvir/features/Units/application/unit_attributes_controller.dart';
import 'package:dvir/features/Units/domain/models/unit_attribute.dart';
import 'package:dvir/features/Units/presentation/components/unit_attribute_sheet.dart';
import 'package:dvir/features/Units/presentation/components/unit_attribute_tile.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The object's whole record, and the place its order is decided.
///
/// Dragging is here rather than in the hub for two reasons that point the same
/// way: the hub shows five rows, which is not enough of the record to arrange,
/// and a row dragged inside a screen that is itself one long scroll fights the
/// scroll it sits in. Here the list *is* the screen, so it scrolls itself while
/// a row is held near its edge.
class UnitAttributesScreen extends ConsumerWidget {
  const UnitAttributesScreen({required this.unitId, super.key});

  final String unitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unitId = this.unitId;
    final canEdit = ref.watch(isUnitKeeperProvider(unitId));

    ref.listen(
      unitAttributeActionsProvider(unitId),
      (previous, next) => next.showFailure(context, ref),
    );

    Future<void> add() async {
      final actions = ref.read(unitAttributeActionsProvider(unitId).notifier);

      final draft = await UnitAttributeSheet.open(context);
      if (draft == null) return;

      await actions.add(name: draft.name, value: draft.value);
    }

    return DvScaffold(
      background: const DvAppGradient(),
      appBar: DvAppBar(
        title: l10n.unitAttributes,
        actions: [
          if (canEdit)
            DvIconButton(
              onPressed: add,
              icon: AppIcons.add,
              tooltip: l10n.unitAddCta,
            ),
        ],
      ),
      body: DvAsyncView<List<UnitAttribute>>(
        value: ref.watch(unitAttributesProvider(unitId)),
        skeleton: const Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: DvTilesSkeleton(),
        ),
        onRetry: () => ref.invalidate(unitAttributesProvider(unitId)),
        builder: (context, attributes) => attributes.isEmpty
            ? DvEmptyView(message: l10n.unitAttributesEmpty)
            : _Record(unitId: unitId, attributes: attributes, canEdit: canEdit),
      ),
    );
  }
}

class _Record extends ConsumerWidget {
  const _Record({
    required this.unitId,
    required this.attributes,
    required this.canEdit,
  });

  final String unitId;
  final List<UnitAttribute> attributes;
  final bool canEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unitId = this.unitId;
    final attributes = this.attributes;
    final canEdit = this.canEdit;

    return ReorderableListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      // The handle is drawn by the row itself, on the left, away from the menu
      // button — the default wraps the whole row on desktop and puts a second
      // grip on the right on mobile.
      buildDefaultDragHandles: false,
      proxyDecorator: _pickedUp,
      // `onReorderItem` rather than `onReorder`: it hands over an index already
      // counted against the list with the row taken out of it, which is the
      // off-by-one every reorderable list used to fix by hand.
      onReorderItem: (from, to) {
        if (from == to) return;

        ref
            .read(unitAttributeActionsProvider(unitId).notifier)
            .move(from: from, to: to);
      },
      children: [
        for (final (index, attribute) in attributes.indexed)
          UnitAttributeTile(
            // Identity has to survive the move, or the rows animate into each
            // other's places by position rather than travelling with the drag.
            key: ValueKey(attribute.id),
            unitId: unitId,
            attribute: attribute,
            canEdit: canEdit,
            dragIndex: canEdit ? index : null,
          ),
      ],
    );
  }

  /// How a row looks while it is held.
  ///
  /// The default decorator wraps the row in an opaque `Material` of its own —
  /// square, filled with the theme's canvas colour, and elevated. Around a card
  /// that has round corners and a surface of its own, that reads as a grey
  /// rectangle appearing behind the row the moment it is touched.
  ///
  /// The row is already a `Material`, so all it needs while held is to look
  /// picked up: transparent above it, and a size the finger is clearly holding.
  Widget _pickedUp(Widget child, int index, Animation<double> animation) =>
      AnimatedBuilder(
        animation: animation,
        builder: (context, child) => Material(
          type: MaterialType.transparency,
          child: Transform.scale(
            scale: 1 + 0.03 * Curves.easeOut.transform(animation.value),
            child: child,
          ),
        ),
        child: child,
      );
}
