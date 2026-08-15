import 'package:dvir/app/icons.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Shared/presentation/dv_confirm_dialog.dart';
import 'package:dvir/features/Shared/presentation/dv_menu.dart';
import 'package:dvir/features/Shared/presentation/dv_tile.dart';
import 'package:dvir/features/Units/application/unit_attributes_controller.dart';
import 'package:dvir/features/Units/domain/models/unit_attribute.dart';
import 'package:dvir/features/Units/presentation/components/unit_attribute_sheet.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// One fact of an object's record, and whatever may be done to it.
///
/// Shared by the hub's five and by the screen that holds all of them, so the
/// two cannot drift into different rows for the same thing.
class UnitAttributeTile extends StatelessWidget {
  const UnitAttributeTile({
    required this.unitId,
    required this.attribute,
    required this.canEdit,
    super.key,
    this.dragIndex,
  });

  final String unitId;
  final UnitAttribute attribute;

  /// Whether the person looking keeps this object's record.
  final bool canEdit;

  /// The row's place in a reorderable list, or null where the order is fixed.
  ///
  /// The handle sits on the left, opposite the menu: a row that is both dragged
  /// and opened needs its two grips apart, or the drag starts on the button.
  final int? dragIndex;

  @override
  Widget build(BuildContext context) {
    final unitId = this.unitId;
    final attribute = this.attribute;
    final dragIndex = this.dragIndex;

    return DvTile(
      title: attribute.name,
      subtitle: attribute.value,
      dense: true,
      leading: dragIndex == null
          ? null
          : ReorderableDragStartListener(
              index: dragIndex,
              child: Icon(
                AppIcons.drag,
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
      trailing: canEdit
          ? _AttributeMenu(unitId: unitId, attribute: attribute)
          : null,
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
        icon: AppIcons.delete,
      );
      if (!confirmed) return;

      await actions.remove(attribute.id);
    }

    return DvMenu(
      tooltip: l10n.moreActions,
      items: [
        DvMenuItem(
          label: l10n.editAttribute,
          icon: AppIcons.edit,
          onSelected: edit,
        ),
        DvMenuItem(
          label: l10n.deleteAttribute,
          icon: AppIcons.delete,
          onSelected: remove,
          isDestructive: true,
        ),
      ],
    );
  }
}
