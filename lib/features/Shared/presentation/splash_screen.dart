import 'package:dvir/app/theme.dart';
import 'package:dvir/core/error/failure_l10n.dart';
import 'package:dvir/features/Home/application/my_scopes_controller.dart';
import 'package:dvir/features/Shared/presentation/dv_app_mark.dart';
import 'package:dvir/features/Shared/presentation/dv_error_view.dart';
import 'package:dvir/features/Shared/presentation/dv_scaffold.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Held while the router works out where the visitor belongs — on a cold start,
/// and again after signing in while the scope list loads.
///
/// Branded rather than a bare spinner: the wait is a real round trip, and the
/// mark reads as the app opening instead of as the app stalling. Deliberately
/// not a shimmer skeleton — the destination (home, onboarding or the waiting
/// screen) is the very thing still unknown here, so there is no content shape
/// to imitate.
///
/// It also has to offer a way out. The router holds a signed-in user here until
/// it knows their scopes, so a failed load — a dead connection, a sleeping
/// project — would otherwise be a spinner with no end and no button.
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final error = ref.watch(myScopesProvider).error;

    return DvScaffold(
      body: Center(
        child: error == null
            ? const _Waiting()
            : DvErrorView(
                message: errorMessage(error, AppLocalizations.of(context)),
                onRetry: () => ref.invalidate(myScopesProvider),
              ),
      ),
    );
  }
}

class _Waiting extends StatelessWidget {
  const _Waiting();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DvAppMark(size: 72),
        SizedBox(height: AppSpacing.xl),
        SizedBox.square(
          dimension: AppSpacing.lg,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ],
    );
  }
}
