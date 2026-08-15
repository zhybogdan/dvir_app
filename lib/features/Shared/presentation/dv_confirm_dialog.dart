import 'package:dvir/app/icons.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Shared/presentation/dv_button.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The question asked before something that cannot be taken back.
///
/// [message] is meant to spell out the consequence rather than repeat the
/// title — "everything nested inside goes too" is what makes the difference
/// between a considered yes and a reflex one, and "are you sure?" never does.
///
/// Built out of a plain [Material] rather than `AlertDialog`, whose layout
/// puts both answers in a corner at the same weight. Here the consequence is
/// announced by a badge, and the two answers are full-width and unequal: the
/// red one is the one being asked about.
class DvConfirmDialog extends StatelessWidget {
  const DvConfirmDialog({
    required this.title,
    required this.message,
    required this.confirmLabel,
    super.key,
    this.icon = AppIcons.warning,
  });

  /// Wide enough to read, narrow enough to stay a question rather than become
  /// a screen on a tablet.
  static const double _maxWidth = 360;

  /// Resolves to true only on an explicit yes — dismissing by tapping outside
  /// counts as no.
  static Future<bool> ask(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    IconData icon = AppIcons.warning,
  }) async {
    final confirmed = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: context.colorScheme.scrim.withValues(alpha: 0.5),
      // Named so the route observer logs what opened, not an unnamed route.
      routeSettings: const RouteSettings(name: 'DvConfirmDialog'),
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (context, animation, secondaryAnimation) => DvConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        icon: icon,
      ),
      transitionBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(
            opacity: animation.drive(CurveTween(curve: Curves.easeOut)),
            child: ScaleTransition(
              scale: animation.drive(
                Tween(
                  begin: 0.94,
                  end: 1.0,
                ).chain(CurveTween(curve: Curves.easeOutCubic)),
              ),
              child: child,
            ),
          ),
    );

    return confirmed ?? false;
  }

  final String title;
  final String message;
  final String confirmLabel;

  /// The glyph in the badge, for when the warning has a shape of its own.
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = context.colorScheme;
    final text = context.textTheme;
    final navigator = Navigator.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _maxWidth),
          child: Material(
            color: scheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: AppSpacing.md,
                children: [
                  _WarningBadge(icon: icon),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: text.titleLarge,
                  ),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: text.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  Row(
                    spacing: AppSpacing.sm,
                    children: [
                      Expanded(
                        child: DvButton.tonal(
                          label: l10n.cancel,
                          onPressed: () => navigator.pop(false),
                        ),
                      ),
                      Expanded(
                        child: DvButton.danger(
                          label: confirmLabel,
                          // The one place in the app that answers in the hand:
                          // every irreversible action is confirmed here, so the
                          // knock lands on all of them at once.
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            navigator.pop(true);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WarningBadge extends StatelessWidget {
  const _WarningBadge({required this.icon});

  static const double _size = 56;

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;

    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: AppSpacing.xl, color: scheme.onErrorContainer),
    );
  }
}
