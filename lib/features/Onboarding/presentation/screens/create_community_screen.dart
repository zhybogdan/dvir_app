import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// Placeholder: the form (type picker, name, address) and the invite-code hand-off
// land in the next step.
class CreateCommunityScreen extends StatelessWidget {
  const CreateCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.onboardingCreateCommunity)),
    );
  }
}
