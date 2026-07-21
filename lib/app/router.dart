import 'package:dvir/app/redirect.dart';
import 'package:dvir/app/routes.dart';
import 'package:dvir/core/logging/app_logger.dart';
import 'package:dvir/core/logging/app_route_observer.dart';
import 'package:dvir/features/Auth/application/auth_controller.dart';
import 'package:dvir/features/Auth/domain/models/app_user.dart';
import 'package:dvir/features/Auth/presentation/screens/login_screen.dart';
import 'package:dvir/features/Auth/presentation/screens/register_screen.dart';
import 'package:dvir/features/Auth/presentation/screens/splash_screen.dart';
import 'package:dvir/features/Community/domain/models/community.dart';
import 'package:dvir/features/Home/presentation/screens/home_screen.dart';
import 'package:dvir/features/Onboarding/application/membership_controller.dart';
import 'package:dvir/features/Onboarding/domain/models/scope_membership.dart';
import 'package:dvir/features/Onboarding/presentation/screens/community_created_screen.dart';
import 'package:dvir/features/Onboarding/presentation/screens/create_community_screen.dart';
import 'package:dvir/features/Onboarding/presentation/screens/create_unit_screen.dart';
import 'package:dvir/features/Onboarding/presentation/screens/join_scope_screen.dart';
import 'package:dvir/features/Onboarding/presentation/screens/onboarding_choice_screen.dart';
import 'package:dvir/features/Onboarding/presentation/screens/pending_approval_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

/// Root navigation with auth- and membership-based redirects.
///
/// Both inputs come from providers (the repositories), never from Supabase
/// directly — the router stays on the app side of the data boundary and there
/// is a single subscription each behind the whole app.
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  // `notifyListeners` on every emission is what makes GoRouter re-run
  // `redirect`; watching the providers here would rebuild the router itself.
  final refresh = ValueNotifier<int>(0);
  ref.onDispose(refresh.dispose);

  final authSubscription = ref.listen<AsyncValue<AppUser?>>(
    authStateProvider,
    (previous, next) => refresh.value++,
    fireImmediately: true,
  );
  ref.onDispose(authSubscription.close);

  final membershipSubscription = ref.listen<AsyncValue<ScopeMembership?>>(
    myMembershipProvider,
    (previous, next) => refresh.value++,
    fireImmediately: true,
  );
  ref.onDispose(membershipSubscription.close);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refresh,
    observers: [AppRouteObserver()],
    redirect: (context, state) {
      final location = state.matchedLocation;
      final decision = resolveRedirect(
        auth: ref.read(authStateProvider),
        membership: ref.read(myMembershipProvider),
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
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingChoiceScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingCommunity,
        builder: (context, state) => const CreateCommunityScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingCommunitySuccess,
        builder: (context, state) {
          final community = state.extra;
          return community is Community
              ? CommunityCreatedScreen(community: community)
              : const OnboardingChoiceScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.onboardingUnit,
        builder: (context, state) => const CreateUnitScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingJoin,
        builder: (context, state) => const JoinScopeScreen(),
      ),
      GoRoute(
        path: AppRoutes.pending,
        builder: (context, state) => const PendingApprovalScreen(),
      ),
    ],
  );
}

