import 'package:dvir/core/error/failure_l10n.dart';
import 'package:dvir/core/error/failures.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AsyncValueX<T> on AsyncValue<T> {
  /// Shows a snackbar if this value settled into an error; does nothing while
  /// loading or on success.
  ///
  /// Every form screen needs the same "action failed → snackbar" reaction, so
  /// the guard and the wording live here instead of in each screen's `build`.
  /// Anything that is not a [Failure] degrades to the generic message — a raw
  /// `toString()` would leak backend English into the UI.
  void showFailure(BuildContext context) {
    final error = this.error;
    if (isLoading || error == null) return;

    final l10n = AppLocalizations.of(context);
    final message = error is Failure ? error.message(l10n) : l10n.errorUnknown;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
