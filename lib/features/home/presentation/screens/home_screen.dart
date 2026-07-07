import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Temporary landing screen for signed-in users, replaced by the role-based
/// member/admin shells once onboarding lands.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.homePlaceholder,
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium,
          ),
        ),
      ),
    );
  }
}
