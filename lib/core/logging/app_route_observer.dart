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

  /// [subject] is the route that came or went; only screens are logged.
  ///
  /// A menu, a dialog and a bottom sheet are routes too, and each one pushed
  /// and popped is two nameless `—` lines. They buried the screen changes this
  /// exists to make visible.
  void _log(
    String action,
    Route<Object?>? subject, {
    Route<Object?>? from,
    Route<Object?>? to,
  }) {
    if (subject is! PageRoute) return;

    appLogger.i('nav $action: ${_name(from)} → ${_name(to)}');
  }

  static String _name(Route<Object?>? route) => route?.settings.name ?? '—';
}
