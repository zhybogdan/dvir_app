import 'dart:async';

import 'package:dvir/features/Community/domain/models/community.dart';
import 'package:dvir/features/Community/domain/types/community_type.dart';
import 'package:dvir/features/Onboarding/application/membership_controller.dart';
import 'package:dvir/features/Onboarding/data/onboarding_repository_impl.dart';
import 'package:dvir/features/Onboarding/domain/models/scope_membership.dart';
import 'package:dvir/features/Units/data/units_repository_impl.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/features/Units/domain/types/unit_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_controller.g.dart';

/// Drives the three ways into the app and exposes their loading / error state.
///
/// Each action returns its result so the caller can use it — the invite code of
/// a freshly created scope, or which kind of scope a code turned out to open —
/// and null when the call failed, with the reason left in `state`.
///
/// The controller never navigates: every action ends by refreshing
/// [myMembershipProvider], and the router redirect takes the user from there.
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
    state = result;

    // Unlike joining, creating does not refresh membership here: the creator is
    // already an active admin, so refreshing would let the router pull them to
    // home before they have seen the invite code. The success screen refreshes
    // once the user leaves it.
    return result.value;
  }

  Future<Unit?> createUnit({
    required String label,
    required UnitType type,
    String? parentId,
    String? communityId,
    String? address,
    String? city,
    double? areaM2,
  }) async {
    final repository = ref.read(unitsRepositoryProvider);

    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => repository.createUnit(
        label: label,
        type: type,
        parentId: parentId,
        communityId: communityId,
        address: address,
        city: city,
        areaM2: areaM2,
      ),
    );
    state = result;

    // Same as createCommunity: the creator is the active owner, so the invite
    // code is shown first and membership is refreshed when they move on.
    return result.value;
  }

  Future<ScopeMembership?> joinByInvite(String inviteCode) async {
    final repository = ref.read(onboardingRepositoryProvider);

    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => repository.joinByInvite(inviteCode),
    );
    state = result;

    _refreshMembership(result.hasValue);

    return result.value;
  }

  /// Re-reads the membership so the router sees the new state.
  ///
  /// Guarded by `ref.mounted`: this always runs after an await, and the screen
  /// that started the call may be gone by then — touching a disposed ref
  /// throws.
  void _refreshMembership(bool succeeded) {
    if (!succeeded || !ref.mounted) return;

    ref.invalidate(myMembershipProvider);
  }
}
