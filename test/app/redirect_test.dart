import 'dart:async';

import 'package:dvir/app/redirect.dart';
import 'package:dvir/app/routes.dart';
import 'package:dvir/features/Auth/domain/models/app_user.dart';
import 'package:dvir/features/Community/domain/models/community_membership.dart';
import 'package:dvir/features/Community/domain/types/member_role.dart';
import 'package:dvir/features/Home/application/my_scopes_controller.dart';
import 'package:dvir/features/Home/domain/models/scope_summary.dart';
import 'package:dvir/features/Shared/domain/types/member_status.dart';
import 'package:dvir/features/Units/domain/models/unit_membership.dart';
import 'package:dvir/features/Units/domain/types/unit_role.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _user = AppUser(id: 'u1', email: 'resident@example.com');
const _otherUser = AppUser(id: 'u2', email: 'someone.else@example.com');

const _signedIn = AsyncData<AppUser?>(_user);
const _signedOut = AsyncData<AppUser?>(null);
const _authPending = AsyncLoading<AppUser?>();

const _scopesPending = AsyncLoading<MyScopes?>();
final _nowhere = _scopesOf(const []);

ScopeSummary _community(MemberStatus status) => ScopeSummary.community(
  membership: CommunityMembership(
    id: 'm1',
    communityId: 'c1',
    userId: _user.id,
    role: MemberRole.member,
    status: status,
  ),
);

ScopeSummary _unit(MemberStatus status) => ScopeSummary.unit(
  membership: UnitMembership(
    id: 'm2',
    unitId: 'u1',
    userId: _user.id,
    role: UnitRole.family,
    status: status,
  ),
);

AsyncData<MyScopes?> _scopesOf(List<ScopeSummary> scopes) =>
    AsyncData<MyScopes?>((userId: _user.id, scopes: scopes));

/// The scope provider caught mid-reload: loading, with the value it is about to
/// replace still readable underneath.
///
/// Driven through a real container because the state cannot be written by hand
/// — `copyWithPrevious` is Riverpod-internal.
Future<AsyncValue<MyScopes?>> _reloading(MyScopes previous) async {
  var pending = Completer<MyScopes?>()..complete(previous);
  final provider = FutureProvider<MyScopes?>((ref) => pending.future);

  final container = ProviderContainer.test();
  container.listen(provider, (previous, next) {});
  await container.read(provider.future);

  // Swapped before invalidating, so the rebuild picks up a future that stays
  // unresolved and the provider is still loading when it is read.
  pending = Completer<MyScopes?>();
  container.invalidate(provider);

  return container.read(provider);
}

