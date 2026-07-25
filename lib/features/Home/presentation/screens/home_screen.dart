import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/async_value_x.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Auth/application/auth_controller.dart';
import 'package:dvir/features/Shared/presentation/dv_app_bar.dart';
import 'package:dvir/features/Shared/presentation/dv_shimmer.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Temporary landing screen for signed-in users, replaced by the role-based
/// member/admin shells once onboarding lands.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isLoading = ref.watch(authControllerProvider).isLoading;

    ref.listen(
      authControllerProvider,
      (previous, next) => next.showFailure(context, ref),
    );

    final onSignOut = isLoading
        ? null
        : () => ref.read(authControllerProvider.notifier).signOut();

    return Scaffold(
      appBar: DvAppBar(
        title: l10n.appTitle,
        actions: [
          IconButton(
            onPressed: onSignOut,
            icon: const Icon(Icons.logout),
            tooltip: l10n.signOut,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.homePlaceholder,
              textAlign: TextAlign.center,
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            // TEMP(demo): shows the shimmer primitives until the real list
            // screens land in Phase 4 — remove with the first one.
            const Expanded(child: _ListSkeletonDemo()),
          ],
        ),
      ),
    );
  }
}

/// Stand-in for a feed of cards, to preview the shimmer before real lists exist.
class _ListSkeletonDemo extends StatelessWidget {
  const _ListSkeletonDemo();

  @override
  Widget build(BuildContext context) {
    return DvShimmer(
      child: ListView.separated(
        itemCount: 4,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) => const _CardSkeleton(),
      ),
    );
  }
}

class _CardSkeleton extends StatelessWidget {
  const _CardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DvSkeletonBox.circle(size: 40),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DvSkeletonBox(width: 140, height: 14),
              const SizedBox(height: AppSpacing.sm),
              const DvSkeletonBox(height: 12),
              const SizedBox(height: AppSpacing.xs + AppSpacing.xs),
              FractionallySizedBox(
                widthFactor: 0.6,
                child: const DvSkeletonBox(height: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
