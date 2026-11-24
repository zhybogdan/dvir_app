import 'package:dvir/app/icons.dart';
import 'package:dvir/app/routes.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/config/app_capabilities.dart';
import 'package:dvir/features/Community/presentation/community_type_l10n.dart';
import 'package:dvir/features/Home/application/my_scopes_controller.dart';
import 'package:dvir/features/Home/domain/models/scope_summary.dart';
import 'package:dvir/features/Home/domain/scope_arrangement.dart';
import 'package:dvir/features/Home/presentation/components/scopes_start_block.dart';
import 'package:dvir/features/Home/presentation/scope_counts_l10n.dart';
import 'package:dvir/features/Shared/presentation/dv_app_bar.dart';
import 'package:dvir/features/Shared/presentation/dv_async_view.dart';
import 'package:dvir/features/Shared/presentation/dv_icon_badge.dart';
import 'package:dvir/features/Shared/presentation/dv_icon_button.dart';
import 'package:dvir/features/Shared/presentation/dv_page_head.dart';
import 'package:dvir/features/Shared/presentation/dv_scaffold.dart';
import 'package:dvir/features/Shared/presentation/dv_section_title.dart';
import 'package:dvir/features/Shared/presentation/dv_shimmer.dart';
import 'package:dvir/features/Shared/presentation/dv_tile.dart';
import 'package:dvir/features/Shared/presentation/member_status_l10n.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/features/Units/presentation/unit_type_icon.dart';
import 'package:dvir/features/Units/presentation/unit_type_l10n.dart';
import 'package:dvir/features/Units/presentation/unit_type_tone.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The screen the app opens on: every community and every object this person
/// belongs to.
///
/// A list rather than one current scope with a switcher at the top. Someone can
/// own a house, rent a flat and sit on an OSBB board at once, and none of those
/// is a mode the app is in — so there is nothing to switch between, only places
/// to open.
class ScopesScreen extends ConsumerWidget {
  const ScopesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return DvScaffold(
      appBar: DvAppBar(
        // The heading is on the page, as on an object's screen: the bar is
        // left to the control that acts on the list.
        title: '',
        actions: [
          DvIconButton(
            // Pushed rather than `go`: adding a scope is a detour from here,
            // and the back arrow is how it gets abandoned.
            //
            // Straight to the form where there is nobody else: the choice
            // screen in that build offers one answer, and a question with one
            // answer is a tap, not a choice.
            onPressed: () => context.push(
              ref.watch(appCapabilitiesProvider).people
                  ? AppRoutes.onboarding
                  : AppRoutes.onboardingUnit,
            ),
            icon: AppIcons.add,
            tooltip: l10n.addScope,
          ),
        ],
      ),
      body: Column(
        children: [
          DvPageHead(l10n.scopesTitle),
          Expanded(
            child: DvAsyncView<MyScopes?>(
              value: ref.watch(myScopesProvider),
              skeleton: const _ScopesSkeleton(),
              onRetry: () => ref.invalidate(myScopesProvider),
              builder: (context, data) =>
                  _ScopeList(scopes: data?.scopes ?? const []),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScopeList extends ConsumerWidget {
  const _ScopeList({required this.scopes});

  final List<ScopeSummary> scopes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    // Objects created inside another are folded into it: the list holds what
    // stands on its own, and what stands inside it is counted on its card and
    // listed on its own screen. Drawn as a ribbon of indented cards, a house
    // with eight rooms was eight rows of noise under one row that mattered.
    final rows = arrangeScopes(scopes);
    final communities = rows.where((row) => row.scope is CommunitySummary);
    final units = rows.where((row) => row.scope is UnitSummary);
    // Groups are named only when there are two of them: one group under a
    // page that already says what it holds is a heading for nothing.
    final named = communities.isNotEmpty && units.isNotEmpty;

    return RefreshIndicator(
      onRefresh: () => ref.refresh(myScopesProvider.future),
      child: ListView(
        padding: context.pagePadding,
        // Scrollable with one block in it, so the list can still be pulled
        // down: a person who restored a copy on another screen comes back
        // here expecting that to work.
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          if (rows.isEmpty) const ScopesStartBlock(),
          if (communities.isNotEmpty) ...[
            if (named) DvSectionTitle(l10n.scopesCommunities),
            for (final row in communities) _ScopeCard(row: row),
          ],
          if (named) const SizedBox(height: AppSpacing.lg),
          if (units.isNotEmpty) ...[
            if (named) DvSectionTitle(l10n.scopesUnits),
            for (final row in units) _ScopeCard(row: row),
          ],
        ],
      ),
    );
  }
}

/// One place: what it is, where it stands, how much it holds.
///
/// A [DvTile] with the family's solid mark in front. It used to be a card of
/// its own, because the colour ran as a strip down the full height of it; the
/// strip went when one rule replaced two — a solid mark works in a list, in a
/// tile and in a row, a strip only in a card — and without it this is the shape
/// every other list in the app already is.
class _ScopeCard extends StatelessWidget {
  const _ScopeCard({required this.row});

  final ScopeRow row;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scope = row.scope;

    final (icon, name, subtitle, tone) = switch (scope) {
      CommunitySummary(:final community) => (
        AppIcons.community,
        community?.name,
        community?.type.label(l10n),
        // A community is a place you belong to, so it takes the tone of a
        // place rather than one of its own.
        AppTones.place,
      ),
      UnitSummary(:final unit) => (
        // Null while the scope is still pending, when there is no object to
        // read a type from yet.
        unit?.type.icon ?? AppIcons.unitOther,
        unit?.label,
        unit == null ? null : _whereItIs(unit, l10n),
        unit?.type.tone ?? AppTones.other,
      ),
    };

    // A scope the user is not active in arrives without its name: RLS hides it
    // until the request is approved, so that an invite code cannot be used to
    // find out what it opens. All such a card can say is where the request
    // stands.
    final destination = _destinationOf(scope);

    return DvTile(
      title: name ?? l10n.scopePending,
      subtitle: subtitle ?? scope.status.label(l10n),
      caption: scope.countsLine(l10n, nested: row.nested.length),
      leading: DvIconBadge(icon: icon, tone: tone, muted: !scope.isActive),
      onTap: destination == null ? null : () => context.push(destination),
    );
  }

  /// The kind of place and where it stands — "Будинок · вул. Садова, 14".
  ///
  /// The address alone, and the city only when there is no address. In a list
  /// of one household's places the street is what tells them apart, and the
  /// region in front of it pushed the house number onto a line of its own —
  /// "14" under everything else. The object's own screen still prints both.
  ///
  /// Nothing at all when neither was filled in, which is most objects on the
  /// day they are created.
  String _whereItIs(Unit unit, AppLocalizations l10n) {
    final where = [
      unit.address,
      unit.city,
    ].firstWhere((part) => part != null && part.isNotEmpty, orElse: () => null);
    final kind = unit.type.label(l10n);

    if (where == null) return kind;

    return '$kind · $where';
  }

  /// Where the card leads, or null when it leads nowhere yet.
  ///
  /// A scope still waiting for approval has nothing behind it to open — RLS
  /// would refuse every read. Communities have no screen at all while the
  /// product is being built around a single object.
  String? _destinationOf(ScopeSummary scope) => switch (scope) {
    UnitSummary(:final unit) when scope.isActive && unit != null =>
      AppRoutes.unitPath(unit.id),
    _ => null,
  };
}

class _ScopesSkeleton extends StatelessWidget {
  const _ScopesSkeleton();

  @override
  Widget build(BuildContext context) {
    return DvShimmer(
      child: ListView(
        padding: context.pagePadding,
        children: [
          for (var i = 0; i < 3; i++)
            const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.sm),
              child: DvSkeletonBox(height: 96, radius: AppRadius.lg),
            ),
        ],
      ),
    );
  }
}
