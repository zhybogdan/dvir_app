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
