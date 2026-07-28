import 'dart:async';

import 'package:dvir/features/Home/application/my_scopes_controller.dart';
import 'package:dvir/features/Units/application/unit_children_controller.dart';
import 'package:dvir/features/Units/application/unit_controller.dart';
import 'package:dvir/features/Units/data/units_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'unit_actions_controller.g.dart';

/// What an owner can do to the object itself, as opposed to its contents.
///
/// Keyed by the object, so a failure on one screen cannot light up another and
/// the caches to clear afterwards are known without being passed in.
@riverpod
class UnitActions extends _$UnitActions {
  @override
  FutureOr<void> build(String unitId) {}

  /// Issues a fresh code and returns it, or null when the call failed.
  Future<String?> rotateInviteCode() async {
    final repository = ref.read(unitsRepositoryProvider);

    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => repository.rotateInviteCode(unitId),
    );
    state = result;

    if (result.hasError || !ref.mounted) return null;

    ref.invalidate(unitInviteCodeProvider(unitId));

    return result.value;
  }

  /// Deletes the object; true when it is gone.
  ///
  /// [parentId] is what the caller is about to navigate back to, and its list
  /// of contents is now one shorter.
  Future<bool> delete({String? parentId}) async {
    final repository = ref.read(unitsRepositoryProvider);

    state = const AsyncLoading();
    final result = await AsyncValue.guard(() => repository.deleteUnit(unitId));
    state = result;

    if (result.hasError || !ref.mounted) return false;

    // The home list names every object the user belongs to, and this one is no
    // longer among them.
    ref.invalidate(myScopesProvider);
    if (parentId != null) ref.invalidate(unitChildrenProvider(parentId));

    return true;
  }
}
