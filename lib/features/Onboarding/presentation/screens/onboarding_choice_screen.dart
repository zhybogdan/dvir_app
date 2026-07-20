import 'package:dvir/app/routes.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/features/Shared/presentation/dv_button.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Where a user with no scope yet picks how to get one.
///
/// Creating a community and creating an object are separate entries because
/// they are different products to the person choosing: one runs a building
/// full of neighbours, the other runs their own address.
class OnboardingChoiceScreen extends StatelessWidget {
  const OnboardingChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.onboardingTitle)),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: AppSpacing.md,
          children: [
            DvButton(
              label: l10n.onboardingCreateCommunity,
              onPressed: () => context.go(AppRoutes.onboardingCommunity),
            ),
            DvButton(
              label: l10n.onboardingCreateUnit,
              onPressed: () => context.go(AppRoutes.onboardingUnit),
            ),
            DvButton(
              label: l10n.onboardingJoinByCode,
              onPressed: () => context.go(AppRoutes.onboardingJoin),
            ),
          ],
        ),
      ),
    );
  }
}
