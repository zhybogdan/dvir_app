import 'package:dvir/app/app_shell.dart';
import 'package:dvir/app/redirect.dart';
import 'package:dvir/app/routes.dart';
import 'package:dvir/core/config/app_capabilities.dart';
import 'package:dvir/core/logging/app_logger.dart';
import 'package:dvir/core/logging/app_route_observer.dart';
import 'package:dvir/features/Auth/application/auth_controller.dart';
import 'package:dvir/features/Auth/domain/models/app_user.dart';
import 'package:dvir/features/Auth/presentation/screens/login_screen.dart';
import 'package:dvir/features/Auth/presentation/screens/register_screen.dart';
import 'package:dvir/features/Contacts/presentation/screens/all_contacts_screen.dart';
import 'package:dvir/features/Contacts/presentation/screens/contacts_screen.dart';
import 'package:dvir/features/Documents/presentation/screens/all_documents_screen.dart';
import 'package:dvir/features/Documents/presentation/screens/documents_screen.dart';
import 'package:dvir/features/Home/application/my_scopes_controller.dart';
import 'package:dvir/features/Home/presentation/screens/scopes_screen.dart';
import 'package:dvir/features/Onboarding/presentation/screens/create_community_screen.dart';
import 'package:dvir/features/Onboarding/presentation/screens/join_scope_screen.dart';
import 'package:dvir/features/Onboarding/presentation/screens/onboarding_choice_screen.dart';
import 'package:dvir/features/Onboarding/presentation/screens/pending_approval_screen.dart';
import 'package:dvir/features/Onboarding/presentation/screens/scope_created_screen.dart';
import 'package:dvir/features/Profile/presentation/screens/profile_screen.dart';
import 'package:dvir/features/Shared/presentation/splash_screen.dart';
import 'package:dvir/features/Units/presentation/screens/unit_attributes_screen.dart';
import 'package:dvir/features/Units/presentation/screens/unit_form_screen.dart';
import 'package:dvir/features/Units/presentation/screens/unit_hub_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

/// The pair every redirect decision is made from.
typedef NavigationState = ({
  AsyncValue<AppUser?> auth,
  AsyncValue<MyScopes?> scopes,
});

/// Auth and scopes read as one value, so a redirect never sees one of them
/// ahead of the other.
///
/// Watching both here puts them in a single dependency node, and `myScopes`
/// watches auth itself — so Riverpod recomputes it before this provider and the
/// pair is always consistent. Subscribing to the two separately let an auth
/// emission reach the router while the scope list still held the previous
/// session's answer, and a signed-in member was briefly ruled to belong
/// nowhere.
@Riverpod(keepAlive: true)
NavigationState navigationState(Ref ref) =>
    (auth: ref.watch(authStateProvider), scopes: ref.watch(myScopesProvider));

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

  // The navigator above the tabs. Forms are pushed onto it rather than onto
  // a tab's own, so the island is not under a form that has one way out.
  final rootNavigatorKey = GlobalKey<NavigatorState>();

  final subscription = ref.listen<NavigationState>(
    navigationStateProvider,
    (previous, next) => refresh.value++,
    fireImmediately: true,
  );
  ref.onDispose(subscription.close);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: refresh,
    observers: [AppRouteObserver()],
    redirect: (context, state) {
      final location = state.matchedLocation;
      final navigation = ref.read(navigationStateProvider);
      final decision = resolveRedirect(
        auth: navigation.auth,
        scopes: navigation.scopes,
        location: location,
        people: ref.read(appCapabilitiesProvider).people,
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
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingChoiceScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingCommunity,
        builder: (context, state) => const CreateCommunityScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingCommunitySuccess,
        builder: (context, state) => const ScopeCreatedScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingUnit,
        builder: (context, state) => const UnitFormScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingUnitSuccess,
        builder: (context, state) => const ScopeCreatedScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingJoin,
        builder: (context, state) => const JoinScopeScreen(),
      ),
      GoRoute(
        path: AppRoutes.pending,
        builder: (context, state) => const PendingApprovalScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          // Objects, and everything opened from one. The object's screens sit
          // in this branch rather than above the shell, so the island stays
          // under them and the tab remembers which house was open.
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const ScopesScreen(),
              ),
              GoRoute(
                path: AppRoutes.unit,
                builder: (context, state) {
                  final unitId = state.pathParameters['unitId'];

                  // Only reachable through a hand-typed link: the path declares the
                  // parameter, so the router fills it in for every real navigation.
                  return unitId == null
                      ? const SplashScreen()
                      : UnitHubScreen(unitId: unitId);
                },
              ),
              GoRoute(
                path: AppRoutes.unitAttributes,
                builder: (context, state) {
                  final unitId = state.pathParameters['unitId'];

                  return unitId == null
                      ? const SplashScreen()
                      : UnitAttributesScreen(unitId: unitId);
                },
              ),
              GoRoute(
                path: AppRoutes.unitDocuments,
                builder: (context, state) {
                  final unitId = state.pathParameters['unitId'];

                  return unitId == null
                      ? const SplashScreen()
                      : UnitDocumentsScreen(unitId: unitId);
                },
              ),
              GoRoute(
                path: AppRoutes.unitContacts,
                builder: (context, state) {
                  final unitId = state.pathParameters['unitId'];

                  return unitId == null
                      ? const SplashScreen()
                      : UnitContactsScreen(unitId: unitId);
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.documents,
                builder: (context, state) => const AllDocumentsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.contacts,
                builder: (context, state) => const AllContactsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoutes.unitEdit,
        builder: (context, state) {
          final unitId = state.pathParameters['unitId'];

          return unitId == null
              ? const SplashScreen()
              : UnitEditScreen(unitId: unitId);
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoutes.unitAdd,
        builder: (context, state) {
          final unitId = state.pathParameters['unitId'];

          return unitId == null
              ? const SplashScreen()
              : UnitFormScreen(parentId: unitId);
        },
      ),
    ],
  );
}
