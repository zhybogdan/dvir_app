import 'package:dvir/features/Shared/presentation/dv_app_bar.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CreateCommunityScreen extends StatelessWidget {
  const CreateCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(appBar: DvAppBar(title: l10n.onboardingCreateCommunity));
  }
}
