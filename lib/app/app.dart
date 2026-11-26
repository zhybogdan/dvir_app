import 'package:dvir/app/router.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/config/app_locales.dart';
import 'package:dvir/features/Settings/application/locale_controller.dart';
import 'package:dvir/features/Settings/application/theme_mode_controller.dart';
import 'package:dvir/features/Shared/presentation/dv_toast_overlay.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Root widget: wires the router, theme and localization into MaterialApp.
class DvirApp extends ConsumerWidget {
  const DvirApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ref.watch(themeModeControllerProvider),
      routerConfig: router,
      // System font size is honoured, but only up to a point: Android hands out
      // scales up to 2.0, and past ~1.4 a card of two-line titles stops being a
      // list and starts being one row per screen. Clamped here rather than in
      // each screen so no layout has to defend itself.
      builder: (context, child) => MediaQuery.withClampedTextScaling(
        maxScaleFactor: AppTextScale.max,
        child: DvToastOverlay(child: child ?? const SizedBox.shrink()),
      ),
      // Null while nobody has picked a language, which leaves the choice to
      // the phone; once picked it outranks the phone until it is changed here.
      locale: ref.watch(localeControllerProvider),
      localizationsDelegates: AppLocales.delegates,
      supportedLocales: AppLocales.supported,
    );
  }
}
