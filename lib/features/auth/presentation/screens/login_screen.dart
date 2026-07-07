import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Placeholder login screen. The real auth flow (email/password sign in and
/// sign up) is implemented in Phase 2 of the roadmap.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Center(
        child: Text(
          l10n.signIn,
          style: context.textTheme.headlineSmall,
        ),
      ),
    );
  }
}
