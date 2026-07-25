import 'package:dvir/app/routes.dart';
import 'package:dvir/features/Auth/domain/models/app_user.dart';
import 'package:dvir/features/Onboarding/domain/models/scope_membership.dart';
import 'package:dvir/features/Shared/domain/types/member_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Where to send a visitor, and why. The reason is carried for the log: with
/// two inputs and four member statuses feeding one destination, "why did it
/// land me on PendingApproval" stops being obvious from the destination alone.
typedef RedirectDecision = ({String? target, String reason});

/// Decides navigation from auth and membership state alone.
///
/// Kept out of `router.dart` and public so it can be tested directly: it is
/// pure, and it is where every access rule in the app is actually written.
RedirectDecision resolveRedirect({
  required AsyncValue<AppUser?> auth,
  required AsyncValue<ScopeMembership?> membership,
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

  if (auth.value == null) {
    return onAuthPage
        ? (target: null, reason: 'signed out, on an auth page')
        : (target: AppRoutes.login, reason: 'signed out');
  }

  // Signed in, but we don't yet know where they belong. Same reasoning as
  // above: guessing here would flash onboarding at an existing member.
  //
  // A *stale* value counts as unknown, hence no `hasValue` escape: Riverpod
  // hands back the previous value while the new one loads, and right after
  // sign-in that value is the signed-out `null` — deciding on it would send an
  // existing member to onboarding for as long as the fetch takes.
  if (membership.isLoading) {
    return location == AppRoutes.splash
        ? (target: null, reason: 'membership unresolved, already on splash')
        : (target: AppRoutes.splash, reason: 'membership unresolved');
  }

  final scope = membership.value;

  if (scope == null) {
    return onOnboardingPage
        ? (target: null, reason: 'belongs nowhere, onboarding in progress')
        : (target: AppRoutes.onboarding, reason: 'belongs nowhere');
  }

  // Everything that is not `active` — pending, rejected, blocked — means no
  // access to the scope's content, and the waiting screen is what explains
  // which of the three it is.
  if (scope.status != MemberStatus.active) {
    return location == AppRoutes.pending
        ? (target: null, reason: 'not approved, already waiting')
        : (target: AppRoutes.pending, reason: 'not approved (${scope.status})');
  }

  if (onAuthPage ||
      onOnboardingPage ||
      location == AppRoutes.splash ||
      location == AppRoutes.pending) {
    return (target: AppRoutes.home, reason: 'active member');
  }

  return (target: null, reason: 'active member, staying put');
}
