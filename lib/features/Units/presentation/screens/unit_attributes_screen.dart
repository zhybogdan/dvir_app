import 'package:dvir/app/icons.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/async_value_x.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Members/application/unit_members_controller.dart';
import 'package:dvir/features/Shared/presentation/dv_app_bar.dart';
import 'package:dvir/features/Shared/presentation/dv_async_view.dart';
import 'package:dvir/features/Shared/presentation/dv_empty_view.dart';
import 'package:dvir/features/Shared/presentation/dv_icon_button.dart';
import 'package:dvir/features/Shared/presentation/dv_page_head.dart';
import 'package:dvir/features/Shared/presentation/dv_scaffold.dart';
import 'package:dvir/features/Shared/presentation/dv_tiles_skeleton.dart';
import 'package:dvir/features/Units/application/unit_attributes_controller.dart';
import 'package:dvir/features/Units/application/unit_controller.dart';
import 'package:dvir/features/Units/domain/models/unit_attribute.dart';
import 'package:dvir/features/Units/presentation/components/unit_attribute_tile.dart';
import 'package:dvir/features/Units/presentation/components/unit_attributes_section.dart';
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
    final attributes = ref.watch(unitAttributesProvider(unitId));

    ref.listen(
      unitAttributeActionsProvider(unitId),
      (previous, next) => next.showFailure(context, ref),
    );

    return DvScaffold(
      appBar: DvAppBar(
        title: '',
        actions: [
          if (canEdit)
            DvIconButton(
              // The section's own, not a second copy: the hub, the start
              // block and this screen all open one sheet with one set of
              // suggestions behind it.
              onPressed: () => UnitAttributesSection.add(context, ref, unitId),
              icon: AppIcons.add,
              tooltip: l10n.unitAddCta,
            ),
        ],
      ),
      body: Column(
        children: [
          DvPageHead(
            l10n.unitAttributes,
            count: attributes.value?.length,
            of: ref.watch(unitProvider(unitId)).value?.label,
          ),
          Expanded(
            child: DvAsyncView<List<UnitAttribute>>(
              value: attributes,
              skeleton: const Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: DvTilesSkeleton(),
              ),
              onRetry: () => ref.invalidate(unitAttributesProvider(unitId)),
              builder: (context, attributes) => attributes.isEmpty
                  ? DvEmptyView.page(
                      message: l10n.unitAttributesEmpty,
                      icon: AppIcons.attribute,
                    )
                  : _Record(
                      unitId: unitId,
                      attributes: attributes,
                      canEdit: canEdit,
                    ),
            ),
          ),
        ],
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
      padding: context.pagePadding,
      // The handle is drawn by the row itself, on the left, away from the menu
      // button — the default wraps the whole row on desktop and puts a second
      // grip on the right on mobile.
      buildDefaultDragHandles: false,
      proxyDecorator: (child, index, animation) =>
          _pickedUp(attributes[index], animation),
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
            divided: index > 0,
          ),
      ],
    );
  }

  /// How a row looks while it is held: lifted off the page as a card.
  ///
  /// The row has no surface of its own, so held as it is it would slide over
  /// its neighbours as bare text crossing bare text. Drawn afresh from the fact
  /// rather than from the list's own child: that child carries the hairline
  /// above it, and a hairline inside a lifted card reads as a fault.
  ///
  /// The default decorator is no use either — an opaque square `Material` in
  /// the canvas colour, a grey rectangle where a rounded card should be.
  Widget _pickedUp(UnitAttribute attribute, Animation<double> animation) =>
      AnimatedBuilder(
        animation: animation,
        builder: (context, child) => Transform.scale(
          scale: 1 + 0.03 * Curves.easeOut.transform(animation.value),
          child: child,
        ),
        child: Builder(
          builder: (context) => Material(
            type: MaterialType.transparency,
            // The card reaches past the row on both sides rather than padding
            // it, so the text stays exactly where it was when the finger
            // landed instead of jumping inward by the card's margin.
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: -AppSpacing.sm,
                  right: -AppSpacing.sm,
                  top: 0,
                  bottom: 0,
                  child: DecoratedBox(
                    decoration: AppSurfaces.card(context.colorScheme),
                  ),
                ),
                UnitAttributeTile(
                  unitId: unitId,
                  attribute: attribute,
                  canEdit: canEdit,
                  dragIndex: canEdit ? 0 : null,
                ),
              ],
            ),
          ),
        ),
      );
}
