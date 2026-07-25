import 'package:dvir/core/error/failure_l10n.dart';
import 'package:dvir/core/error/failures.dart';
import 'package:dvir/core/notifications/toast_controller.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AsyncValueX<T> on AsyncValue<T> {
  /// Shows an error toast if this value settled into an error; does nothing
  /// while loading or on success.
  ///
  /// Every form screen needs the same "action failed → toast" reaction, so the
  /// guard and the wording live here instead of in each screen's `build`. The
  /// [Failure] → text mapping stays in this presentation-side extension (it
  /// needs `l10n`); the controller only ever sees a resolved string. Anything
  /// that is not a [Failure] degrades to the generic message — a raw
  /// `toString()` would leak backend English into the UI.
  void showFailure(BuildContext context, WidgetRef ref) {
    final error = this.error;
    if (isLoading || error == null) return;

    final l10n = AppLocalizations.of(context);

    ref.read(toastControllerProvider.notifier).error(errorMessage(error, l10n));
  }
}
