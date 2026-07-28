import 'package:dvir/features/Auth/application/auth_controller.dart';
import 'package:dvir/features/Members/data/members_repository_impl.dart';
import 'package:dvir/features/Members/domain/models/unit_member_view.dart';
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
