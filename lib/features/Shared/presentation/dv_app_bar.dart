import 'package:dvir/app/icons.dart';
import 'package:dvir/app/theme.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Shared/presentation/dv_icon_button.dart';
import 'package:material_ui/material_ui.dart';

/// Shared app bar so screens declare a title, not an [AppBar].
///
/// Thin on purpose: colours and alignment come from `appBarTheme` (see
/// `AppTheme`). This fixes the title style, the back button and the contract
/// every screen shares, so the whole app changes from one place.
///
/// Material's scrolled-under tint is off everywhere: it turned the whole bar
/// grey the moment a list moved, which read as a fault rather than as a sign.
class DvAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DvAppBar({
    required this.title,
    super.key,
    this.actions,
    this.showBack = true,
    this.backgroundColor,
    this.glass = false,
  });

  final String title;

  /// Trailing controls (sign out, refresh …). Kept optional so a bare screen
  /// passes only a title.
  final List<Widget>? actions;

  /// Set to false on screens that must not be navigated back from — e.g. the
  /// invite-code screen, whose only way onward is the primary action.
  final bool showBack;

  /// Overrides the themed fill. Pass `Colors.transparent` to let a scaffold
  /// background show through, exactly that colour and nothing over it.
  final Color? backgroundColor;

  /// Frosted glass that shows once the page has scrolled under the bar, for a
  /// page that does — pair with `DvScaffold.scrollsUnderAppBar`.
  ///
  /// Only then, and not always: a blur at rest pulls in whatever stands just
  /// below the bar's edge, and the heading there turned into a grey smudge
  /// over a page that had not moved.
  final bool glass;

  @override
  Widget build(BuildContext context) {
    final canPop = showBack && Navigator.of(context).canPop();
    final glass = this.glass;
    final backgroundColor = glass ? Colors.transparent : this.backgroundColor;

    return AppBar(
      automaticallyImplyLeading: false,
      leading: canPop
          ? DvIconButton(
              icon: AppIcons.back,
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: () => Navigator.of(context).maybePop(),
            )
          : null,
      title: Text(title, style: context.textTheme.titleLarge),
      actions: actions,
      backgroundColor: backgroundColor,
      elevation: backgroundColor == null ? null : 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: glass ? const _Glass() : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// [AppGlass] over the bar, faded in while the page is scrolled under it.
///
/// Listens the way [AppBar] does for its own tint — to the scaffold's
/// [ScrollNotificationObserver] — because the flexible space is not told
/// whether the bar is scrolled under.
class _Glass extends StatefulWidget {
  const _Glass();

  @override
  State<_Glass> createState() => _GlassState();
}

class _GlassState extends State<_Glass> {
  ScrollNotificationObserverState? _observer;
  bool _scrolledUnder = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _observer?.removeListener(_onScroll);
    _observer = ScrollNotificationObserver.maybeOf(context);
    _observer?.addListener(_onScroll);
  }

  @override
  void dispose() {
    _observer?.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll(ScrollNotification notification) {
    if (notification is! ScrollUpdateNotification) return;
    if (!defaultScrollNotificationPredicate(notification)) return;

    final metrics = notification.metrics;
    final scrolledUnder = switch (metrics.axisDirection) {
      AxisDirection.down => metrics.extentBefore > 0,
      AxisDirection.up => metrics.extentAfter > 0,
      _ => _scrolledUnder,
    };
    if (scrolledUnder != _scrolledUnder) {
      setState(() => _scrolledUnder = scrolledUnder);
    }
  }

  // Expanded by hand: the bar lays this out in a stack that passes its
  // constraints through loose, and an empty box under loose constraints is
  // zero high.
  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;

    return SizedBox.expand(
      child: AnimatedOpacity(
        opacity: _scrolledUnder ? 1 : 0,
        duration: const Duration(milliseconds: 200),
        child: ClipRect(
          child: BackdropFilter(
            filter: AppGlass.blur,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppGlass.barFill(scheme),
                border: Border(
                  bottom: BorderSide(color: scheme.outlineVariant),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
