import 'dart:async';

import 'package:dvir/app/theme.dart';
import 'package:dvir/core/error/failure_l10n.dart';
import 'package:dvir/core/extensions/build_context_x.dart';
import 'package:dvir/features/Home/application/my_scopes_controller.dart';
import 'package:dvir/features/Shared/presentation/dv_app_tile.dart';
import 'package:dvir/features/Shared/presentation/dv_error_view.dart';
import 'package:dvir/features/Shared/presentation/dv_scaffold.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Held while the router works out where the visitor belongs — on a cold start,
/// and again after signing in while the scope list loads.
///
/// Not an opening of its own: `flutter_native_splash` has already painted this
/// picture — the scheme's surface and the tile at 72, centred — before Flutter
/// was running. This is the second half of it, and the whole job here is that
/// the handover not be visible. So no watermark (the background is literally
/// the colour the phone already painted) and nothing that moves the tile off
/// the centre it was drawn on.
///
/// It also has to offer a way out. The router holds a signed-in user here until
/// it knows their scopes, so a failed load — a dead connection, a sleeping
/// project — would otherwise be a spinner with no end and no button.
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final error = ref.watch(myScopesProvider).error;

    return DvScaffold(
      body: error == null
          ? const _Waiting()
          : Center(
              child: DvErrorView(
                message: errorMessage(error, AppLocalizations.of(context)),
                onRetry: () => ref.invalidate(myScopesProvider),
              ),
            ),
    );
  }
}

class _Waiting extends StatelessWidget {
  const _Waiting();

  /// What the native frame draws, and therefore not a free choice.
  static const double _tile = 72;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    // The name hangs off the tile rather than sharing a column with it: in a
    // column, everything added underneath lifts the tile, and the tile is the
    // one thing on this screen that must not move.
    builder: (context, constraints) => Stack(
      children: [
        const Center(child: DvAppTile(size: _tile)),
        Positioned(
          top: constraints.maxHeight / 2 + _tile / 2 + AppSpacing.md,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context).appTitle,
                style: context.textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.xl),
              const _Spinner(),
            ],
          ),
        ),
      ],
    ),
  );
}

/// The spinner, once the wait outlives the eye.
///
/// A separate state rather than a part of this screen: on the build where the
/// database is a file on the same phone there is nothing to wait for, and a
/// spinner shown for two frames says "loading" about something that never
/// loaded. Below the name and last in the column, so arriving moves nothing.
class _Spinner extends StatefulWidget {
  const _Spinner();

  @override
  State<_Spinner> createState() => _SpinnerState();
}

class _SpinnerState extends State<_Spinner> {
  /// Long enough that a start which is simply fast never shows one, short
  /// enough that a real round trip is not silent.
  static const Duration _patience = Duration(milliseconds: 600);

  Timer? _timer;
  bool _waiting = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(_patience, () => setState(() => _waiting = true));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
    opacity: _waiting ? 1 : 0,
    duration: const Duration(milliseconds: 200),
    child: const SizedBox.square(
      dimension: AppSpacing.lg,
      child: CircularProgressIndicator(strokeWidth: 2),
    ),
  );
}
