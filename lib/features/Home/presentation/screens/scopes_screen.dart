import 'package:dvir/app/routes.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Community/presentation/community_type_l10n.dart';
import 'package:dvir/features/Home/application/my_scopes_controller.dart';
import 'package:dvir/features/Home/domain/models/scope_summary.dart';
import 'package:dvir/features/Home/domain/scope_arrangement.dart';
import 'package:dvir/features/Shared/presentation/dv_app_bar.dart';
import 'package:dvir/features/Shared/presentation/dv_async_view.dart';
import 'package:dvir/features/Shared/presentation/dv_background.dart';
import 'package:dvir/features/Shared/presentation/dv_icon_button.dart';
import 'package:dvir/features/Shared/presentation/dv_scaffold.dart';
import 'package:dvir/features/Shared/presentation/dv_shimmer.dart';
import 'package:dvir/features/Shared/presentation/dv_tile.dart';
import 'package:dvir/features/Shared/presentation/member_status_l10n.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/features/Units/domain/types/unit_type.dart';
import 'package:dvir/features/Units/presentation/unit_type_l10n.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The screen the app opens on: every community and every object this person
/// belongs to.
///
/// A list rather than one current scope with a switcher at the top. Someone can
/// own a house, rent a flat and sit on an ОСББ board at once, and none of those
/// is a mode the app is in — so there is nothing to switch between, only places
/// to open.
class ScopesScreen extends ConsumerWidget {
  const ScopesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return DvScaffold(
      background: const DvAppGradient(),
      appBar: DvAppBar(
        title: l10n.appTitle,
        actions: [
          DvIconButton(
            // Pushed rather than `go`: adding a scope is a detour from here,
            // and the back arrow is how it gets abandoned.
            onPressed: () => context.push(AppRoutes.onboarding),
            icon: Icons.add,
            tooltip: l10n.addScope,
          ),
          // Signing out moved inside the profile: it is an account action, and
          // this screen is a list of places rather than a settings page.
          DvIconButton(
            onPressed: () => context.push(AppRoutes.profile),
            icon: Icons.person_outline,
            tooltip: l10n.profileTitle,
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
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          if (communities.isNotEmpty) ...[
            _SectionTitle(l10n.scopesCommunities),
            for (final row in communities) _ScopeCard(row: row),
          ],
          if (units.isNotEmpty) ...[
            _SectionTitle(l10n.scopesUnits),
            for (final row in units) _ScopeCard(row: row),
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

class _ScopeCard extends StatelessWidget {
  const _ScopeCard({required this.row});

  final ScopeRow row;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scope = row.scope;
    final nested = row.nested;

    final (icon, name, kind) = switch (scope) {
      CommunitySummary(:final community) => (
        Icons.apartment_rounded,
        community?.name,
        community?.type.label(l10n),
      ),
      UnitSummary(:final unit) => (
        _iconFor(unit?.type),
        unit?.label,
        unit?.type.label(l10n),
      ),
    };

    // A scope the user is not active in arrives without its name: RLS hides it
    // until the request is approved, so that an invite code cannot be used to
    // find out what it opens. All such a card can say is where the request
    // stands.
    final destination = _destinationOf(scope);

    return DvTile(
      title: name ?? l10n.scopePending,
      subtitle: kind ?? scope.status.label(l10n),
      caption: nested.isEmpty ? null : _nestedCaption(nested, l10n),
      leading: _ScopeIcon(icon: icon, muted: !scope.isActive),
      onTap: destination == null ? null : () => context.push(destination),
    );
  }

  /// The objects folded into this card, named rather than counted — "Квартира
  /// 1 · Квартира 2" says what is in there, "2 об'єкти" only says how many.
  ///
  /// Three fit on a line on a phone; the rest become a tally so the card keeps
  /// its height whatever the house holds.
  String _nestedCaption(List<Unit> nested, AppLocalizations l10n) {
    const shown = 3;
    final names = nested.take(shown).map((unit) => unit.label).join(' · ');
    final hidden = nested.length - shown;

    return l10n.scopeNested(
      hidden > 0 ? '$names ${l10n.scopeNestedMore(hidden)}' : names,
    );
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

  IconData _iconFor(UnitType? type) => switch (type) {
    UnitType.house || UnitType.summerHouse => Icons.home_rounded,
    UnitType.apartment => Icons.apartment_rounded,
    UnitType.room || UnitType.corridor => Icons.meeting_room_rounded,
    UnitType.garage => Icons.garage_rounded,
    UnitType.plot => Icons.grass_rounded,
    UnitType.basement || UnitType.storeroom => Icons.inventory_2_outlined,
    UnitType.summerKitchen => Icons.outdoor_grill_rounded,
    UnitType.shed => Icons.cabin_rounded,
    UnitType.pool => Icons.pool_rounded,
    UnitType.balcony || UnitType.loggia => Icons.balcony_rounded,
    UnitType.bathroom => Icons.shower_rounded,
    UnitType.office => Icons.business_rounded,
    UnitType.custom || null => Icons.place_rounded,
  };
}

class _ScopeIcon extends StatelessWidget {
  const _ScopeIcon({required this.icon, required this.muted});

  final IconData icon;

  /// A scope still waiting for approval cannot be opened yet, so it reads as a
  /// request rather than as one of the places this person already lives in.
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final color = muted ? scheme.onSurfaceVariant : scheme.primary;

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}

class _ScopesSkeleton extends StatelessWidget {
  const _ScopesSkeleton();

  @override
  Widget build(BuildContext context) {
    return DvShimmer(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
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
