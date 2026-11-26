import 'package:dvir/core/extensions/date_time_x.dart';
import 'package:dvir/core/notifications/toast_controller.dart';
import 'package:dvir/features/Backup/application/backup_controller.dart';
import 'package:dvir/features/Shared/presentation/dv_confirm_dialog.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Picking an archive, reading what is in it, and putting it back — the three
/// steps behind one "Restore".
///
/// Lives apart from both places that offer it: the settings section, and the
/// list of objects before there is a first one. Somebody holding a new phone
/// has nothing to create and a copy to put back, so the invitation on an empty
/// app has to reach the same flow the settings screen does.
///
/// The dialog between the second and third step is the point of the whole
/// thing: it names the copy's date and what it holds, because restoring
/// replaces everything and the person has to be able to tell one copy from
/// another.
abstract final class BackupRestoreFlow {
  /// Returns true once the records have actually been replaced, so a caller
  /// that spins a button knows when to stop.
  static Future<bool> start(BuildContext context, WidgetRef ref) async {
    // Read before the first await: after the picker, the ref may no longer be
    // the one this was started from.
    final actions = ref.read(backupActionsProvider.notifier);
    final toasts = ref.read(toastControllerProvider.notifier);
    final l10n = AppLocalizations.of(context);

    final file = await actions.pick();

    // Null is backing out of the picker, which is not a refusal to report.
    if (file == null) return false;

    final manifest = await actions.read(file);
    if (manifest == null || !context.mounted) return false;

    final confirmed = await DvConfirmDialog.ask(
      context,
      title: l10n.backupRestoreConfirmTitle,
      message: l10n.backupRestoreConfirmBody(
        manifest.createdAt.asShortDate,
        manifest.units,
        manifest.documents,
        manifest.contacts,
      ),
      confirmLabel: l10n.backupRestoreConfirmCta,
    );

    if (!confirmed) return false;

    final restored = await actions.restore(file);
    if (!restored) return false;

    toasts.success(l10n.backupRestored);

    return true;
  }
}
