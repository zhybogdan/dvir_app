import 'package:dvir/app/router.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/features/Shared/presentation/dv_toast_overlay.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      routerConfig: router,
      // System font size is honoured, but only up to a point: Android hands out
      // scales up to 2.0, and past ~1.4 a card of two-line titles stops being a
      // list and starts being one row per screen. Clamped here rather than in
      // each screen so no layout has to defend itself.
      builder: (context, child) => MediaQuery.withClampedTextScaling(
        maxScaleFactor: AppTextScale.max,
        child: DvToastOverlay(child: child ?? const SizedBox.shrink()),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
