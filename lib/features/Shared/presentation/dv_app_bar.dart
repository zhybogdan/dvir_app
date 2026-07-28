import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Shared/presentation/dv_icon_button.dart';
import 'package:dvir/gen/assets.gen.dart';
import 'package:flutter/material.dart';

/// Shared app bar so screens declare a title, not an [AppBar].
///
/// Thin on purpose: colours, alignment and elevation come from
/// `appBarTheme` (see `AppTheme`). This fixes the title style, the back button
/// and the contract every screen shares, so the whole app changes from one
/// place.
class DvAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DvAppBar({
    required this.title,
    super.key,
    this.actions,
    this.showBack = true,
    this.backgroundColor,
  });

  final String title;

  /// Trailing controls (sign out, refresh …). Kept optional so a bare screen
  /// passes only a title.
  final List<Widget>? actions;

  /// Set to false on screens that must not be navigated back from — e.g. the
  /// invite-code screen, whose only way onward is the primary action.
  final bool showBack;

  /// Overrides the themed fill. Pass `Colors.transparent` to let a scaffold
  /// background show through; when set, the scroll-under tint is disabled too so
  /// the colour stays exactly what was asked for.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final canPop = showBack && Navigator.of(context).canPop();
    final backgroundColor = this.backgroundColor;

    return AppBar(
      automaticallyImplyLeading: false,
      leading: canPop
          ? DvIconButton.svg(
              Assets.icons.chevronLeft,
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: () => Navigator.of(context).maybePop(),
            )
          : null,
      title: Text(title, style: context.textTheme.titleLarge),
      actions: actions,
      backgroundColor: backgroundColor,
      elevation: backgroundColor == null ? null : 0,
      scrolledUnderElevation: backgroundColor == null ? null : 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
