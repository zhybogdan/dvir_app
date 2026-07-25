import 'package:dvir/core/error/failure_l10n.dart';
import 'package:dvir/features/Shared/presentation/dv_error_view.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Renders the three states of an [AsyncValue] the same way everywhere.
///
/// Screens hand over their own [skeleton] — a placeholder shaped like the
/// content it stands in for reads far better than a spinner, and only the screen
/// knows that shape. Failures become a [DvErrorView] rather than a toast: a
/// screen with no content leaves the user nothing to act on once a toast slides
/// away.
///
/// A reload keeps the previous content on screen instead of dropping back to the
/// skeleton — that is `AsyncValue.when`'s default, and it stops a pull to
/// refresh from blanking the list.
class DvAsyncView<T> extends StatelessWidget {
  const DvAsyncView({
    required this.value,
    required this.builder,
    super.key,
    this.skeleton,
    this.onRetry,
  });

  final AsyncValue<T> value;
  final Widget Function(BuildContext context, T data) builder;

  /// Falls back to a spinner, for the odd screen with no shape worth faking.
  final Widget? skeleton;

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final skeleton = this.skeleton;

    return value.when(
      data: (data) => builder(context, data),
      loading: () =>
          skeleton ?? const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => DvErrorView(
        message: errorMessage(error, AppLocalizations.of(context)),
        onRetry: onRetry,
      ),
    );
  }
}
