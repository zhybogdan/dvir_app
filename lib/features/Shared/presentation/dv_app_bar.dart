import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Shared/presentation/dv_icon.dart';
import 'package:dvir/gen/assets.gen.dart';
import 'package:flutter/material.dart';

/// Shared app bar so screens declare a title, not an [AppBar].
///
/// Thin on purpose: colours, alignment and elevation come from
/// `appBarTheme` (see `AppTheme`). This fixes the title style, the back button
/// and the contract every screen shares, so the whole app changes from one
/// place.
class DvAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DvAppBar({required this.title, super.key, this.actions});

  final String title;

  /// Trailing controls (sign out, refresh …). Kept optional so a bare screen
  /// passes only a title.
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    return AppBar(
      automaticallyImplyLeading: false,
      leading: canPop ? const _BackButton() : null,
      title: Text(title, style: context.textTheme.titleLarge),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Themed back control built on the shared chevron icon.
class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).maybePop(),
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      icon: DvIcon(Assets.icons.chevronLeft),
    );
  }
}
