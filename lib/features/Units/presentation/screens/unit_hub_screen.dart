import 'package:dvir/app/routes.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/async_value_x.dart';
import 'package:dvir/features/Documents/application/documents_controller.dart';
import 'package:dvir/features/Documents/presentation/components/documents_section.dart';
import 'package:dvir/features/Members/application/unit_members_controller.dart';
import 'package:dvir/features/Shared/domain/types/scope_ref.dart';
import 'package:dvir/features/Shared/presentation/dv_app_bar.dart';
import 'package:dvir/features/Shared/presentation/dv_async_view.dart';
import 'package:dvir/features/Shared/presentation/dv_background.dart';
import 'package:dvir/features/Shared/presentation/dv_icon_button.dart';
import 'package:dvir/features/Shared/presentation/dv_scaffold.dart';
import 'package:dvir/features/Shared/presentation/dv_section_title.dart';
import 'package:dvir/features/Shared/presentation/dv_shimmer.dart';
import 'package:dvir/features/Units/application/unit_actions_controller.dart';
import 'package:dvir/features/Units/application/unit_attributes_controller.dart';
import 'package:dvir/features/Units/application/unit_children_controller.dart';
import 'package:dvir/features/Units/application/unit_controller.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/features/Units/domain/unit_nesting.dart';
import 'package:dvir/features/Units/presentation/components/unit_attributes_section.dart';
import 'package:dvir/features/Units/presentation/components/unit_children_list.dart';
import 'package:dvir/features/Units/presentation/components/unit_invite_section.dart';
import 'package:dvir/features/Units/presentation/components/unit_menu.dart';
import 'package:dvir/features/Units/presentation/components/unit_people_list.dart';
import 'package:dvir/features/Units/presentation/components/unit_specs_card.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Everything that belongs to one object, on one screen.
///
/// The object is a place you enter, not a row you read: its specs, the people
/// attached to it and the code that lets more of them in. Documents, meters and
/// expenses join this screen as their phases land — each of those tables hangs
/// off the same `unit_id`, so the hub grows by a section rather than by a
/// subsystem.
///
/// Each section is a component of its own under `presentation/components/`.
/// What is left here is the order they appear in and what the screen as a whole
/// waits for.
class UnitHubScreen extends ConsumerWidget {
  const UnitHubScreen({required this.unitId, super.key});

  final String unitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unitId = this.unitId;
    final unit = ref.watch(unitProvider(unitId));
    final isOwner = ref.watch(isUnitOwnerProvider(unitId));

    final l10n = AppLocalizations.of(context);
    final loaded = unit.value;

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
            UnitMenu(unit: loaded),
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
    final isOwner = ref.watch(isUnitOwnerProvider(unit.id));

    return RefreshIndicator(
      onRefresh: () async {
        ref
          ..invalidate(unitProvider(unit.id))
          ..invalidate(unitMembersProvider(unit.id))
          ..invalidate(unitAttributesProvider(unit.id))
          ..invalidate(documentsProvider(ScopeRef.unit(unit.id)))
          ..invalidate(unitChildrenProvider(unit.id));
      },
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          UnitSpecsCard(unit: unit),
          const SizedBox(height: AppSpacing.lg),
          UnitAttributesSection(unitId: unit.id),
          const SizedBox(height: AppSpacing.lg),
          DocumentsSection(unitId: unit.id),
          if (isOwner) ...[
            const SizedBox(height: AppSpacing.lg),
            UnitInviteSection(unit: unit),
          ],
          const SizedBox(height: AppSpacing.lg),
          DvSectionTitle(
            l10n.unitNested,
            action: isOwner && canHoldChildren(unit.type)
                ? (
                    label: l10n.unitAddCta,
                    onPressed: () =>
                        context.push(AppRoutes.unitAddPath(unit.id)),
                  )
                : null,
          ),
          UnitChildrenList(unitId: unit.id),
          const SizedBox(height: AppSpacing.lg),
          DvSectionTitle(l10n.unitPeople),
          UnitPeopleList(unitId: unit.id),
        ],
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
