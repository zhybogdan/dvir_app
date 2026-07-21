import 'package:dvir/features/Shared/presentation/dv_background.dart';
import 'package:flutter/material.dart';

/// Scaffold with the shared watermark behind its body, for the pre-app screens
/// that carry an app bar (onboarding). The auth screens use [AuthScaffold]
/// instead, which centres a form with no app bar.
class DvScaffold extends StatelessWidget {
  const DvScaffold({
    required this.body,
    super.key,
    this.appBar,
    this.extendBodyBehindAppBar = false,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;

  /// Extends the watermark under the app bar (pair with a transparent
  /// [DvAppBar]) so the background reads as one surface. The body is inset below
  /// the bar automatically, so callers don't have to reserve the space.
  final bool extendBodyBehindAppBar;

  @override
  Widget build(BuildContext context) {
    final appBar = this.appBar;

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
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      body: Stack(
        children: [
          const Positioned.fill(child: DvBackground()),
          Positioned.fill(child: content),
        ],
      ),
    );
  }
}
