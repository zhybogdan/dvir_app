import 'package:dvir/features/Settings/application/theme_mode_controller.dart';
import 'package:dvir/features/Shared/presentation/dv_section_title.dart';
import 'package:dvir/features/Shared/presentation/dv_segmented.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// «Світла · Темна · Системна», all three on screen at once.
///
/// System last rather than first: it is the default, and the two a person
/// came here to choose between are the ones read first.
class ThemePicker extends ConsumerWidget {
  const ThemePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DvSectionTitle(l10n.settingsTheme),
        DvSegmented<ThemeMode>(
          segments: [
            DvSegment(value: ThemeMode.light, label: l10n.settingsThemeLight),
            DvSegment(value: ThemeMode.dark, label: l10n.settingsThemeDark),
            DvSegment(value: ThemeMode.system, label: l10n.settingsThemeSystem),
          ],
          value: ref.watch(themeModeControllerProvider),
          onChanged: ref.read(themeModeControllerProvider.notifier).select,
        ),
      ],
    );
  }
}
