import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Shared/presentation/dv_button.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Fills the space a failed load was meant to occupy: what went wrong, and the
/// way out of it.
///
/// For whole screens and sections, where a toast would be the wrong tool — it
/// slides away and leaves the user staring at nothing they can act on. Pass
/// [onRetry] whenever the caller can actually re-run the work; without it the
/// view degrades to an explanation.
class DvErrorView extends StatelessWidget {
  const DvErrorView({
    required this.message,
    super.key,
    this.title,
    this.onRetry,
  });

  final String message;

  /// Defaults to the generic wording; override when a screen can say something
  /// more precise than "something went wrong".
  final String? title;

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final onRetry = this.onRetry;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 48,
              color: context.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              title ?? l10n.errorTitle,
              style: context.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              DvButton(
                label: l10n.retry,
                icon: Icons.refresh_rounded,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
