import 'package:dvir/core/logging/app_logger.dart';
import 'package:flutter/widgets.dart';

/// Logs navigation, so the log alone answers "which screen did the redirect
/// actually land on" — the thing that is invisible when auth state drives
/// routing instead of explicit `context.go` calls.
///
/// go_router names every page after its route path, so records read as
/// `/login → /home` without any extra wiring on the routes.
final class AppRouteObserver extends NavigatorObserver {
  AppRouteObserver();

  @override
  void didPush(Route<Object?> route, Route<Object?>? previousRoute) =>
      _log('push', route, from: previousRoute, to: route);

  @override
  void didPop(Route<Object?> route, Route<Object?>? previousRoute) =>
      _log('pop', route, from: route, to: previousRoute);

  @override
  void didReplace({Route<Object?>? newRoute, Route<Object?>? oldRoute}) =>
      _log('replace', newRoute, from: oldRoute, to: newRoute);

  @override
  void didRemove(Route<Object?> route, Route<Object?>? previousRoute) =>
      _log('remove', route, from: route, to: previousRoute);

  /// [subject] is the route that came or went, and what it is decides how the
  /// line is written.
  ///
  /// A menu, a dialog and a sheet are routes too, but they are not places the
  /// user went — reading them as navigation buried the screen changes this
  /// exists to make visible. They are logged a level down instead, where the
  /// printer gives them their own marker, and named after the widget that
  /// opened them rather than as one more `—`.
  void _log(
    String action,
    Route<Object?>? subject, {
    Route<Object?>? from,
    Route<Object?>? to,
  }) {
    if (subject is PageRoute) {
      appLogger.i('nav $action: ${_name(from)} → ${_name(to)}');
      return;
    }

    final opening = action == 'push' || action == 'replace';

    // The screen it covers, which is where it came from and where it goes back
    // to — the same one either way.
    final under = opening ? from : to;

    appLogger.d(
      'overlay ${opening ? 'open' : 'close'}: '
      '${_name(subject)} over ${_name(under)}',
    );
  }

  /// Falls back to the route's own type, which for an unnamed dialog is still
  /// more than a dash — `RawDialogRoute` at least says what kind of thing it
  /// was.
  static String _name(Route<Object?>? route) =>
      route?.settings.name ?? route?.runtimeType.toString() ?? '—';
}
