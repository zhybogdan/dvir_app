import 'package:dvir/app/theme.dart';
import 'package:dvir/features/Shared/presentation/dv_app_mark.dart';
import 'package:dvir/features/Shared/presentation/dv_scaffold.dart';
import 'package:flutter/material.dart';

/// Held while the router works out where the visitor belongs — on a cold start,
/// and again after signing in while membership loads.
///
/// Branded rather than a bare spinner: the wait is a real round trip, and the
/// mark reads as the app opening instead of as the app stalling. Deliberately
/// not a shimmer skeleton — the destination (home, onboarding or the waiting
/// screen) is the very thing still unknown here, so there is no content shape
/// to imitate.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DvScaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DvAppMark(size: 72),
            SizedBox(height: AppSpacing.xl),
            SizedBox.square(
              dimension: AppSpacing.lg,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ),
      ),
    );
  }
}
