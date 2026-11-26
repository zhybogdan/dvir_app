import 'package:dvir/app/icons.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/async_value_x.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Backup/application/backup_controller.dart';
import 'package:dvir/features/Backup/domain/models/device_contents.dart';
import 'package:dvir/features/Backup/presentation/backup_restore_flow.dart';
import 'package:dvir/features/Shared/presentation/dv_button.dart';
import 'package:dvir/features/Shared/presentation/dv_text_button.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

/// Making a copy of the phone and putting one back, which is what the settings
/// screen of a build with no account is mostly for.
///
/// It opens by saying where the data is and how much of it there is: in a
/// build with no account that is the one fact a person cannot see anywhere
/// else, and it is what makes the button under it worth pressing.
///
/// Making a copy is the screen's one primary action. Restoring is a quiet
/// button under it rather than a second one of the same weight: it replaces
/// everything, it is done once in a phone's life, and the dialog it opens is
/// already red.
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

  /// The steps are in [BackupRestoreFlow], which the empty list of objects
  /// offers as well; what stays here is the spinner, because only this screen
  /// has a button to spin.
  Future<void> _restore() async {
    setState(() => _running = _Running.restore);

    await BackupRestoreFlow.start(context, ref);

    if (mounted) setState(() => _running = null);
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
        const _Contents(),
        const SizedBox(height: AppSpacing.sm),
        DvButton(
          label: l10n.backupCreate,
          icon: AppIcons.share,
          isLoading: running == _Running.share,
          onPressed: busy ? null : _share,
        ),
        _Hint(l10n.backupCreateHint),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DvTextButton(
              label: l10n.backupRestore,
              icon: AppIcons.refresh,
              isLoading: running == _Running.restore,
              padding: EdgeInsets.zero,
              onPressed: busy ? null : _restore,
            ),
            // Drawn up into the bottom of the button's tap target, which is
            // 14 taller than the label on each side: left where it falls, the
            // hint reads as the start of something new rather than as the
            // button's own line. The target keeps its 48: the hint lets taps
            // through to it where the two overlap.
            Transform.translate(
              offset: const Offset(0, -_tapTargetOverhang),
              child: IgnorePointer(child: _Hint(l10n.backupRestoreHint)),
            ),
          ],
        ),
      ],
    );
  }
}

/// «Усе лежить на цьому телефоні» and, once there is something, how much.
///
/// The weight line waits for the first object rather than printing three
/// zeros: on a new install it would be a measurement of nothing.
class _Contents extends ConsumerWidget {
  const _Contents();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final contents = ref.watch(deviceContentsProvider).value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.xs,
      children: [
        Text(
          l10n.settingsStoredHere,
          style: context.textTheme.bodyLarge?.copyWith(
            color: context.colorScheme.onSurface,
          ),
        ),
        if (contents != null && contents.units > 0)
          Text(
            [
              l10n.settingsUnitsCount(contents.units),
              l10n.scopePapers(contents.documents),
              _size(contents, l10n),
            ].join(' · '),
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }

  /// Whole megabytes past ten and one decimal under it, the precision a
  /// person reads a size at. Under a megabyte, kilobytes, so that a phone
  /// holding only records does not read «0 МБ».
  String _size(DeviceContents contents, AppLocalizations l10n) {
    const kilobyte = 1024;
    const megabyte = kilobyte * 1024;
    final bytes = contents.bytes;

    if (bytes < megabyte) {
      return l10n.settingsSizeKilobytes('${(bytes / kilobyte).ceil()}');
    }

    final megabytes = bytes / megabyte;
    final format = NumberFormat.decimalPattern(l10n.localeName)
      ..maximumFractionDigits = megabytes < 10 ? 1 : 0;

    return l10n.settingsSizeMegabytes(format.format(megabytes));
  }
}

/// How far the quiet button's tap target reaches past its label, less the
/// gap a label keeps to the line under it.
const double _tapTargetOverhang = 14 - AppSpacing.xs;

class _Hint extends StatelessWidget {
  const _Hint(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: context.textTheme.bodySmall?.copyWith(
      color: context.colorScheme.onSurfaceVariant,
    ),
  );
}
