import 'package:dvir/app/icons.dart';
import 'package:dvir/app/routes.dart';
import 'package:dvir/features/Shared/presentation/dv_confirm_dialog.dart';
import 'package:dvir/features/Shared/presentation/dv_menu.dart';
import 'package:dvir/features/Units/application/unit_actions_controller.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// What can be done to the object itself, rather than to its contents.
class UnitMenu extends ConsumerWidget {
  const UnitMenu({required this.unit, super.key});

  final Unit unit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unit = this.unit;

    // Held before the dialog: after an await the ref may no longer be the one
    // this menu was built with.
    final unitActions = ref.read(unitActionsProvider(unit.id).notifier);

    Future<void> delete() async {
      final confirmed = await DvConfirmDialog.ask(
        context,
        title: l10n.deleteUnitTitle(unit.label),
        message: l10n.deleteUnitBody,
        confirmLabel: l10n.deleteUnit,
        icon: AppIcons.delete,
      );
      if (!confirmed || !context.mounted) return;

      final parentId = unit.parentId;
      final deleted = await unitActions.delete(parentId: parentId);

      if (!deleted || !context.mounted) return;

      // Back to whatever contained it, which for a top-level object is the
      // home list. Staying put would leave the screen reading a row that is
      // gone.
      context.go(
        parentId == null ? AppRoutes.home : AppRoutes.unitPath(parentId),
      );
    }

    return DvMenu(
      tooltip: l10n.moreActions,
      items: [
        DvMenuItem(
          label: l10n.deleteUnit,
          icon: AppIcons.delete,
          onSelected: delete,
          isDestructive: true,
        ),
      ],
    );
  }
}
