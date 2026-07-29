import 'package:dvir/core/extensions/async_value_x.dart';
import 'package:dvir/features/Members/application/unit_members_controller.dart';
import 'package:dvir/features/Shared/presentation/dv_async_view.dart';
import 'package:dvir/features/Shared/presentation/dv_confirm_dialog.dart';
import 'package:dvir/features/Shared/presentation/dv_empty_view.dart';
import 'package:dvir/features/Shared/presentation/dv_menu.dart';
import 'package:dvir/features/Shared/presentation/dv_tile.dart';
import 'package:dvir/features/Units/application/unit_attributes_controller.dart';
import 'package:dvir/features/Units/domain/models/unit_attribute.dart';
import 'package:dvir/features/Units/presentation/components/unit_attribute_sheet.dart';
import 'package:dvir/features/Units/presentation/components/unit_section_title.dart';
import 'package:dvir/features/Units/presentation/components/unit_tiles_skeleton.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The record an object keeps about itself — the facts its keeper wrote down.
///
/// Heading and list live together here rather than being composed in the hub,
/// because what the heading offers depends on the same answer the rows do:
/// whoever may add a fact is whoever may edit one.
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
        UnitSectionTitle(
          l10n.unitAttributes,
          action: canEdit ? (label: l10n.unitAddCta, onPressed: add) : null,
        ),
        _AttributesList(unitId: unitId, canEdit: canEdit),
      ],
    );
  }
}

class _AttributesList extends ConsumerWidget {
  const _AttributesList({required this.unitId, required this.canEdit});

  final String unitId;
  final bool canEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unitId = this.unitId;
    final canEdit = this.canEdit;

    return DvAsyncView<List<UnitAttribute>>(
      value: ref.watch(unitAttributesProvider(unitId)),
      skeleton: const UnitTilesSkeleton(),
      onRetry: () => ref.invalidate(unitAttributesProvider(unitId)),
      builder: (context, attributes) => attributes.isEmpty
          ? DvEmptyView(message: l10n.unitAttributesEmpty)
          : Column(
              children: [
                for (final attribute in attributes)
                  DvTile(
                    title: attribute.name,
                    subtitle: attribute.value,
                    dense: true,
                    trailing: canEdit
                        ? _AttributeMenu(unitId: unitId, attribute: attribute)
                        : null,
                  ),
              ],
            ),
    );
  }
}

/// Rewording one fact, or dropping it.
class _AttributeMenu extends ConsumerWidget {
  const _AttributeMenu({required this.unitId, required this.attribute});

  final String unitId;
  final UnitAttribute attribute;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final attribute = this.attribute;

    // Held before the sheet and the dialog: after an await the ref may no
    // longer be the one this row was built with.
    final actions = ref.read(unitAttributeActionsProvider(unitId).notifier);

    Future<void> edit() async {
      final draft = await UnitAttributeSheet.open(
        context,
        attribute: attribute,
      );
      if (draft == null) return;

      await actions.edit(
        attribute.copyWith(name: draft.name, value: draft.value),
      );
    }

    Future<void> remove() async {
      final confirmed = await DvConfirmDialog.ask(
        context,
        title: l10n.deleteAttributeTitle,
        message: l10n.deleteAttributeBody(attribute.name),
        confirmLabel: l10n.deleteAttribute,
        icon: Icons.delete_outline_rounded,
      );
      if (!confirmed) return;

      await actions.remove(attribute.id);
    }

    return DvMenu(
      tooltip: l10n.moreActions,
      items: [
        DvMenuItem(
          label: l10n.editAttribute,
          icon: Icons.edit_outlined,
          onSelected: edit,
        ),
        DvMenuItem(
          label: l10n.deleteAttribute,
          icon: Icons.delete_outline_rounded,
          onSelected: remove,
          isDestructive: true,
        ),
      ],
    );
  }
}
