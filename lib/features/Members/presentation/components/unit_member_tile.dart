import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Members/application/unit_members_controller.dart';
import 'package:dvir/features/Members/domain/member_permissions.dart';
import 'package:dvir/features/Members/domain/models/unit_member_view.dart';
import 'package:dvir/features/Shared/domain/types/member_status.dart';
import 'package:dvir/features/Shared/presentation/dv_confirm_dialog.dart';
import 'package:dvir/features/Shared/presentation/dv_tile.dart';
import 'package:dvir/features/Shared/presentation/member_status_l10n.dart';
import 'package:dvir/features/Units/domain/types/unit_role.dart';
import 'package:dvir/features/Units/presentation/components/unit_role_chip.dart';
import 'package:dvir/features/Units/presentation/unit_role_l10n.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// One person in a household, and whatever may be done about them.
///
/// [isOwner] and [myUserId] are passed in rather than read here, so what the
/// tile offers follows from its inputs alone. The rules it applies are already
/// tested as functions; this way what the tile *asks* them can be tested too,
/// without standing a whole screen up first.
class UnitMemberTile extends StatelessWidget {
  const UnitMemberTile({
    required this.unitId,
    required this.view,
    required this.all,
    required this.position,
    required this.isOwner,
    required this.myUserId,
    super.key,
  });

  final String unitId;
  final UnitMemberView view;

  /// The whole list, because whether this row may be touched depends on the
  /// others — the last owner cannot hand their role away.
  final List<UnitMemberView> all;

  /// Where this person sits in the household, and the only thing left to call
  /// them by until they enter a name.
  final int position;

  /// Whether the person looking runs this object.
  final bool isOwner;

  /// Null while the session is still resolving, which offers nothing.
  final String? myUserId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final view = this.view;
    final membership = view.membership;
    final myUserId = this.myUserId;
    final name = view.profile?.fullName;

    // A profile arrives empty until the person fills it in, and a whole profile
    // stays hidden from anyone not entitled to read it — both end up here.
    final title = name == null || name.isEmpty
        ? l10n.unnamedMemberNumbered(position)
        : name;

    final actions = !isOwner || myUserId == null
        ? null
        : unitMemberActions(
            member: membership,
            all: all.map((view) => view.membership),
            myUserId: myUserId,
          );

    final isPending = membership.status == MemberStatus.pending;

    return DvTile(
      title: title,
      badge: UnitRoleChip(role: membership.role),
      dense: true,
      trailing: view.isActive
          ? (actions == null
                ? null
                : _MemberMenu(
                    unitId: unitId,
                    view: view,
                    name: title,
                    actions: actions,
                  ))
          : Text(
              membership.status.label(l10n),
              style: context.textTheme.labelSmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
      // A request is decided in one tap either way, so its two answers sit in
      // the open rather than behind a menu.
      footer: actions != null && actions.canChangeStatus && isPending
          ? _RequestActions(unitId: unitId, view: view, name: title)
          : null,
    );
  }
}

/// The two answers to a join request, side by side.
class _RequestActions extends ConsumerWidget {
  const _RequestActions({
    required this.unitId,
    required this.view,
    required this.name,
  });

  final String unitId;
  final UnitMemberView view;
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unitId = this.unitId;
    final memberId = view.membership.id;
    final name = this.name;

    Future<void> approve() => ref
        .read(unitMemberModerationProvider(unitId).notifier)
        .setStatus(memberId, MemberStatus.active);

    Future<void> reject() async {
      final confirmed = await DvConfirmDialog.ask(
        context,
        title: l10n.rejectTitle,
        message: l10n.rejectBody(name),
        confirmLabel: l10n.reject,
      );
      if (!confirmed) return;

      await ref
          .read(unitMemberModerationProvider(unitId).notifier)
          .setStatus(memberId, MemberStatus.rejected);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(onPressed: reject, child: Text(l10n.reject)),
        TextButton(onPressed: approve, child: Text(l10n.approve)),
      ],
    );
  }
}

/// Everything that can be done to someone already living here.
class _MemberMenu extends ConsumerWidget {
  const _MemberMenu({
    required this.unitId,
    required this.view,
    required this.name,
    required this.actions,
  });

  final String unitId;
  final UnitMemberView view;
  final String name;
  final MemberActions actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unitId = this.unitId;
    final memberId = view.membership.id;
    final name = this.name;
    final actions = this.actions;

    Future<void> changeRole() async {
      final role = await _pickRole(context, view.membership.role);
      if (role == null) return;

      await ref
          .read(unitMemberModerationProvider(unitId).notifier)
          .setRole(memberId, role);
    }

    Future<void> remove() async {
      final confirmed = await DvConfirmDialog.ask(
        context,
        title: l10n.removeMemberTitle,
        message: l10n.removeMemberBody(name),
        confirmLabel: l10n.removeMember,
      );
      if (!confirmed) return;

      await ref
          .read(unitMemberModerationProvider(unitId).notifier)
          .remove(memberId);
    }

    // Nothing left to offer: the last owner may neither step down nor remove
    // themselves, and a menu of two disabled items is worse than no menu.
    if (!actions.canChangeRole && !actions.canChangeStatus) {
      return const SizedBox.shrink();
    }

    return PopupMenuButton<VoidCallback>(
      onSelected: (action) => action(),
      itemBuilder: (context) => [
        if (actions.canChangeRole)
          PopupMenuItem(value: changeRole, child: Text(l10n.changeRole)),
        if (actions.canChangeStatus)
          PopupMenuItem(value: remove, child: Text(l10n.removeMember)),
      ],
    );
  }

  /// The role sheet, returning null when dismissed without a choice.
  Future<UnitRole?> _pickRole(BuildContext context, UnitRole current) {
    final l10n = AppLocalizations.of(context);

    return showModalBottomSheet<UnitRole>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                l10n.roleSheetTitle,
                style: context.textTheme.titleMedium,
              ),
            ),
            for (final role in UnitRole.values)
              ListTile(
                title: Text(role.label(l10n)),
                trailing: role == current ? const Icon(Icons.check) : null,
                onTap: () => Navigator.of(context).pop(role),
              ),
          ],
        ),
      ),
    );
  }
}
