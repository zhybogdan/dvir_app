import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// An invite code, set out to be read off a screen and typed into another one.
///
/// Wide letter spacing and a heading-sized face are the point rather than
/// decoration: the code is passed on by photograph and by voice, so the
/// characters have to stay apart.
class DvInviteCodeCard extends StatelessWidget {
  const DvInviteCodeCard({required this.code, super.key});

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
