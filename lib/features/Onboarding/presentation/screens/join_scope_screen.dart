import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// Placeholder: one code field for either scope — the backend works out whether
// it opens a community or an object.
class JoinScopeScreen extends StatelessWidget {
  const JoinScopeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(appBar: AppBar(title: Text(l10n.onboardingJoinByCode)));
  }
}
