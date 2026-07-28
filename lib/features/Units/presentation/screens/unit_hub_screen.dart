import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/core/notifications/toast_controller.dart';
import 'package:dvir/core/utils/share.dart';
import 'package:dvir/features/Members/application/unit_members_controller.dart';
import 'package:dvir/features/Members/domain/models/unit_member_view.dart';
import 'package:dvir/features/Shared/presentation/dv_app_bar.dart';
import 'package:dvir/features/Shared/presentation/dv_async_view.dart';
import 'package:dvir/features/Shared/presentation/dv_background.dart';
import 'package:dvir/features/Shared/presentation/dv_button.dart';
import 'package:dvir/features/Shared/presentation/dv_invite_code_card.dart';
import 'package:dvir/features/Shared/presentation/dv_scaffold.dart';
import 'package:dvir/features/Shared/presentation/dv_shimmer.dart';
import 'package:dvir/features/Shared/presentation/member_status_l10n.dart';
import 'package:dvir/features/Units/application/unit_controller.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/features/Units/domain/types/unit_role.dart';
import 'package:dvir/features/Units/presentation/unit_role_l10n.dart';
import 'package:dvir/features/Units/presentation/unit_type_l10n.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    return DvScaffold(
      background: const DvAppGradient(),
      appBar: DvAppBar(title: unit.value?.label ?? ''),
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
          ..invalidate(unitMembersProvider(unit.id));
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
        ],
      ),
    );
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
          ? Text(
              l10n.unitPeopleEmpty,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            )
          : Column(
              children: [for (final view in people) _PersonRow(view: view)],
            ),
    );
  }
}

class _PersonRow extends StatelessWidget {
  const _PersonRow({required this.view});

  final UnitMemberView view;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final membership = view.membership;
    final name = view.profile?.fullName;

    // A profile arrives empty until the person fills it in, and a whole profile
    // stays hidden from anyone not entitled to read it — both end up here.
    final title = name == null || name.isEmpty ? l10n.unnamedMember : name;

    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.textTheme.titleSmall),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  membership.role.label(l10n),
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (!view.isActive)
            Text(
              membership.status.label(l10n),
              style: context.textTheme.labelSmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Text(
        text.toUpperCase(),
        style: context.textTheme.labelSmall?.copyWith(
          color: context.colorScheme.onSurfaceVariant,
          letterSpacing: 1,
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
