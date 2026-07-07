import 'dart:async';

import 'package:dvir/app/routes.dart';
import 'package:dvir/core/config/supabase_providers.dart';
import 'package:dvir/features/auth/presentation/screens/login_screen.dart';
import 'package:dvir/features/auth/presentation/screens/register_screen.dart';
import 'package:dvir/features/auth/presentation/screens/splash_screen.dart';
import 'package:dvir/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

/// Root navigation with auth-based redirects.
///
/// For now it's a two-state guard: signed out vs signed in. Community
/// onboarding (auth but no community → onboarding, pending approval, etc.) is
/// layered on in Phase 3 per the roadmap.
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final supabase = ref.watch(supabaseClientProvider);

  final refresh = GoRouterRefreshStream(supabase.auth.onAuthStateChange);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refresh,
    redirect: (context, state) {
      final loggedIn = supabase.auth.currentSession != null;
      final loc = state.matchedLocation;
      final onAuthPage = loc == AppRoutes.login || loc == AppRoutes.register;

      if (!loggedIn) return onAuthPage ? null : AppRoutes.login;
      if (onAuthPage || loc == AppRoutes.splash) return AppRoutes.home;
      return null;
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

/// Adapts a [Stream] to a [Listenable] so GoRouter re-runs `redirect` whenever
/// the auth state emits.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
