import 'dart:async';

import 'package:dvir/features/Units/data/units_repository_impl.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/features/Units/domain/types/unit_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'unit_form_controller.g.dart';

/// Creating and editing an object, and the loading / error state of both.
///
/// One controller for the two because they are one form: the same five fields,
/// differing only in whether there is already a row behind them. Each action
/// returns its result so the screen can decide where to go next, and null when
/// the call failed, with the reason left in `state` for the toast.
@riverpod
class UnitFormController extends _$UnitFormController {
  @override
  FutureOr<void> build() {}

  Future<Unit?> create({
    required String label,
    required UnitType type,
    String? parentId,
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
        address: address,
        city: city,
        areaM2: areaM2,
      ),
    );
    state = result;

    return result.value;
  }

  /// Named `save` rather than `update`: `AsyncNotifier` already has an `update`
  /// of its own, and overriding it with a different shape does not compile.
  Future<Unit?> save(Unit unit) async {
    final repository = ref.read(unitsRepositoryProvider);

    state = const AsyncLoading();
    final result = await AsyncValue.guard(() => repository.updateUnit(unit));
    state = result;

    return result.value;
  }
}
