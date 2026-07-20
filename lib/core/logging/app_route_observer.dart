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
      _log('push', from: previousRoute, to: route);

  @override
  void didPop(Route<Object?> route, Route<Object?>? previousRoute) =>
      _log('pop', from: route, to: previousRoute);

  @override
  void didReplace({Route<Object?>? newRoute, Route<Object?>? oldRoute}) =>
      _log('replace', from: oldRoute, to: newRoute);

  @override
  void didRemove(Route<Object?> route, Route<Object?>? previousRoute) =>
      _log('remove', from: route, to: previousRoute);

  void _log(String action, {Route<Object?>? from, Route<Object?>? to}) =>
      appLogger.i('nav $action: ${_name(from)} → ${_name(to)}');

  static String _name(Route<Object?>? route) => route?.settings.name ?? '—';
}
