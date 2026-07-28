import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/core/notifications/toast_controller.dart';
import 'package:dvir/core/utils/share.dart';
import 'package:dvir/features/Members/application/unit_members_controller.dart';
import 'package:dvir/features/Shared/presentation/dv_async_view.dart';
import 'package:dvir/features/Shared/presentation/dv_button.dart';
import 'package:dvir/features/Shared/presentation/dv_confirm_dialog.dart';
import 'package:dvir/features/Shared/presentation/dv_invite_code_card.dart';
import 'package:dvir/features/Shared/presentation/dv_shimmer.dart';
import 'package:dvir/features/Shared/presentation/dv_text_button.dart';
import 'package:dvir/features/Units/application/unit_actions_controller.dart';
import 'package:dvir/features/Units/application/unit_controller.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The code, and the two ways an owner passes it on.
///
/// Folded away while the object holds nobody but its owner. Every object is a
/// full scope, code included — a garage can be let out, and its tenant must
/// reach the garage and not the house around it — but a room usually never
/// leaves the family, and a large code sitting on its screen is what made a
/// nested object read as a second house. One second person is enough to open it
/// again: by then the code is something the owner has actually used.
class UnitInviteSection extends ConsumerStatefulWidget {
  const UnitInviteSection({required this.unit, super.key});

  final Unit unit;

  @override
  ConsumerState<UnitInviteSection> createState() => _UnitInviteSectionState();
}

class _UnitInviteSectionState extends ConsumerState<UnitInviteSection> {
  bool _opened = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final unit = widget.unit;
    final people = ref.watch(unitMembersProvider(unit.id)).value;

    // Unknown while the list loads, and that counts as "not alone": the code is
    // the thing to keep out of sight, so it stays out until we know.
    final alone = people == null || people.length <= 1;

    if (alone && !_opened) {
      return Align(
        child: DvTextButton(
          label: l10n.giveAccess,
          icon: Icons.person_add_alt_outlined,
          onPressed: () => setState(() => _opened = true),
        ),
      );
    }

    return DvAsyncView<String>(
      value: ref.watch(unitInviteCodeProvider(unit.id)),
      skeleton: const DvShimmer(
        child: DvSkeletonBox(height: 96, radius: AppRadius.lg),
      ),
      onRetry: () => ref.invalidate(unitInviteCodeProvider(unit.id)),
      builder: (context, code) => Column(
        children: [
          DvInviteCodeCard(code: code),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.unitInviteCodeHint,
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          DvButton(
            label: l10n.shareCode,
            icon: Icons.ios_share,
            onPressed: () => shareText(l10n.shareInviteText(unit.label, code)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DvTextButton(
                label: l10n.copyCode,
                icon: Icons.copy_outlined,
                onPressed: () => _copy(code, l10n),
              ),
              DvTextButton(
                label: l10n.rotateCode,
                icon: Icons.autorenew_rounded,
                onPressed: () => _rotate(l10n),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _copy(String code, AppLocalizations l10n) {
    Clipboard.setData(ClipboardData(text: code));
    ref.read(toastControllerProvider.notifier).success(l10n.codeCopied);
  }

  /// Asked before rotating, because the old code is in someone's chat by now
  /// and this is what stops working for them.
  Future<void> _rotate(AppLocalizations l10n) async {
    // Both held before the dialog: past an await the ref may no longer be the
    // one this section was built with, and reading it then throws.
    final unitActions = ref.read(unitActionsProvider(widget.unit.id).notifier);
    final toasts = ref.read(toastControllerProvider.notifier);

    final confirmed = await DvConfirmDialog.ask(
      context,
      title: l10n.rotateCodeTitle,
      message: l10n.rotateCodeBody,
      confirmLabel: l10n.rotateCode,
    );
    if (!confirmed) return;

    final rotated = await unitActions.rotateInviteCode();

    // Null means the call failed, and the screen's listener has already said
    // so. `mounted` covers the other way out: leaving mid-request, where a
    // toast would announce a screen the user has left.
    if (rotated == null || !mounted) return;

    toasts.success(l10n.codeRotated);
  }
}
