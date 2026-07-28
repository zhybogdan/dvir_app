import 'package:dvir/app/routes.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/async_value_x.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/core/notifications/toast_controller.dart';
import 'package:dvir/core/utils/share.dart';
import 'package:dvir/features/Auth/application/auth_controller.dart';
import 'package:dvir/features/Members/application/unit_members_controller.dart';
import 'package:dvir/features/Members/domain/models/unit_member_view.dart';
import 'package:dvir/features/Members/presentation/components/unit_member_tile.dart';
import 'package:dvir/features/Shared/presentation/dv_app_bar.dart';
import 'package:dvir/features/Shared/presentation/dv_async_view.dart';
import 'package:dvir/features/Shared/presentation/dv_background.dart';
import 'package:dvir/features/Shared/presentation/dv_button.dart';
import 'package:dvir/features/Shared/presentation/dv_confirm_dialog.dart';
import 'package:dvir/features/Shared/presentation/dv_empty_view.dart';
import 'package:dvir/features/Shared/presentation/dv_icon_button.dart';
import 'package:dvir/features/Shared/presentation/dv_invite_code_card.dart';
import 'package:dvir/features/Shared/presentation/dv_menu.dart';
import 'package:dvir/features/Shared/presentation/dv_scaffold.dart';
import 'package:dvir/features/Shared/presentation/dv_shimmer.dart';
import 'package:dvir/features/Shared/presentation/dv_tile.dart';
import 'package:dvir/features/Units/application/unit_actions_controller.dart';
import 'package:dvir/features/Units/application/unit_children_controller.dart';
import 'package:dvir/features/Units/application/unit_controller.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/features/Units/domain/types/unit_role.dart';
import 'package:dvir/features/Units/domain/unit_nesting.dart';
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
            // A room holds nothing, so it is not offered the button — the
            // picker behind it would have no types to show.
            action: role == UnitRole.owner && canHoldChildren(unit.type)
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
    //
    // An address is only shown on a top-level object. A room or a garage stands
    // at the address of the house around it, and repeating it here would state
    // the parent's fact as the child's own.
    final isNested = unit.parentId != null;
    final lines = <String>[
      unit.type.label(l10n),
      if (!isNested) ...[?unit.address, ?unit.city],
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
///
/// Folded away while the object holds nobody but its owner. Every object is a
/// full scope, code included — a garage can be let out, and its tenant must
/// reach the garage and not the house around it — but a room usually never
/// leaves the family, and a large code sitting on its screen is what made a
/// nested object read as a second house. One second person is enough to open it
/// again: by then the code is something the owner has actually used.
class _InviteSection extends ConsumerStatefulWidget {
  const _InviteSection({required this.unit});

  final Unit unit;

  @override
  ConsumerState<_InviteSection> createState() => _InviteSectionState();
}

class _InviteSectionState extends ConsumerState<_InviteSection> {
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
        child: TextButton.icon(
          onPressed: () => setState(() => _opened = true),
          icon: const Icon(Icons.person_add_alt_outlined),
          label: Text(l10n.giveAccess),
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
                onPressed: () => _rotate(l10n),
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
  Future<void> _rotate(AppLocalizations l10n) async {
    final confirmed = await DvConfirmDialog.ask(
      context,
      title: l10n.rotateCodeTitle,
      message: l10n.rotateCodeBody,
      confirmLabel: l10n.rotateCode,
    );
    if (!confirmed) return;

    final rotated = await ref
        .read(unitActionsProvider(widget.unit.id).notifier)
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

    // Read once for the whole list rather than per row: who is looking, and
    // whether they run this object, is the same answer for every line of it.
    final myUserId = ref.watch(authStateProvider).value?.id;
    final isOwner =
        ref.watch(myUnitRoleProvider(unitId)).value == UnitRole.owner;

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
                  UnitMemberTile(
                    unitId: unitId,
                    view: view,
                    all: people,
                    position: index + 1,
                    isOwner: isOwner,
                    myUserId: myUserId,
                  ),
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

    // Held before the dialog: after an await the ref may no longer be the one
    // this menu was built with.
    final unitActions = ref.read(unitActionsProvider(unit.id).notifier);

    Future<void> delete() async {
      final confirmed = await DvConfirmDialog.ask(
        context,
        title: l10n.deleteUnitTitle(unit.label),
        message: l10n.deleteUnitBody,
        confirmLabel: l10n.deleteUnit,
        icon: Icons.delete_outline_rounded,
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
          icon: Icons.delete_outline_rounded,
          onSelected: delete,
          isDestructive: true,
        ),
      ],
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

    return DvTile(
      title: unit.label,
      subtitle: unit.type.label(l10n),
      dense: true,
      onTap: () => context.push(AppRoutes.unitPath(unit.id)),
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
