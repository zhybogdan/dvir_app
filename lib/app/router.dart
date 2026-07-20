import 'package:dvir/app/routes.dart';
import 'package:dvir/core/logging/app_logger.dart';
import 'package:dvir/core/logging/app_route_observer.dart';
import 'package:dvir/features/Auth/application/auth_controller.dart';
import 'package:dvir/features/Auth/domain/models/app_user.dart';
import 'package:dvir/features/Auth/presentation/screens/login_screen.dart';
import 'package:dvir/features/Auth/presentation/screens/register_screen.dart';
import 'package:dvir/features/Auth/presentation/screens/splash_screen.dart';
import 'package:dvir/features/Home/presentation/screens/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

/// Root navigation with auth-based redirects.
///
/// Auth state comes from [authStateProvider] (the repository), never from
/// Supabase directly — the router stays on the app side of the data boundary
/// and there is a single subscription behind the whole app.
///
/// For now it's a two-state guard: signed out vs signed in. Community
/// onboarding (auth but no community → onboarding, pending approval, etc.) is
/// layered on in Phase 3 per the roadmap.
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  // `notifyListeners` on every auth emission is what makes GoRouter re-run
  // `redirect`; watching the provider here would rebuild the router itself.
  final refresh = ValueNotifier<int>(0);
  ref.onDispose(refresh.dispose);

  final subscription = ref.listen<AsyncValue<AppUser?>>(
    authStateProvider,
    (previous, next) => refresh.value++,
    fireImmediately: true,
  );
  ref.onDispose(subscription.close);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refresh,
    observers: [AppRouteObserver()],
    redirect: (context, state) {
      final location = state.matchedLocation;
      final decision = _resolveRedirect(
        auth: ref.read(authStateProvider),
        location: location,
      );
      final target = decision.target;

      // Only decisions that actually move the user: `redirect` runs on every
      // router event and mostly returns null, which would bury the log.
      if (target != null) {
        appLogger.i('redirect $location → $target (${decision.reason})');
      }

      return target;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}

/// Where an auth state should send a visitor of [location], and why.
///
/// The reason is carried purely for the log: today the destination explains
/// itself, but Phase 3 layers community membership and roles on top of this,
/// and then "why did it land me on PendingApproval" stops being obvious.
///
/// Pure on purpose — it takes state in and returns a decision, touching no
/// router internals.
({String? target, String reason}) _resolveRedirect({
  required AsyncValue<AppUser?> auth,
  required String location,
}) {
  final onAuthPage =
      location == AppRoutes.login || location == AppRoutes.register;

  // Until the first auth emission arrives we cannot decide — hold the splash
  // instead of flashing the login screen at an already signed-in user.
  if (auth.isLoading && !auth.hasValue) {
    return location == AppRoutes.splash
        ? (target: null, reason: 'auth unresolved, already on splash')
        : (target: AppRoutes.splash, reason: 'auth unresolved');
  }

  if (auth.value == null) {
    return onAuthPage
        ? (target: null, reason: 'signed out, on an auth page')
        : (target: AppRoutes.login, reason: 'signed out');
  }

  if (onAuthPage || location == AppRoutes.splash) {
    return (target: AppRoutes.home, reason: 'signed in');
  }

  return (target: null, reason: 'signed in, staying put');
}
