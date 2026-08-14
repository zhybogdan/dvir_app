import 'dart:async';

import 'package:dvir/core/riverpod/guarded_actions.dart';
import 'package:dvir/features/Community/domain/models/community.dart';
import 'package:dvir/features/Community/domain/types/community_type.dart';
import 'package:dvir/features/Home/application/my_scopes_controller.dart';
import 'package:dvir/features/Home/domain/models/scope_summary.dart';
import 'package:dvir/features/Members/data/members_repository_impl.dart';
import 'package:dvir/features/Onboarding/data/onboarding_repository_impl.dart';
import 'package:dvir/features/Onboarding/domain/models/scope_membership.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_controller.g.dart';

/// Drives the three ways into the app and exposes their loading / error state.
///
/// Each action returns its result so the caller can use it — the invite code of
/// a freshly created scope, or which kind of scope a code turned out to open —
/// and null when the call failed, with the reason left in `state`.
///
/// The controller never navigates: an action that changes where the user
/// belongs ends by refreshing [myScopesProvider], and the router redirect takes
/// them from there.
@riverpod
class OnboardingController extends _$OnboardingController with GuardedActions {
  @override
  FutureOr<void> build() {}

  Future<Community?> createCommunity({
    required String name,
    required CommunityType type,
    String? address,
    String? city,
  }) {
    final repository = ref.read(onboardingRepositoryProvider);

    // Unlike joining, creating does not refresh membership here: the creator is
    // already an active admin, so refreshing would let the router pull them to
    // home before they have seen the invite code. The success screen refreshes
    // once the user leaves it.
    return guarded(
      () => repository.createCommunity(
        name: name,
        type: type,
        address: address,
        city: city,
      ),
    );
  }

  Future<ScopeMembership?> joinByInvite(String inviteCode) {
    final repository = ref.read(onboardingRepositoryProvider);

    return guarded(
      () => repository.joinByInvite(inviteCode),
      onSuccess: () => refreshMyScopes(ref),
    );
  }

  /// Takes a join request back, leaving the user belonging nowhere again.
  ///
  /// The database permits this only while the request is `pending`: a rejection
  /// or a block is not the applicant's to clear.
  Future<bool> withdraw(ScopeSummary scope) {
    final repository = ref.read(membersRepositoryProvider);

    return guardedVoid(
      () => switch (scope) {
        CommunitySummary(:final membership) => repository.removeCommunityMember(
          membership.id,
        ),
        UnitSummary(:final membership) => repository.removeUnitMember(
          membership.id,
        ),
      },
      onSuccess: () => refreshMyScopes(ref),
    );
  }
}
