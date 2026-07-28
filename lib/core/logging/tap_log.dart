import 'package:dvir/core/logging/app_logger.dart';
import 'package:flutter/foundation.dart';

/// Wraps a tap handler so the press is in the log before it runs.
///
/// The log already answers where the user went and what the app asked the
/// server; the missing line was between them — which control was actually
/// pressed. "Saved nothing and said nothing" reads very differently once it is
/// known whether the button fired at all.
///
/// Kept to the shared `Dv*` controls, whose labels are localized constants.
/// Rows of lists are deliberately not logged: their titles are people's names,
/// and a tap on one shows up as a `nav push` anyway.
///
/// A null [onPressed] stays null, so a disabled control is not quietly given a
/// handler that does nothing.
VoidCallback? loggedTap(String label, VoidCallback? onPressed) {
  if (onPressed == null) return null;

  return () {
    appLogger.d('tap: $label');
    onPressed();
  };
}
