import 'package:dvir/app/icons.dart';
import 'package:dvir/app/routes.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/config/app_capabilities.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Backup/presentation/backup_restore_flow.dart';
import 'package:dvir/features/Shared/presentation/dv_start_card.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// What the app says before the first object exists.
///
/// The screen rather than a screen before it: a build with nobody else in it
/// has no community to found and no code to have been given, so the question
/// "where do we start" has one answer and does not deserve a page of its own.
/// The same choice the empty object made — invite inside the screen, not in
/// front of it.
///
/// Two moves, because there are two kinds of person holding a new install: one
/// has a house to write down, the other has an old phone with it already
/// written down. The second one is why restoring is offered here at all and
/// not left in the settings, where somebody with nothing yet has no reason to
/// look.
class ScopesStartBlock extends ConsumerWidget {
  const ScopesStartBlock({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    // A copy of the phone is what a build with no account has instead of an
    // account; where there is one, the records are already on the other side.
    final onDevice = !ref.watch(appCapabilitiesProvider).people;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // The lead, not a heading: a screen that is visibly empty does not
        // need to be told that it is.
        Text(l10n.scopesEmptyLead, style: context.textTheme.bodyLarge),
        const SizedBox(height: AppSpacing.lg),
        DvStartCard(
          icon: AppIcons.unitHouse,
          tone: AppTones.place,
          title: l10n.scopesEmptyCreate,
          text: l10n.scopesEmptyCreateWhy,
          onTap: () => context.push(AppRoutes.onboardingUnit),
        ),
        if (onDevice)
          DvStartCard(
            icon: AppIcons.refresh,
            tone: AppTones.other,
            title: l10n.scopesEmptyRestore,
            text: l10n.scopesEmptyRestoreWhy,
            onTap: () => BackupRestoreFlow.start(context, ref),
          ),
      ],
    );
  }
}
