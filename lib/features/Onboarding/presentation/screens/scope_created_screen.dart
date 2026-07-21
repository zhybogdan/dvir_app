import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/core/utils/share.dart';
import 'package:dvir/features/Onboarding/application/membership_controller.dart';
import 'package:dvir/features/Shared/presentation/dv_app_bar.dart';
import 'package:dvir/features/Shared/presentation/dv_button.dart';
import 'package:dvir/gen/assets.gen.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Shown right after a scope (a community or an oselia) is created: its invite
/// code, big and copyable.
///
/// The back button is suppressed and membership is refreshed only on "go home",
/// so the router does not pull the fresh admin/owner away before they take the
/// code.
class ScopeCreatedScreen extends ConsumerWidget {
  const ScopeCreatedScreen({
    required this.title,
    required this.name,
    required this.inviteCode,
    required this.inviteHint,
    super.key,
  });

  final String title;
  final String name;
  final String inviteCode;
  final String inviteHint;

  void _copyCode(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    Clipboard.setData(ClipboardData(text: inviteCode));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.codeCopied)));
  }

  void _share(AppLocalizations l10n) {
    shareText(l10n.shareInviteText(name, inviteCode));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: DvAppBar(title: title, showBack: false),
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
                _InviteCodeCard(code: inviteCode),
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
                  icon: Icons.ios_share,
                  onPressed: () => _share(l10n),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextButton.icon(
                  onPressed: () => _copyCode(context),
                  icon: const Icon(Icons.copy_outlined),
                  label: Text(l10n.copyCode),
                ),
                TextButton(
                  onPressed: () => ref.invalidate(myMembershipProvider),
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

/// The added success badge, recoloured to the theme: only the purple gradient
/// is swapped for [color], the white check inside is kept.
class _SuccessBadge extends StatelessWidget {
  const _SuccessBadge({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Assets.icons.success.svg(
      width: 88,
      height: 88,
      colorMapper: _BadgeTint(color),
    );
  }
}

class _BadgeTint extends ColorMapper {
  const _BadgeTint(this.badge);

  final Color badge;

  @override
  Color substitute(
    String? id,
    String elementName,
    String attributeName,
    Color color,
  ) => color == const Color(0xFFFFFFFF) ? color : badge;
}

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
