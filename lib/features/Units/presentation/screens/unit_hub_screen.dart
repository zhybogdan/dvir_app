import 'package:dvir/app/routes.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/async_value_x.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/core/notifications/toast_controller.dart';
import 'package:dvir/core/utils/share.dart';
import 'package:dvir/features/Auth/application/auth_controller.dart';
import 'package:dvir/features/Members/application/unit_members_controller.dart';
import 'package:dvir/features/Members/domain/member_permissions.dart';
import 'package:dvir/features/Members/domain/models/unit_member_view.dart';
import 'package:dvir/features/Shared/domain/types/member_status.dart';
import 'package:dvir/features/Shared/presentation/dv_app_bar.dart';
import 'package:dvir/features/Shared/presentation/dv_async_view.dart';
import 'package:dvir/features/Shared/presentation/dv_background.dart';
import 'package:dvir/features/Shared/presentation/dv_button.dart';
import 'package:dvir/features/Shared/presentation/dv_confirm_dialog.dart';
import 'package:dvir/features/Shared/presentation/dv_empty_view.dart';
import 'package:dvir/features/Shared/presentation/dv_icon_button.dart';
import 'package:dvir/features/Shared/presentation/dv_invite_code_card.dart';
import 'package:dvir/features/Shared/presentation/dv_scaffold.dart';
import 'package:dvir/features/Shared/presentation/dv_shimmer.dart';
import 'package:dvir/features/Shared/presentation/member_status_l10n.dart';
import 'package:dvir/features/Units/application/unit_actions_controller.dart';
import 'package:dvir/features/Units/application/unit_children_controller.dart';
import 'package:dvir/features/Units/application/unit_controller.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/features/Units/domain/types/unit_role.dart';
import 'package:dvir/features/Units/presentation/components/unit_role_chip.dart';
import 'package:dvir/features/Units/presentation/unit_role_l10n.dart';
import 'package:dvir/features/Units/presentation/unit_type_l10n.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Everything that belongs to one object, on one screen.
///
/// The object is a place you enter, not a row you read: its specs, the people
/// attached to it and the code that lets more of them in. Documents, meters and
/// expenses join this screen as their phases land — each of those tables hangs
/// off the same `unit_id`, so the hub grows by a section rather than by a
/// subsystem.
class UnitHubScreen extends ConsumerWidget {
  const UnitHubScreen({required this.unitId, super.key});

  final String unitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unitId = this.unitId;
    final unit = ref.watch(unitProvider(unitId));

    final isOwner =
        ref.watch(myUnitRoleProvider(unitId)).value == UnitRole.owner;

    final l10n = AppLocalizations.of(context);
    final loaded = unit.value;

    // Both controllers are driven from callbacks and watched by nobody, so
    // these subscriptions are what keeps them alive long enough to answer —
    // and what carries a refusal from the database to the user.
    ref
      ..listen(
        unitActionsProvider(unitId),
        (previous, next) => next.showFailure(context, ref),
      )
      ..listen(
        unitMemberModerationProvider(unitId),
        (previous, next) => next.showFailure(context, ref),
      );

    return DvScaffold(
      background: const DvAppGradient(),
      appBar: DvAppBar(
        title: loaded?.label ?? '',
        actions: [
          if (isOwner && loaded != null) ...[
            DvIconButton(
              onPressed: () => context.push(AppRoutes.unitEditPath(unitId)),
              icon: Icons.edit_outlined,
              tooltip: l10n.unitEditTitle,
            ),
            _UnitMenu(unit: loaded),
          ],
        ],
      ),
      body: DvAsyncView<Unit>(
        value: unit,
        skeleton: const _HubSkeleton(),
        onRetry: () => ref.invalidate(unitProvider(unitId)),
        builder: (context, unit) => _Hub(unit: unit),
      ),
    );
  }
}

class _Hub extends ConsumerWidget {
  const _Hub({required this.unit});

  final Unit unit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unit = this.unit;
    // Null while the roles load, and null again for a community admin who
    // manages the object without living in it — neither is an owner.
    final role = ref.watch(myUnitRoleProvider(unit.id)).value;

