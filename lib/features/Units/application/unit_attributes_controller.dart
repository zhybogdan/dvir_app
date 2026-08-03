import 'dart:async';

import 'package:dvir/core/riverpod/guarded_actions.dart';
import 'package:dvir/core/utils/list_reorder.dart';
import 'package:dvir/features/Units/data/unit_attributes_repository.dart';
import 'package:dvir/features/Units/data/unit_attributes_repository_impl.dart';
import 'package:dvir/features/Units/domain/models/unit_attribute.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'unit_attributes_controller.g.dart';

/// The record one object keeps about itself.
///
/// A notifier rather than a plain future so the order can be shown before the
/// database has agreed to it — see [applyOrder].
///
/// Kept alive for the reason `unitChildren` is: a section scrolled out of the
/// hub loses its listener, and an auto-disposing provider throws the record
/// away and fetches it again on the way back. Every write invalidates it.
@Riverpod(keepAlive: true)
class UnitAttributes extends _$UnitAttributes {
  @override
  Future<List<UnitAttribute>> build(String unitId) =>
      ref.watch(unitAttributesRepositoryProvider).attributesOf(unitId);

  /// Shows [ordered] straight away, before the call that saves it.
  ///
  /// A dragged row has to stay where it was dropped. Waiting for the round trip
  /// would snap it back to its old place for as long as the request takes,
  /// which reads as the drag having failed — and then move it again when the
  /// answer lands.
  ///
  /// Only [UnitAttributeActions.move] calls this, and it is what puts the list
  /// back when the call is refused.
  void applyOrder(List<UnitAttribute> ordered) => state = AsyncData(ordered);
}

/// Adding, rewording, dropping and reordering the facts of one object.
///
/// Keyed by the object so a refusal on one screen cannot light up another, and
/// so the list to re-read afterwards is known without being passed in.
///
/// **A screen driving this must also listen to it** — nothing watches it for a
/// value, so without a listener it is disposed the moment it is read, and its
/// failures reach nobody.
@riverpod
class UnitAttributeActions extends _$UnitAttributeActions with GuardedActions {
  @override
  FutureOr<void> build(String unitId) {}

  Future<bool> add({required String name, required String value}) => _run(
    (repository) =>
        repository.addAttribute(unitId: unitId, name: name, value: value),
  );

  Future<bool> edit(UnitAttribute attribute) =>
      _run((repository) => repository.updateAttribute(attribute));

  Future<bool> remove(String id) =>
      _run((repository) => repository.deleteAttribute(id));

  /// Moves the fact at [from] to [to], both counted against the list as it is
  /// on screen.
  ///
  /// The whole order is sent, not the one row that moved: a move changes the
  /// place of every row between the two ends of it.
  Future<bool> move({required int from, required int to}) async {
    final current = ref.read(unitAttributesProvider(unitId)).value;
    // Nothing to reorder until the list has arrived, and a drag cannot happen
    // before then — this is the guard for a stale callback, not a real case.
    if (current == null) return false;

    final repository = ref.read(unitAttributesRepositoryProvider);
    final list = ref.read(unitAttributesProvider(unitId).notifier);
    final ordered = reordered(current, from: from, to: to);

    list.applyOrder(ordered);

    final saved = await guardedVoid(
      () => repository.reorder(
        unitId: unitId,
        ids: [for (final attribute in ordered) attribute.id],
      ),
    );

    // The row is already sitting in its new place, so a refusal has to take it
    // back — otherwise the screen keeps showing an order the database does not
    // have, until something else happens to re-read the list.
    if (!saved && ref.mounted) ref.invalidate(unitAttributesProvider(unitId));

    return saved;
  }

  /// Every action here changes the same list, so what to re-read afterwards is
  /// the same too.
  Future<bool> _run(Future<void> Function(UnitAttributesRepository) call) {
    final repository = ref.read(unitAttributesRepositoryProvider);

    return guardedVoid(
      () => call(repository),
      onSuccess: () => ref.invalidate(unitAttributesProvider(unitId)),
    );
  }
}
