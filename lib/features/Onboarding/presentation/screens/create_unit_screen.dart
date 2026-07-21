import 'package:dvir/features/Shared/presentation/dv_app_bar.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CreateUnitScreen extends StatelessWidget {
  const CreateUnitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(appBar: DvAppBar(title: l10n.onboardingCreateUnit));
  }
}