    return RefreshIndicator(
      onRefresh: () async {
        ref
          ..invalidate(unitProvider(unit.id))
          ..invalidate(unitMembersProvider(unit.id))
          ..invalidate(unitChildrenProvider(unit.id));
      },
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _Specs(unit: unit),
          if (role == UnitRole.owner) ...[
            const SizedBox(height: AppSpacing.lg),
            _InviteSection(unit: unit),
          ],
          const SizedBox(height: AppSpacing.lg),
          _SectionTitle(
            l10n.unitNested,
            action: role == UnitRole.owner
                ? (
                    label: l10n.unitAddCta,
                    onPressed: () =>
                        context.push(AppRoutes.unitAddPath(unit.id)),
                  )
                : null,
          ),
          _Children(unitId: unit.id),
          const SizedBox(height: AppSpacing.lg),
          _SectionTitle(l10n.unitPeople),
          _People(unitId: unit.id),
        ],
      ),
    );
  }
}

class _Specs extends StatelessWidget {
  const _Specs({required this.unit});

  final Unit unit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final unit = this.unit;
    final area = unit.areaM2;

    // Whatever the object actually carries: a flat has an area, a plot in a
    // village may have neither city nor number.
    final lines = <String>[
      unit.type.label(l10n),
      ?unit.address,
      ?unit.city,
      if (area != null) l10n.unitAreaValue(_area(area)),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.xs,
        children: [
          Text(unit.label, style: context.textTheme.titleLarge),
          for (final line in lines)
            Text(
              line,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }

  /// Areas are whole numbers far more often than not, and "102 м²" reads
  /// better on a card than "102.0 м²".
  String _area(double value) =>
      value == value.roundToDouble() ? '${value.round()}' : '$value';
}

/// The code, and the two ways an owner passes it on.
class _InviteSection extends ConsumerWidget {
  const _InviteSection({required this.unit});

  final Unit unit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unit = this.unit;

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
              TextButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code));
                  ref
                      .read(toastControllerProvider.notifier)
                      .success(l10n.codeCopied);
                },
                icon: const Icon(Icons.copy_outlined),
                label: Text(l10n.copyCode),
              ),
              TextButton.icon(
                onPressed: () => _rotate(context, ref, l10n),
                icon: const Icon(Icons.autorenew_rounded),
                label: Text(l10n.rotateCode),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Asked before rotating, because the old code is in someone's chat by now
  /// and this is what stops working for them.
  Future<void> _rotate(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final confirmed = await DvConfirmDialog.ask(
      context,
      title: l10n.rotateCodeTitle,
      message: l10n.rotateCodeBody,
      confirmLabel: l10n.rotateCode,
    );
    if (!confirmed) return;

    final rotated = await ref
        .read(unitActionsProvider(unit.id).notifier)
        .rotateInviteCode();

    // Null means the call failed, and the screen's listener has already said
    // so. `context.mounted` covers the other way out: leaving mid-request.
    if (rotated == null || !context.mounted) return;

    ref.read(toastControllerProvider.notifier).success(l10n.codeRotated);
  }
}

class _People extends ConsumerWidget {
  const _People({required this.unitId});

  final String unitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unitId = this.unitId;

    return DvAsyncView<List<UnitMemberView>>(
      value: ref.watch(unitMembersProvider(unitId)),
      skeleton: const _PeopleSkeleton(),
      onRetry: () => ref.invalidate(unitMembersProvider(unitId)),
      builder: (context, people) => people.isEmpty
          ? DvEmptyView(message: l10n.unitPeopleEmpty)
          : Column(
              children: [
                // Numbered by position, so two people who have not filled in a
                // profile yet are still told apart on screen.
                for (final (index, view) in people.indexed)
                  _PersonRow(
                    unitId: unitId,
                    view: view,
                    all: people,
                    position: index + 1,
                  ),
              ],
            ),
    );
  }
}

class _PersonRow extends ConsumerWidget {
  const _PersonRow({
    required this.unitId,
    required this.view,
    required this.all,
    required this.position,
  });

  final String unitId;
  final UnitMemberView view;

  /// The whole list, because whether this row may be touched depends on the
  /// others — the last owner cannot hand their role away.
  final List<UnitMemberView> all;

  /// Where this person sits in the household, and the only thing left to call
  /// them by until they enter a name.
  final int position;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unitId = this.unitId;
    final view = this.view;
    final membership = view.membership;
    final name = view.profile?.fullName;

    // A profile arrives empty until the person fills it in, and a whole profile
    // stays hidden from anyone not entitled to read it — both end up here.
    final title = name == null || name.isEmpty
        ? l10n.unnamedMemberNumbered(position)
        : name;

