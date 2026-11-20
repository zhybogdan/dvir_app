import 'package:dvir/app/icons.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/config/app_capabilities.dart';
import 'package:dvir/features/Shared/presentation/dv_nav_island.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The four places of the app and the island that moves between them.
///
/// Each tab keeps its own history: leaving a house for the papers and coming
/// back finds the house, not the list it was opened from. That is what
/// `StatefulShellRoute` is for, and why the object's screens live inside the
/// first branch rather than on top of the shell.
///
/// The island floats over the pages, so the pages are told it is there: the
/// bottom of `MediaQuery.padding` grows by [DvNavIsland.space], and every
/// scrolling screen that pads with `context.pagePadding` leaves room for it
/// without knowing what it is leaving room for.
class AppShell extends ConsumerWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final navigationShell = this.navigationShell;
    final media = MediaQuery.of(context);
    final system = media.padding.bottom;
    // The fourth tab is the person in a build that has people, and the app's
    // own settings in one that does not — the same branch the old toolbar
    // button made between two icons.
    final people = ref.watch(appCapabilitiesProvider).people;

    final items = <DvNavItem>[
      (icon: AppIcons.unitHouse, label: l10n.navObjects),
      (icon: AppIcons.documentGeneric, label: l10n.documents),
      (icon: AppIcons.call, label: l10n.contacts),
      people
          ? (icon: AppIcons.profile, label: l10n.profileTitle)
          : (icon: AppIcons.settings, label: l10n.settingsTitle),
    ];

    return Stack(
      children: [
        MediaQuery(
          data: media.copyWith(
            padding: media.padding.copyWith(bottom: system + DvNavIsland.space),
            viewPadding: media.viewPadding.copyWith(
              bottom: media.viewPadding.bottom + DvNavIsland.space,
            ),
          ),
          child: navigationShell,
        ),
        Positioned(
          left: AppSpacing.md,
          right: AppSpacing.md,
          bottom: AppSpacing.md + system,
          child: DvNavIsland(
            items: items,
            selectedIndex: navigationShell.currentIndex,
            // A tap on the tab already open goes back to its first page —
            // the way out of a house three screens deep without three taps
            // on the arrow.
            onSelected: (index) => navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            ),
          ),
        ),
      ],
    );
  }
}
