import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Auth/application/auth_controller.dart';
import 'package:dvir/features/Home/application/my_scopes_controller.dart';
import 'package:dvir/features/Shared/domain/types/member_status.dart';
import 'package:dvir/features/Shared/presentation/dv_app_bar.dart';
import 'package:dvir/features/Shared/presentation/dv_button.dart';
import 'package:dvir/features/Shared/presentation/dv_scaffold.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shown while a join request is not yet active — pending, rejected or blocked.
///
/// Deliberately says nothing about the scope behind the code: RLS hides the
/// name from a non-active member, so an invite code cannot be used to find out
/// what it opens. "Refresh" re-reads membership, since approval is flipped
/// server-side and there is no realtime subscription yet.
class PendingApprovalScreen extends ConsumerWidget {
  const PendingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    // The router only lands here when nothing is active, so any scope in the
    // list explains the wait — the most recent one is the request just made.
    final status = ref.watch(myScopesProvider).value?.scopes.lastOrNull?.status;
    final view = _viewFor(status, l10n);

    return DvScaffold(
      extendBodyBehindAppBar: true,
      appBar: DvAppBar(
        title: view.title,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () =>
                ref.read(authControllerProvider.notifier).signOut(),
            icon: const Icon(Icons.logout),
            tooltip: l10n.signOut,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(view.icon, size: 64, color: context.colorScheme.primary),
              const SizedBox(height: AppSpacing.lg),
              Text(
                view.body,
                textAlign: TextAlign.center,
                style: context.textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.xl),
              DvButton(
                label: l10n.refreshCta,
                icon: Icons.refresh,
                onPressed: () => ref.invalidate(myScopesProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ({String title, String body, IconData icon}) _viewFor(
    MemberStatus? status,
    AppLocalizations l10n,
  ) => switch (status) {
    MemberStatus.rejected => (
      title: l10n.rejectedTitle,
      body: l10n.rejectedBody,
      icon: Icons.cancel_outlined,
    ),
    MemberStatus.blocked => (
      title: l10n.blockedTitle,
      body: l10n.blockedBody,
      icon: Icons.block,
    ),
    _ => (
      title: l10n.pendingApprovalTitle,
      body: l10n.pendingApprovalBody,
      icon: Icons.hourglass_top,
    ),
  };
}
