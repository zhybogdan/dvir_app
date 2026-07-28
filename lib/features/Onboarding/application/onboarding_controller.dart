import 'dart:async';

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
class OnboardingController extends _$OnboardingController {
  @override
  FutureOr<void> build() {}

  Future<Community?> createCommunity({
    required String name,
    required CommunityType type,
    String? address,
    String? city,
  }) async {
    final repository = ref.read(onboardingRepositoryProvider);

    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => repository.createCommunity(
        name: name,
        type: type,
        address: address,
        city: city,
      ),
    );

    // Checked before the assignment: writing `state` after the screen watching
    // this has gone throws rather than being ignored.
    if (!ref.mounted) return null;
    state = result;

    // Unlike joining, creating does not refresh membership here: the creator is
    // already an active admin, so refreshing would let the router pull them to
    // home before they have seen the invite code. The success screen refreshes
    // once the user leaves it.
    return result.value;
  }

  Future<ScopeMembership?> joinByInvite(String inviteCode) async {
    final repository = ref.read(onboardingRepositoryProvider);

    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => repository.joinByInvite(inviteCode),
    );

    if (!ref.mounted) return null;
    state = result;

    await _refreshScopes(result.hasValue);

    return result.value;
  }

  /// Takes a join request back, leaving the user belonging nowhere again.
  ///
  /// The database permits this only while the request is `pending`: a rejection
  /// or a block is not the applicant's to clear.
  Future<bool> withdraw(ScopeSummary scope) async {
    final repository = ref.read(membersRepositoryProvider);

    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => switch (scope) {
        CommunitySummary(:final membership) => repository.removeCommunityMember(
          membership.id,
        ),
        UnitSummary(:final membership) => repository.removeUnitMember(
          membership.id,
        ),
      },
    );

    if (!ref.mounted) return false;
    state = result;

    if (result.hasError) return false;

    await _refreshScopes(true);

    return true;
  }

  /// Re-reads the scope list and **waits for it**, so the router never decides
  /// on the answer from before the join.
  ///
  /// Merely invalidating returned control while the fetch was still in flight,
  /// and the redirect read the empty list underneath as "belongs nowhere" —
  /// which threw someone who had just sent a request back to onboarding for as
  /// long as the round trip took, before the waiting screen finally appeared.
  ///
  /// Guarded by `ref.mounted` twice over: this runs after an await, and the
  /// screen that started the call may be gone by then.
  Future<void> _refreshScopes(bool succeeded) async {
    if (!succeeded || !ref.mounted) return;

    // Invalidate then read, rather than `refresh`: the first marks the list
    // stale, the second is what waits for the replacement to land.
    ref.invalidate(myScopesProvider);
    await ref.read(myScopesProvider.future);
  }
}
