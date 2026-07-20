import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// Placeholder: the form (object type, label, address, area) lands in the next
// step.
class CreateUnitScreen extends StatelessWidget {
  const CreateUnitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(appBar: AppBar(title: Text(l10n.onboardingCreateUnit)));
  }
}
