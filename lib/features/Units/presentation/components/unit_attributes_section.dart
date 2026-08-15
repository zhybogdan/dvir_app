import 'package:dvir/app/icons.dart';
import 'package:dvir/app/routes.dart';
import 'package:dvir/core/extensions/async_value_x.dart';
import 'package:dvir/features/Members/application/unit_members_controller.dart';
import 'package:dvir/features/Shared/presentation/dv_async_view.dart';
import 'package:dvir/features/Shared/presentation/dv_empty_view.dart';
import 'package:dvir/features/Shared/presentation/dv_section_title.dart';
import 'package:dvir/features/Shared/presentation/dv_text_button.dart';
import 'package:dvir/features/Shared/presentation/dv_tiles_skeleton.dart';
import 'package:dvir/features/Units/application/unit_attributes_controller.dart';
import 'package:dvir/features/Units/domain/models/unit_attribute.dart';
import 'package:dvir/features/Units/presentation/components/unit_attribute_sheet.dart';
import 'package:dvir/features/Units/presentation/components/unit_attribute_tile.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// How much of the record the hub shows before sending the reader to the
/// screen that holds all of it.
///
/// The hub is one column of sections — what the object is, who can get in, what
/// is inside it, who lives here — and a record of fifteen facts pushes the last
/// three off the screen. Five is enough to read as a record rather than a
/// teaser.
const int unitAttributesPreview = 5;

/// The record an object keeps about itself — the facts its keeper wrote down.
///
/// Heading and list live together here rather than being composed in the hub,
/// because what the heading offers depends on the same answer the rows do:
/// whoever may add a fact is whoever may edit one.
///
/// The order is fixed here. Dragging lives on the record's own screen, where
/// the list is the screen rather than one section of a longer scroll.
class UnitAttributesSection extends ConsumerWidget {
  const UnitAttributesSection({required this.unitId, super.key});

  final String unitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unitId = this.unitId;
    final canEdit = ref.watch(isUnitKeeperProvider(unitId));

    // The actions are fired from callbacks and watched by nobody, so this
    // subscription is what keeps them alive long enough to answer — and what
    // carries a refusal from the database to the user.
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

    return Column(
      children: [
        DvSectionTitle(
          l10n.unitAttributes,
          action: canEdit ? (label: l10n.unitAddCta, onPressed: add) : null,
        ),
        _AttributesPreview(unitId: unitId, canEdit: canEdit),
      ],
    );
  }
}

class _AttributesPreview extends ConsumerWidget {
  const _AttributesPreview({required this.unitId, required this.canEdit});

  final String unitId;
  final bool canEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unitId = this.unitId;
    final canEdit = this.canEdit;

    return DvAsyncView<List<UnitAttribute>>(
      value: ref.watch(unitAttributesProvider(unitId)),
      skeleton: const DvTilesSkeleton(),
      onRetry: () => ref.invalidate(unitAttributesProvider(unitId)),
      builder: (context, attributes) {
        if (attributes.isEmpty) {
          return DvEmptyView(message: l10n.unitAttributesEmpty);
        }

        final total = attributes.length;

        return Column(
          children: [
            for (final attribute in attributes.take(unitAttributesPreview))
              UnitAttributeTile(
                unitId: unitId,
                attribute: attribute,
                canEdit: canEdit,
              ),
            // The count is the whole record, not what is left over: "show all
            // 6" says something, "1 more" only looks like an oversight.
            if (total > unitAttributesPreview)
              DvTextButton(
                label: l10n.unitAttributesShowAll(total),
                icon: AppIcons.expand,
                onPressed: () =>
                    context.push(AppRoutes.unitAttributesPath(unitId)),
              ),
          ],
        );
      },
    );
  }
}
