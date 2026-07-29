import 'dart:async';

import 'package:dvir/core/riverpod/guarded_actions.dart';
import 'package:dvir/features/Units/data/unit_attributes_repository.dart';
import 'package:dvir/features/Units/data/unit_attributes_repository_impl.dart';
import 'package:dvir/features/Units/domain/models/unit_attribute.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'unit_attributes_controller.g.dart';

/// The record one object keeps about itself.
@riverpod
Future<List<UnitAttribute>> unitAttributes(Ref ref, String unitId) =>
    ref.watch(unitAttributesRepositoryProvider).attributesOf(unitId);

/// Adding, rewording and dropping the facts of one object.
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
