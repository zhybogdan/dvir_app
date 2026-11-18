import 'package:dvir/app/icons.dart';
import 'package:dvir/app/routes.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Community/presentation/community_type_l10n.dart';
import 'package:dvir/features/Home/application/my_scopes_controller.dart';
import 'package:dvir/features/Home/domain/models/scope_summary.dart';
import 'package:dvir/features/Home/domain/scope_arrangement.dart';
import 'package:dvir/features/Home/presentation/components/scope_card.dart';
import 'package:dvir/features/Home/presentation/scope_counts_l10n.dart';
import 'package:dvir/features/Shared/presentation/dv_app_bar.dart';
import 'package:dvir/features/Shared/presentation/dv_async_view.dart';
import 'package:dvir/features/Shared/presentation/dv_icon_button.dart';
import 'package:dvir/features/Shared/presentation/dv_scaffold.dart';
import 'package:dvir/features/Shared/presentation/dv_shimmer.dart';
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
        title: l10n.appTitle,
        actions: [
          DvIconButton(
            // Pushed rather than `go`: adding a scope is a detour from here,
            // and the back arrow is how it gets abandoned.
            onPressed: () => context.push(AppRoutes.onboarding),
            icon: AppIcons.add,
            tooltip: l10n.addScope,
          ),
        ],
      ),
      body: DvAsyncView<MyScopes?>(
        value: ref.watch(myScopesProvider),
        skeleton: const _ScopesSkeleton(),
        onRetry: () => ref.invalidate(myScopesProvider),
        builder: (context, data) =>
            _ScopeList(scopes: data?.scopes ?? const []),
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
    // Objects created inside another are folded into it, so a house and its
    // own flats do not stand side by side as separate places to live.
    final rows = arrangeScopes(scopes);
    final communities = rows.where((row) => row.scope is CommunitySummary);
    final units = rows.where((row) => row.scope is UnitSummary);

    return RefreshIndicator(
      onRefresh: () => ref.refresh(myScopesProvider.future),
      child: ListView(
        padding: context.pagePadding,
        children: [
          if (communities.isNotEmpty) ...[
            _SectionTitle(l10n.scopesCommunities),
            for (final row in communities) _ScopeRow(row: row),
          ],
          if (units.isNotEmpty) ...[
            _SectionTitle(l10n.scopesUnits),
            for (final row in units) _ScopeRow(row: row),
          ],
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
      padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.sm),
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

/// A place, and under it the objects of the user's own that stand inside it.
///
/// Nesting is drawn rather than written: the child is a card of its own, a
/// step to the right. The line of small print it used to be named in said how
/// many and which, and nothing about what was in there.
class _ScopeRow extends StatelessWidget {
  const _ScopeRow({required this.row});

  final ScopeRow row;

  @override
  Widget build(BuildContext context) {
    final row = this.row;
    final scope = row.scope;
    final nested = row.nested;

    return Column(
      children: [
        _ScopeCard(scope: scope, nestedCount: nested.length),
        for (final child in nested)
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.lg),
            child: _NestedCard(summary: child, parent: _nameOf(scope)),
          ),
      ],
    );
  }

  String? _nameOf(ScopeSummary scope) => switch (scope) {
    CommunitySummary(:final community) => community?.name,
    UnitSummary(:final unit) => unit?.label,
  };
}

class _ScopeCard extends StatelessWidget {
  const _ScopeCard({required this.scope, required this.nestedCount});

  final ScopeSummary scope;

  /// Counted from the row rather than asked of the database: the list already
  /// holds the children by name.
  final int nestedCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scope = this.scope;

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

    return ScopeCard(
      icon: icon,
      title: name ?? l10n.scopePending,
      subtitle: subtitle ?? scope.status.label(l10n),
      tone: scope.isActive ? tone : null,
      counts: scope.countsRow(l10n, nested: nestedCount),
      onTap: destination == null ? null : () => context.push(destination),
    );
  }

  /// The kind of place and where it stands — "Будинок · Київ, Садова 14".
  ///
  /// The address collapses to nothing when it was never filled in, which is
  /// most objects on the day they are created.
  String _whereItIs(Unit unit, AppLocalizations l10n) {
    final where = [unit.city, unit.address].nonNulls.join(', ');
    final kind = unit.type.label(l10n);

    return where.isEmpty ? kind : '$kind · $where';
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

/// An object inside the card above it.
///
/// Its own type is carried by the glyph and the colour, so the line of words
/// is spent on the one thing the card above cannot say: which place it is in.
class _NestedCard extends StatelessWidget {
  const _NestedCard({required this.summary, required this.parent});

  final UnitSummary summary;
  final String? parent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final unit = summary.unit;
    final parent = this.parent;

    if (unit == null) return const SizedBox.shrink();

    return ScopeCard(
      dense: true,
      icon: unit.type.icon,
      title: unit.label,
      subtitle: parent == null
          ? unit.type.label(l10n)
          : l10n.scopeNested(parent),
      tone: unit.type.tone,
      counts: summary.countsRow(l10n, nested: 0),
      onTap: () => context.push(AppRoutes.unitPath(unit.id)),
    );
  }
}

class _ScopesSkeleton extends StatelessWidget {
  const _ScopesSkeleton();

  @override
  Widget build(BuildContext context) {
    return DvShimmer(
      child: ListView(
        padding: context.pagePadding,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.sm),
            child: DvSkeletonBox(width: 96, height: AppSpacing.sm),
          ),
          for (var i = 0; i < 3; i++)
            const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.sm),
              child: DvSkeletonBox(height: 76, radius: AppRadius.lg),
            ),
        ],
      ),
    );
  }
}
