import 'package:dvir/core/config/app_locales.dart';
import 'package:dvir/features/Settings/application/locale_controller.dart';
import 'package:dvir/features/Shared/presentation/dv_section_title.dart';
import 'package:dvir/features/Shared/presentation/dv_segmented.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// «Українська · English», each named in its own language.
///
/// The value comes from `Localizations`, not from the stored choice, because
/// until a person picks one there is nothing stored and the phone decides. The
/// control then shows the language that is actually on screen, which is the
/// only honest answer with two segments and no "system" among them.
class LanguagePicker extends ConsumerWidget {
  const LanguagePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DvSectionTitle(l10n.settingsLanguage),
        DvSegmented<Locale>(
          segments: [
            DvSegment(value: AppLocales.uk, label: l10n.settingsLanguageUk),
            DvSegment(value: AppLocales.en, label: l10n.settingsLanguageEn),
          ],
          value: Localizations.localeOf(context),
          onChanged: ref.read(localeControllerProvider.notifier).select,
        ),
      ],
    );
  }
}
