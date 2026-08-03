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
///
/// Kept alive because the section sits at the bottom of the hub's scroll. A
/// `ListView` destroys a child that leaves the viewport, which takes the last
/// listener with it, which disposes an auto-disposing provider — so every
/// scroll down was a fresh query for a list that had not changed. Everything
/// that changes it already invalidates it: creating an object, deleting one,
/// and the hub's pull-to-refresh.
@Riverpod(keepAlive: true)
Future<List<Unit>> unitChildren(Ref ref, String unitId) =>
    ref.watch(unitsRepositoryProvider).childrenOf(unitId);
