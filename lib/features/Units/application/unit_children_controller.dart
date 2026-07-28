import 'package:dvir/features/Units/data/units_repository_impl.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'unit_children_controller.g.dart';

/// The objects that sit inside one object — the flats in a house, the boxes in
/// a row.
///
/// Read from the database rather than filtered out of the user's scope list:
/// this is everything the object contains, including what its owner created and
/// then handed to someone else.
@riverpod
Future<List<Unit>> unitChildren(Ref ref, String unitId) =>
    ref.watch(unitsRepositoryProvider).childrenOf(unitId);
