import 'package:dvir/app/icons.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Shared/presentation/dv_confirm_dialog.dart';
import 'package:dvir/features/Shared/presentation/dv_divider.dart';
import 'package:dvir/features/Shared/presentation/dv_menu.dart';
import 'package:dvir/features/Units/application/unit_attributes_controller.dart';
import 'package:dvir/features/Units/domain/models/unit_attribute.dart';
import 'package:dvir/features/Units/presentation/components/unit_attribute_sheet.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// One fact of the record's own screen: its name small above, its value
/// large below, and whatever may be done to it.
///
/// Name over value rather than the hub's pair across one line: here the row
/// also carries a handle and a menu, and a pair squeezed between them leaves
/// the value a third of the width to wrap in. No card — the list is the
/// screen, and a hairline between rows says where one fact ends.
class UnitAttributeTile extends StatelessWidget {
  const UnitAttributeTile({
    required this.unitId,
    required this.attribute,
    required this.canEdit,
    super.key,
    this.dragIndex,
    this.divided = false,
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

  /// Whether a hairline is drawn above the row — every row but the first, and
  /// never the one being held, which is lifted off the list as a card.
  final bool divided;

  @override
  Widget build(BuildContext context) {
    final unitId = this.unitId;
    final attribute = this.attribute;
    final dragIndex = this.dragIndex;
    final scheme = context.colorScheme;
    final styles = context.textTheme;

    return Column(
      children: [
        if (divided) const DvDivider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Row(
            spacing: AppSpacing.md,
            children: [
              if (dragIndex != null)
                ReorderableDragStartListener(
                  index: dragIndex,
                  child: Icon(AppIcons.drag, color: scheme.onSurfaceVariant),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.xs,
                  children: [
                    Text(
                      attribute.name,
                      style: styles.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    // Free text, and it wraps: "газовий котел Vaillant,
                    // заміна 2021" is a value worth reading to the end.
                    Text(attribute.value, style: styles.titleMedium),
                  ],
                ),
              ),
              if (canEdit) _AttributeMenu(unitId: unitId, attribute: attribute),
            ],
          ),
        ),
      ],
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