void main() {
  group('resolveRedirect while auth is unresolved', () {
    test('holds the splash instead of flashing login', () {
      final decision = resolveRedirect(
        auth: _authPending,
        scopes: _scopesPending,
        location: AppRoutes.home,
      );

      expect(decision.target, AppRoutes.splash);
    });

    test('stays put when already on the splash', () {
      final decision = resolveRedirect(
        auth: _authPending,
        scopes: _scopesPending,
        location: AppRoutes.splash,
      );

      expect(decision.target, isNull);
    });
  });

  group('resolveRedirect when signed out', () {
    test('sends a visitor to login', () {
      final decision = resolveRedirect(
        auth: _signedOut,
        scopes: _nowhere,
        location: AppRoutes.home,
      );

      expect(decision.target, AppRoutes.login);
    });

    test('leaves the register screen alone', () {
      final decision = resolveRedirect(
        auth: _signedOut,
        scopes: _nowhere,
        location: AppRoutes.register,
      );

      expect(decision.target, isNull);
    });
  });

  group('resolveRedirect when the user belongs nowhere', () {
    test('sends them to onboarding', () {
      final decision = resolveRedirect(
        auth: _signedIn,
        scopes: _nowhere,
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
          scopes: _nowhere,
          location: location,
        );

        expect(decision.target, isNull, reason: 'should stay on $location');
      }
    });

    test('waits on the splash while the scope list is still unknown', () {
      final decision = resolveRedirect(
        auth: _signedIn,
        scopes: _scopesPending,
        location: AppRoutes.home,
      );

      expect(decision.target, AppRoutes.splash);
    });
  });

  group('resolveRedirect while a stale list is on screen', () {
    // What signing back in looks like: the list underneath still belongs to the
    // previous session. Reading it as this user's answer put them wherever the
    // last one belonged.
    test('waits rather than trusting the previous session', () async {
      final reloading = await _reloading((
        userId: _otherUser.id,
        scopes: [_community(MemberStatus.active)],
      ));

      final decision = resolveRedirect(
        auth: _signedIn,
        scopes: reloading,
        location: AppRoutes.home,
      );

      expect(decision.target, AppRoutes.splash);
    });

    // A refresh from the home screen is also a load with a stale value
    // underneath. Bouncing the user to the splash for it would make pulling the
    // list down feel like the app restarting.
    test('keeps deciding on a list that is merely refreshing', () async {
      final reloading = await _reloading((
        userId: _user.id,
        scopes: [_community(MemberStatus.active)],
      ));

      expect(
        reloading.hasValue,
        isTrue,
        reason: 'the fixture must carry the stale value it is replacing',
      );

      final decision = resolveRedirect(
        auth: _signedIn,
        scopes: reloading,
        location: AppRoutes.home,
      );

      expect(decision.target, isNull);
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
          scopes: _scopesOf([_community(status)]),
          location: AppRoutes.home,
        );

        expect(decision.target, AppRoutes.pending, reason: 'status $status');
      }
    });

    test('treats an object the same way as a community', () {
      final decision = resolveRedirect(
        auth: _signedIn,
        scopes: _scopesOf([_unit(MemberStatus.pending)]),
        location: AppRoutes.home,
      );

      expect(decision.target, AppRoutes.pending);
    });

    test('does not bounce them off the waiting screen', () {
      final decision = resolveRedirect(
        auth: _signedIn,
        scopes: _scopesOf([_community(MemberStatus.pending)]),
        location: AppRoutes.pending,
      );

      expect(decision.target, isNull);
    });

    // Waiting for one answer must not be a room with a single door: someone
    // who mistyped a code has to be able to start their own object instead.
    test('lets them into onboarding while they wait', () {
      for (final location in [
        AppRoutes.onboarding,
        AppRoutes.onboardingUnit,
        AppRoutes.onboardingJoin,
      ]) {
        final decision = resolveRedirect(
          auth: _signedIn,
          scopes: _scopesOf([_community(MemberStatus.pending)]),
          location: location,
        );

        expect(decision.target, isNull, reason: 'should stay on $location');
      }
    });
  });

  group('resolveRedirect for an active member', () {
    test('sends them home from the splash, auth and waiting screens', () {
      for (final location in [
        AppRoutes.splash,
        AppRoutes.login,
        AppRoutes.pending,
      ]) {
        final decision = resolveRedirect(
          auth: _signedIn,
          scopes: _scopesOf([_community(MemberStatus.active)]),
          location: location,
        );

        expect(decision.target, AppRoutes.home, reason: 'from $location');
      }
    });

    test('leaves them wherever they already are inside the app', () {
      final decision = resolveRedirect(
        auth: _signedIn,
        scopes: _scopesOf([_unit(MemberStatus.active)]),
        location: AppRoutes.home,
      );

      expect(decision.target, isNull);
    });

    // Adding a second scope means walking back into onboarding on purpose. The
    // old single-scope rule threw an active member straight back out of it.
    test('lets them into onboarding to add another scope', () {
      for (final location in [
        AppRoutes.onboarding,
        AppRoutes.onboardingUnit,
        AppRoutes.onboardingJoin,
      ]) {
        final decision = resolveRedirect(
          auth: _signedIn,
          scopes: _scopesOf([_community(MemberStatus.active)]),
          location: location,
        );

        expect(decision.target, isNull, reason: 'should stay on $location');
      }
    });

    // The case that stranded people before: one active scope of their own and
    // one request still being decided elsewhere.
    test('one approved scope is enough, whatever the others say', () {
      final decision = resolveRedirect(
        auth: _signedIn,
        scopes: _scopesOf([
          _community(MemberStatus.pending),
          _unit(MemberStatus.active),
        ]),
        location: AppRoutes.home,
      );

      expect(decision.target, isNull);
    });
  });
}
