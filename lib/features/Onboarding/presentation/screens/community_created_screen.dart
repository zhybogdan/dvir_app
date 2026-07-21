import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Community/domain/models/community.dart';
import 'package:dvir/features/Onboarding/application/membership_controller.dart';
import 'package:dvir/features/Shared/presentation/dv_app_bar.dart';
import 'package:dvir/features/Shared/presentation/dv_button.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shown right after a community is created: its invite code, big and
/// copyable, because gathering neighbours is the only sensible next step.
///
/// The back button is suppressed and membership is refreshed only on "go home",
/// so the router does not pull the fresh admin away before they take the code.
class CommunityCreatedScreen extends ConsumerWidget {
  const CommunityCreatedScreen({required this.community, super.key});

  final Community community;

  void _copyCode(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    Clipboard.setData(ClipboardData(text: community.inviteCode));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.codeCopied)));
  }

  void _goHome(WidgetRef ref) {
    ref.invalidate(myMembershipProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: DvAppBar(title: l10n.communityCreatedTitle, showBack: false),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                const Spacer(),
                Icon(
                  Icons.check_circle_outline,
                  size: 64,
                  color: context.colorScheme.primary,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  community.name,
                  style: context.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                _InviteCodeCard(code: community.inviteCode),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.inviteCodeHint,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                DvButton(
                  label: l10n.copyCode,
                  icon: Icons.copy_outlined,
                  onPressed: () => _copyCode(context),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: () => _goHome(ref),
                  child: Text(l10n.goToHome),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The invite code itself: large, letter-spaced, on a tinted card so it reads
/// as the thing to copy off the screen.
class _InviteCodeCard extends StatelessWidget {
  const _InviteCodeCard({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          Text(
            l10n.inviteCodeLabel.toUpperCase(),
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            code,
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 4,
            ),
          ),
        ],
      ),
    );
  }
}
