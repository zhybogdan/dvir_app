import 'package:dvir/app/icons.dart';
import 'package:dvir/app/routes.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/core/notifications/toast_controller.dart';
import 'package:dvir/core/utils/share.dart';
import 'package:dvir/features/Home/application/my_scopes_controller.dart';
import 'package:dvir/features/Onboarding/application/created_scope_controller.dart';
import 'package:dvir/features/Onboarding/domain/models/created_scope.dart';
import 'package:dvir/features/Shared/presentation/dv_app_bar.dart';
import 'package:dvir/features/Shared/presentation/dv_button.dart';
import 'package:dvir/features/Shared/presentation/dv_icon.dart';
import 'package:dvir/features/Shared/presentation/dv_invite_code_card.dart';
import 'package:dvir/features/Shared/presentation/dv_scaffold.dart';
import 'package:dvir/features/Shared/presentation/dv_text_button.dart';
import 'package:dvir/features/Shared/presentation/splash_screen.dart';
import 'package:dvir/gen/assets.gen.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Shown right after a scope (a community or an oselia) is created: its invite
/// code, big and copyable.
///
/// The back button is suppressed and membership is refreshed only on "go home",
/// so the router does not pull the fresh admin/owner away before they take the
/// code.
class ScopeCreatedScreen extends ConsumerWidget {
  const ScopeCreatedScreen({super.key});

  void _copyCode(BuildContext context, WidgetRef ref, String inviteCode) {
    final l10n = AppLocalizations.of(context);
    Clipboard.setData(ClipboardData(text: inviteCode));
    ref.read(toastControllerProvider.notifier).success(l10n.codeCopied);
  }

  void _share(AppLocalizations l10n, String name, String inviteCode) {
    shareText(l10n.shareInviteText(name, inviteCode));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scope = ref.watch(createdScopeControllerProvider);
    final inviteCode = scope?.inviteCode;

    // Both are the same situation from the user's side: there is nothing to
    // show here yet. A created scope always carries its code, so a null one
    // means the screen was reached without one.
    if (scope == null || inviteCode == null) return const SplashScreen();

    final name = scope.name;
    final title = switch (scope) {
      CreatedCommunity() => l10n.communityCreatedTitle,
      CreatedUnit() => l10n.unitCreatedTitle,
    };
    final inviteHint = switch (scope) {
      CreatedCommunity() => l10n.inviteCodeHint,
      CreatedUnit() => l10n.unitInviteCodeHint,
    };

    return PopScope(
      canPop: false,
      child: DvScaffold(
        extendBodyBehindAppBar: true,
        appBar: DvAppBar(
          title: title,
          showBack: false,
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                const Spacer(),
                _SuccessBadge(color: context.colorScheme.primary),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  name,
                  style: context.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                DvInviteCodeCard(code: inviteCode),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  inviteHint,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                DvButton(
                  label: l10n.shareCode,
                  icon: AppIcons.share,
                  onPressed: () => _share(l10n, name, inviteCode),
                ),
                const SizedBox(height: AppSpacing.sm),
                DvTextButton(
                  label: l10n.copyCode,
                  icon: AppIcons.copy,
                  onPressed: () => _copyCode(context, ref, inviteCode),
                ),
                // Navigates rather than leaving it to the redirect: the creator
                // is already an active admin, and an active member is
                // deliberately allowed to stand inside onboarding — that is how
                // a second scope gets added.
                DvTextButton(
                  label: l10n.goToHome,
                  onPressed: () {
                    ref.invalidate(myScopesProvider);
                    context.go(AppRoutes.home);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The added success badge, recoloured to the theme: the purple gradient
/// becomes [color], the white check inside is kept.
class _SuccessBadge extends StatelessWidget {
  const _SuccessBadge({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Assets.icons.success.svg(
      width: 88,
      height: 88,
      colorMapper: SvgTint(color, keep: {AppColors.white}),
    );
  }
}
