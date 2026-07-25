import 'dart:async';

import 'package:dvir/app/redirect.dart';
import 'package:dvir/app/routes.dart';
import 'package:dvir/features/Auth/domain/models/app_user.dart';
import 'package:dvir/features/Community/domain/models/community_membership.dart';
import 'package:dvir/features/Community/domain/types/member_role.dart';
import 'package:dvir/features/Onboarding/domain/models/scope_membership.dart';
import 'package:dvir/features/Shared/domain/types/member_status.dart';
import 'package:dvir/features/Units/domain/models/unit_membership.dart';
import 'package:dvir/features/Units/domain/types/unit_role.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _user = AppUser(id: 'u1', email: 'resident@example.com');

const _signedIn = AsyncData<AppUser?>(_user);
const _signedOut = AsyncData<AppUser?>(null);
const _authPending = AsyncLoading<AppUser?>();

const _nowhere = AsyncData<ScopeMembership?>(null);
const _membershipPending = AsyncLoading<ScopeMembership?>();

AsyncData<ScopeMembership?> _inCommunity(MemberStatus status) =>
    AsyncData<ScopeMembership?>(
      ScopeMembership.community(
        CommunityMembership(
          id: 'm1',
          communityId: 'c1',
          userId: _user.id,
          role: MemberRole.member,
          status: status,
        ),
      ),
    );

AsyncData<ScopeMembership?> _inUnit(MemberStatus status) =>
    AsyncData<ScopeMembership?>(
      ScopeMembership.unit(
        UnitMembership(
          id: 'm2',
          unitId: 'u1',
          userId: _user.id,
          role: UnitRole.family,
          status: status,
        ),
      ),
    );

/// A membership provider caught mid-reload: loading, with the value it is
/// about to replace still readable underneath.
///
/// Driven through a real container because the state cannot be written by hand
/// — `copyWithPrevious` is Riverpod-internal.
Future<AsyncValue<ScopeMembership?>> _reloadingMembership() async {
  var pending = Completer<ScopeMembership?>()..complete(null);
  final provider = FutureProvider<ScopeMembership?>((ref) => pending.future);

  final container = ProviderContainer.test();
  container.listen(provider, (previous, next) {});
  await container.read(provider.future);

  // Swapped before invalidating, so the rebuild picks up a future that stays
  // unresolved and the provider is still loading when it is read.
  pending = Completer<ScopeMembership?>();
  container.invalidate(provider);

  return container.read(provider);
}

void main() {
  group('resolveRedirect while auth is unresolved', () {
    test('holds the splash instead of flashing login', () {
      final decision = resolveRedirect(
        auth: _authPending,
        membership: _membershipPending,
        location: AppRoutes.home,
      );

      expect(decision.target, AppRoutes.splash);
    });

    test('stays put when already on the splash', () {
      final decision = resolveRedirect(
        auth: _authPending,
        membership: _membershipPending,
        location: AppRoutes.splash,
      );

      expect(decision.target, isNull);
    });
  });

  group('resolveRedirect when signed out', () {
    test('sends a visitor to login', () {
      final decision = resolveRedirect(
        auth: _signedOut,
        membership: _nowhere,
        location: AppRoutes.home,
      );

      expect(decision.target, AppRoutes.login);
    });

    test('leaves the register screen alone', () {
      final decision = resolveRedirect(
        auth: _signedOut,
        membership: _nowhere,
        location: AppRoutes.register,
      );

      expect(decision.target, isNull);
    });
  });

  group('resolveRedirect when the user belongs nowhere', () {
    test('sends them to onboarding', () {
      final decision = resolveRedirect(
        auth: _signedIn,
        membership: _nowhere,
        location: AppRoutes.home,
      );

      expect(decision.target, AppRoutes.onboarding);
    });

    // The sub-screens are onboarding too — matching the prefix is what keeps
    // them reachable.
    test('lets them move between the onboarding screens', () {
      for (final location in [
        AppRoutes.onboarding,
        AppRoutes.onboardingCommunity,
        AppRoutes.onboardingUnit,
        AppRoutes.onboardingJoin,
      ]) {
        final decision = resolveRedirect(
          auth: _signedIn,
          membership: _nowhere,
          location: location,
        );

        expect(decision.target, isNull, reason: 'should stay on $location');
      }
    });

    test('waits on the splash while membership is still unknown', () {
      final decision = resolveRedirect(
        auth: _signedIn,
        membership: _membershipPending,
        location: AppRoutes.home,
      );

      expect(decision.target, AppRoutes.splash);
    });

    test('waits rather than trusting the value a reload is replacing', () async {
      // What signing back in looks like: the membership provider is refetching
      // and Riverpod still reports the signed-out `null` underneath. Reading it
      // as "belongs nowhere" put an existing member on onboarding until the
      // fetch landed.
      final reloading = await _reloadingMembership();
      expect(
        reloading.hasValue,
        isTrue,
        reason: 'the fixture must carry the stale value it is replacing',
      );

      final decision = resolveRedirect(
        auth: _signedIn,
        membership: reloading,
        location: AppRoutes.login,
      );

      expect(decision.target, AppRoutes.splash);
    });
  });

  group('resolveRedirect for a member without access', () {
    test('sends every unapproved status to the waiting screen', () {
      for (final status in [
        MemberStatus.pending,
        MemberStatus.rejected,
        MemberStatus.blocked,
      ]) {
        final decision = resolveRedirect(
          auth: _signedIn,
          membership: _inCommunity(status),
          location: AppRoutes.home,
        );

        expect(decision.target, AppRoutes.pending, reason: 'status $status');
      }
    });

    test('treats an object the same way as a community', () {
      final decision = resolveRedirect(
        auth: _signedIn,
        membership: _inUnit(MemberStatus.pending),
        location: AppRoutes.home,
      );

      expect(decision.target, AppRoutes.pending);
    });

    test('does not bounce them off the waiting screen', () {
      final decision = resolveRedirect(
        auth: _signedIn,
        membership: _inCommunity(MemberStatus.pending),
        location: AppRoutes.pending,
      );

      expect(decision.target, isNull);
    });
  });

  group('resolveRedirect for an active member', () {
    test('sends them home from the splash, auth and onboarding screens', () {
      for (final location in [
        AppRoutes.splash,
        AppRoutes.login,
        AppRoutes.onboarding,
        AppRoutes.onboardingJoin,
        AppRoutes.pending,
      ]) {
        final decision = resolveRedirect(
          auth: _signedIn,
          membership: _inCommunity(MemberStatus.active),
          location: location,
        );

        expect(decision.target, AppRoutes.home, reason: 'from $location');
      }
    });

    test('leaves them wherever they already are inside the app', () {
      final decision = resolveRedirect(
        auth: _signedIn,
        membership: _inUnit(MemberStatus.active),
        location: AppRoutes.home,
      );

      expect(decision.target, isNull);
    });
  });
}
