import 'dart:io';

import 'package:dvir/app/icons.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/async_value_x.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/core/extensions/date_time_x.dart';
import 'package:dvir/core/notifications/toast_controller.dart';
import 'package:dvir/features/Backup/application/backup_controller.dart';
import 'package:dvir/features/Shared/presentation/dv_button.dart';
import 'package:dvir/features/Shared/presentation/dv_confirm_dialog.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Making a copy of the phone and putting one back, which is what the settings
/// screen of a build with no account is mostly for.
///
/// Two buttons rather than two rows: these are actions and not places to go,
/// and a button already carries its own waiting state — a copy of a full phone
/// takes long enough to need one.
class BackupSection extends ConsumerStatefulWidget {
  const BackupSection({super.key});

  @override
  ConsumerState<BackupSection> createState() => _BackupSectionState();
}

/// Which of the two is running, which the shared controller state cannot say.
/// Without it a copy being written would spin both buttons at once.
enum _Running { share, restore }

class _BackupSectionState extends ConsumerState<BackupSection> {
  _Running? _running;

  Future<void> _share() async {
    setState(() => _running = _Running.share);

    // Nothing to announce on success: the share sheet opening *is* the result,
    // and a toast behind it would claim the copy was put somewhere while the
    // person is still choosing where. A failure is said by the listener.
    await ref.read(backupActionsProvider.notifier).share();

    if (mounted) setState(() => _running = null);
  }

  Future<void> _restore() async {
    final actions = ref.read(backupActionsProvider.notifier);
    final file = await actions.pick();

    // Null is backing out of the picker, which is not a refusal to report.
    if (file == null || !mounted) return;

    setState(() => _running = _Running.restore);

    final manifest = await actions.read(file);
    if (!mounted) return;

    if (manifest == null) {
      setState(() => _running = null);

      return;
    }

    final l10n = AppLocalizations.of(context);
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

    if (!confirmed || !mounted) {
      if (mounted) setState(() => _running = null);

      return;
    }

    await _replace(file);
  }

  Future<void> _replace(File file) async {
    final l10n = AppLocalizations.of(context);
    final restored = await ref
        .read(backupActionsProvider.notifier)
        .restore(file);

    if (!mounted) return;

    setState(() => _running = null);
    if (!restored) return;

    ref.read(toastControllerProvider.notifier).success(l10n.backupRestored);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final busy = ref.watch(backupActionsProvider).isLoading;
    final running = _running;

    ref.listen(
      backupActionsProvider,
      (previous, next) => next.showFailure(context, ref),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.sm,
      children: [
        DvButton(
          label: l10n.backupCreate,
          icon: AppIcons.share,
          isLoading: running == _Running.share,
          onPressed: busy ? null : _share,
        ),
        _Hint(l10n.backupCreateHint),
        const SizedBox(height: AppSpacing.sm),
        DvButton.tonal(
          label: l10n.backupRestore,
          icon: AppIcons.refresh,
          isLoading: running == _Running.restore,
          onPressed: busy ? null : _restore,
        ),
        _Hint(l10n.backupRestoreHint),
      ],
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
    child: Text(
      text,
      style: context.textTheme.bodySmall?.copyWith(
        color: context.colorScheme.onSurfaceVariant,
      ),
    ),
  );
}
