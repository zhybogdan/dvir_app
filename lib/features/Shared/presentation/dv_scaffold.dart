import 'package:dvir/features/Shared/presentation/dv_background.dart';
import 'package:material_ui/material_ui.dart';

/// Scaffold with a decorative layer behind its body, for every screen that
/// carries an app bar. The auth screens use [AuthScaffold] instead, which
/// centres a form with no app bar.
class DvScaffold extends StatelessWidget {
  const DvScaffold({
    required this.body,
    super.key,
    this.appBar,
    this.extendBodyBehindAppBar = false,
    this.scrollsUnderAppBar = false,
    this.background,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;

  /// What is painted behind the body, or nothing at all — which is the default
  /// because it is what a screen inside the app wants: a plain page is the
  /// ground its cards are read against, and anything painted on it competes
  /// with them.
  ///
  /// The onboarding passes [DvBackground]'s watermark itself. Defaulting the
  /// other way round would mean a new screen is decorated until someone
  /// notices — and the splash is why: a tone at 4% over the whole surface put
  /// its background half a shade off the frame the phone had just painted.
  final Widget? background;

  /// Extends the watermark under the app bar (pair with a transparent
  /// [DvAppBar]) so the background reads as one surface. The body is inset below
  /// the bar automatically, so callers don't have to reserve the space.
  final bool extendBodyBehindAppBar;

  /// Lets the body run up behind the bar, so a page that scrolls passes under
  /// its glass instead of ending at its edge.
  ///
  /// Unlike [extendBodyBehindAppBar] the body is not pushed down: the
  /// scrolling view inside it starts below the bar by adding
  /// `MediaQuery.paddingOf(context).top` to its own padding, which the
  /// scaffold sets to the bar's height plus the status bar.
  final bool scrollsUnderAppBar;

  @override
  Widget build(BuildContext context) {
    final appBar = this.appBar;
    final background = this.background;

    // When the body sits under the bar, reserve the bar's height plus the
    // status bar so content still starts just below it.
    final content = extendBodyBehindAppBar && appBar != null
        ? Padding(
            padding: EdgeInsets.only(top: appBar.preferredSize.height),
            child: SafeArea(child: body),
          )
        : body;

    return Scaffold(
      appBar: appBar,
      extendBodyBehindAppBar: extendBodyBehindAppBar || scrollsUnderAppBar,
      // No background, no Stack: a screen with nothing behind it should not
      // pay for the layer, and an empty one still composites.
      body: background == null
          ? content
          : Stack(
              children: [
                Positioned.fill(child: background),
                Positioned.fill(child: content),
              ],
            ),
    );
  }
}
