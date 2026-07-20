import 'package:dvir/app/routes.dart';
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
    redirect: (context, state) {
      final auth = ref.read(authStateProvider);
      final loc = state.matchedLocation;

      // Until the first auth emission arrives we cannot decide — hold the
      // splash instead of flashing the login screen at a signed-in user.
      if (auth.isLoading && !auth.hasValue) {
        return loc == AppRoutes.splash ? null : AppRoutes.splash;
      }

      final loggedIn = auth.value != null;
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
