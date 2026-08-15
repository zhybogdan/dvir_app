import 'dart:async';

import 'package:dvir/core/riverpod/guarded_actions.dart';
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
///
/// **A screen driving this must also listen to it.** Nothing here is watched
/// for its value — the actions are fired from callbacks — so without a listener
/// the provider is disposed the moment it is read, and the result lands on a
/// dead notifier. Listening is also the only way its failures reach the user.
@riverpod
class UnitActions extends _$UnitActions with GuardedActions {
  @override
  FutureOr<void> build(String unitId) {}

  /// Issues a fresh code and returns it, or null when the call failed.
  Future<String?> rotateInviteCode() {
    final repository = ref.read(unitsRepositoryProvider);

    return guarded(
      () => repository.rotateInviteCode(unitId),
      onSuccess: () => ref.invalidate(unitInviteCodeProvider(unitId)),
    );
  }

  /// Deletes the object; true when it is gone.
  ///
  /// [parentId] is what the caller is about to navigate back to, and its list
  /// of contents is now one shorter.
  Future<bool> delete({String? parentId}) {
    final repository = ref.read(unitsRepositoryProvider);

    return guardedVoid(
      () => repository.deleteUnit(unitId),
      onSuccess: () async {
        if (parentId != null) ref.invalidate(unitChildrenProvider(parentId));

        // Waited for, not merely invalidated: the caller goes home the moment
        // this returns, and the home screen is drawn from this list. Asked too
        // early it still holds the object that has just been deleted — so the
        // list renders a card for it, and the redirect, seeing a member of
        // something, leaves the person there until the real answer lands.
        await refreshMyScopes(ref);
      },
    );
  }
}
