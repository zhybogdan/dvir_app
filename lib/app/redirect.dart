import 'package:dvir/app/routes.dart';
import 'package:dvir/features/Auth/domain/models/app_user.dart';
import 'package:dvir/features/Home/application/my_scopes_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Where to send a visitor, and why. The reason is carried for the log: with
/// two inputs and four member statuses feeding one destination, "why did it
/// land me on PendingApproval" stops being obvious from the destination alone.
typedef RedirectDecision = ({String? target, String reason});

/// Decides navigation from auth and scope membership alone.
///
/// Kept out of `router.dart` and public so it can be tested directly: it is
/// pure, and it is where every access rule in the app is actually written.
///
/// The question it asks about scopes is "does this user belong *anywhere* with
/// access", never "which scope are they in". A person can own a house, rent a
/// flat and sit on an ОСББ board at once; picking one of those to route by is
/// what used to strand a house owner on the waiting screen because a community
/// they had applied to was still deciding.
RedirectDecision resolveRedirect({
  required AsyncValue<AppUser?> auth,
  required AsyncValue<MyScopes?> scopes,
  required String location,
}) {
  final onAuthPage =
      location == AppRoutes.login || location == AppRoutes.register;
  // A prefix rather than an equality check: the create and join screens are
  // part of onboarding, and matching only `/onboarding` would bounce a user
  // off them the moment they tapped through.
  final onOnboardingPage = location.startsWith(AppRoutes.onboarding);

  // Until the first auth emission arrives we cannot decide — hold the splash
  // instead of flashing the login screen at an already signed-in user.
  if (auth.isLoading && !auth.hasValue) {
    return location == AppRoutes.splash
        ? (target: null, reason: 'auth unresolved, already on splash')
        : (target: AppRoutes.splash, reason: 'auth unresolved');
  }

  final user = auth.value;

  if (user == null) {
    return onAuthPage
        ? (target: null, reason: 'signed out, on an auth page')
        : (target: AppRoutes.login, reason: 'signed out');
  }

  final known = scopes.value;

  // Signed in, but what we hold is not this user's answer: either nothing has
  // arrived yet, or the value underneath a reload still belongs to the previous
  // session. Guessing here flashed onboarding at an existing member.
  //
  // Comparing the owner rather than checking `isLoading` is what keeps an
  // ordinary refresh — someone pulling the scope list down — from throwing them
  // back to the splash: the data is stale, but it is still theirs.
  if (known == null || known.userId != user.id) {
    return location == AppRoutes.splash
        ? (target: null, reason: 'scopes unresolved, already on splash')
        : (target: AppRoutes.splash, reason: 'scopes unresolved');
  }

  if (known.scopes.isEmpty) {
    return onOnboardingPage
        ? (target: null, reason: 'belongs nowhere, onboarding in progress')
        : (target: AppRoutes.onboarding, reason: 'belongs nowhere');
  }

  // Belongs somewhere, but nowhere they are let into yet. Everything that is
  // not `active` — pending, rejected, blocked — means no access, and the
  // waiting screen is what explains which of the three it is.
  if (!known.scopes.any((scope) => scope.isActive)) {
    return location == AppRoutes.pending
        ? (target: null, reason: 'not approved anywhere, already waiting')
        : (target: AppRoutes.pending, reason: 'not approved anywhere');
  }

  // An active member may still walk into onboarding deliberately — that is how
  // a second scope is created or joined — so only the entry screens send them
  // home.
  if (onAuthPage ||
      location == AppRoutes.splash ||
      location == AppRoutes.pending) {
    return (target: AppRoutes.home, reason: 'active member');
  }

  return (target: null, reason: 'active member, staying put');
}
