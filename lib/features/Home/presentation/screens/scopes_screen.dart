import 'package:dvir/app/routes.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Auth/application/auth_controller.dart';
import 'package:dvir/features/Community/presentation/community_type_l10n.dart';
import 'package:dvir/features/Home/application/my_scopes_controller.dart';
import 'package:dvir/features/Home/domain/models/scope_summary.dart';
import 'package:dvir/features/Shared/presentation/dv_app_bar.dart';
import 'package:dvir/features/Shared/presentation/dv_async_view.dart';
import 'package:dvir/features/Shared/presentation/dv_scaffold.dart';
import 'package:dvir/features/Shared/presentation/dv_shimmer.dart';
import 'package:dvir/features/Shared/presentation/member_status_l10n.dart';
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
      appBar: DvAppBar(
        title: l10n.appTitle,
        actions: [
          IconButton(
            // Pushed rather than `go`: adding a scope is a detour from here,
            // and the back arrow is how it gets abandoned.
            onPressed: () => context.push(AppRoutes.onboarding),
            icon: const Icon(Icons.add),
            tooltip: l10n.addScope,
          ),
          IconButton(
            onPressed: () =>
                ref.read(authControllerProvider.notifier).signOut(),
            icon: const Icon(Icons.logout),
            tooltip: l10n.signOut,
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
    final communities = scopes.whereType<CommunitySummary>();
    final units = scopes.whereType<UnitSummary>();

    return RefreshIndicator(
      onRefresh: () => ref.refresh(myScopesProvider.future),
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          if (communities.isNotEmpty) ...[
            _SectionTitle(l10n.scopesCommunities),
            for (final scope in communities) _ScopeCard(scope: scope),
          ],
          if (units.isNotEmpty) ...[
            _SectionTitle(l10n.scopesUnits),
            for (final scope in units) _ScopeCard(scope: scope),
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
  const _ScopeCard({required this.scope});

  final ScopeSummary scope;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scope = this.scope;

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
    final title = name ?? l10n.scopePending;
    final caption = kind ?? scope.status.label(l10n);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          _ScopeIcon(icon: icon, muted: !scope.isActive),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  caption,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(UnitType? type) => switch (type) {
    UnitType.house => Icons.home_rounded,
    UnitType.apartment => Icons.meeting_room_rounded,
    UnitType.plot => Icons.grass_rounded,
    UnitType.garage => Icons.garage_rounded,
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
