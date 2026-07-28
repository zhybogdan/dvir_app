import 'dart:async';

import 'package:dvir/features/Auth/application/auth_controller.dart';
import 'package:dvir/features/Members/data/members_repository.dart';
import 'package:dvir/features/Members/data/members_repository_impl.dart';
import 'package:dvir/features/Members/domain/models/unit_member_view.dart';
import 'package:dvir/features/Shared/domain/types/member_status.dart';
import 'package:dvir/features/Units/domain/types/unit_role.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'unit_members_controller.g.dart';

/// Everyone attached to one object, requests included.
@riverpod
Future<List<UnitMemberView>> unitMembers(Ref ref, String unitId) =>
    ref.watch(membersRepositoryProvider).unitMembers(unitId);

/// The signed-in user's role in this object, or null when they have none.
///
/// Null is a real answer rather than an error: an admin of the owning community
/// manages an object without living in it, so they see the screen while
/// belonging to nobody's household.
@riverpod
Future<UnitRole?> myUnitRole(Ref ref, String unitId) async {
  final userId = ref.watch(authStateProvider).value?.id;
  if (userId == null) return null;

  final members = await ref.watch(unitMembersProvider(unitId).future);

  return members
      .where((view) => view.membership.userId == userId)
      .map((view) => view.membership.role)
      .firstOrNull;
}

/// Deciding on the people of one object, and the loading / error state of it.
///
/// Keyed by the object so a refusal on one screen cannot light up another, and
/// so the list to re-read afterwards is known without being passed in.
///
/// The rules are not repeated here — the database owns them and answers DV004
/// and DV005, which the failure mapper turns into a sentence. This only asks.
@riverpod
class UnitMemberModeration extends _$UnitMemberModeration {
  @override
  FutureOr<void> build(String unitId) {}

  Future<void> setStatus(String memberId, MemberStatus status) => _run(
    (repository) =>
        repository.setUnitMemberStatus(memberId: memberId, status: status),
  );

  Future<void> setRole(String memberId, UnitRole role) => _run(
    (repository) =>
        repository.setUnitMemberRole(memberId: memberId, role: role),
  );

  Future<void> remove(String memberId) =>
      _run((repository) => repository.removeUnitMember(memberId));

  Future<void> _run(Future<void> Function(MembersRepository) call) async {
    final repository = ref.read(membersRepositoryProvider);

    state = const AsyncLoading();
    final result = await AsyncValue.guard(() => call(repository));

    // Checked before the assignment, not after: this runs past an await, and
    // writing `state` on a notifier whose screen has gone throws rather than
    // being ignored.
    if (!ref.mounted) return;
    state = result;

    if (result.hasError) return;

    ref.invalidate(unitMembersProvider(unitId));
  }
}