    final myUserId = ref.watch(authStateProvider).value?.id;
    final isOwner =
        ref.watch(myUnitRoleProvider(unitId)).value == UnitRole.owner;
    final actions = myUserId == null
        ? null
        : unitMemberActions(
            member: membership,
            all: all.map((view) => view.membership),
            myUserId: myUserId,
          );

    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: context.textTheme.titleSmall),
                    const SizedBox(height: AppSpacing.xs),
                    UnitRoleChip(role: membership.role),
                  ],
                ),
              ),
              if (!view.isActive)
                Text(
                  membership.status.label(l10n),
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                )
              else if (isOwner && actions != null)
                _MemberMenu(
                  unitId: unitId,
                  view: view,
                  name: title,
                  actions: actions,
                ),
            ],
          ),
          // A request is decided in one tap either way, so its two answers sit
          // in the open rather than behind a menu.
          if (isOwner &&
              actions != null &&
              actions.canChangeStatus &&
              membership.status == MemberStatus.pending)
            _RequestActions(unitId: unitId, view: view, name: title),
        ],
      ),
    );
  }
}

/// What can be done to the object itself, rather than to its contents.
class _UnitMenu extends ConsumerWidget {
  const _UnitMenu({required this.unit});

  final Unit unit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unit = this.unit;

    Future<void> delete() async {
      final confirmed = await DvConfirmDialog.ask(
        context,
        title: l10n.deleteUnitTitle(unit.label),
        message: l10n.deleteUnitBody,
        confirmLabel: l10n.deleteUnit,
      );
      if (!confirmed || !context.mounted) return;

      final parentId = unit.parentId;
      final deleted = await ref
          .read(unitActionsProvider(unit.id).notifier)
          .delete(parentId: parentId);

      if (!deleted || !context.mounted) return;

      // Back to whatever contained it, which for a top-level object is the
      // home list. Staying put would leave the screen reading a row that is
      // gone.
      context.go(
        parentId == null ? AppRoutes.home : AppRoutes.unitPath(parentId),
      );
    }

    return PopupMenuButton<VoidCallback>(
      onSelected: (action) => action(),
      itemBuilder: (context) => [
        PopupMenuItem(value: delete, child: Text(l10n.deleteUnit)),
      ],
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

/// A section heading, optionally with the one control that acts on the section.
typedef _SectionAction = ({String label, VoidCallback onPressed});

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text, {this.action});

  final String text;
  final _SectionAction? action;

  @override
  Widget build(BuildContext context) {
    final action = this.action;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text.toUpperCase(),
          style: context.textTheme.labelSmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
            letterSpacing: 1,
          ),
        ),
        if (action != null)
          TextButton.icon(
            onPressed: action.onPressed,
            icon: const Icon(Icons.add, size: AppSpacing.md),
            label: Text(action.label),
          ),
      ],
    );
  }
}

class _Children extends ConsumerWidget {
  const _Children({required this.unitId});

  final String unitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unitId = this.unitId;

    return DvAsyncView<List<Unit>>(
      value: ref.watch(unitChildrenProvider(unitId)),
      skeleton: const _PeopleSkeleton(),
      onRetry: () => ref.invalidate(unitChildrenProvider(unitId)),
      builder: (context, children) => children.isEmpty
          ? DvEmptyView(message: l10n.unitNestedEmpty)
          : Column(
              children: [for (final child in children) _ChildRow(unit: child)],
            ),
    );
  }
}

class _ChildRow extends StatelessWidget {
  const _ChildRow({required this.unit});

  final Unit unit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final unit = this.unit;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Material(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          onTap: () => context.push(AppRoutes.unitPath(unit.id)),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(unit.label, style: context.textTheme.titleSmall),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        unit.type.label(l10n),
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HubSkeleton extends StatelessWidget {
  const _HubSkeleton();

  @override
  Widget build(BuildContext context) {
    return const DvShimmer(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.md,
          children: [
            DvSkeletonBox(height: 120, radius: AppRadius.lg),
            DvSkeletonBox(height: 76, radius: AppRadius.lg),
          ],
        ),
      ),
    );
  }
}

class _PeopleSkeleton extends StatelessWidget {
  const _PeopleSkeleton();

  @override
  Widget build(BuildContext context) {
    return const DvShimmer(
      child: Column(
        spacing: AppSpacing.sm,
        children: [
          DvSkeletonBox(height: 68, radius: AppRadius.lg),
          DvSkeletonBox(height: 68, radius: AppRadius.lg),
        ],
      ),
    );
  }
}
