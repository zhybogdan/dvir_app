import 'package:drift/drift.dart';
import 'package:dvir/core/database/app_database.dart';
import 'package:dvir/features/Units/data/unit_attributes_repository.dart';
import 'package:dvir/features/Units/domain/models/unit_attribute.dart';
import 'package:uuid/uuid.dart';

/// The record an object keeps about itself, on the device (Impl).
///
/// The write rule the cloud enforces — a keeper of this object, and nobody else
/// — has no counterpart here: there is one person and everything is theirs. What
/// does carry over is the *ordering*, because that is not a permission but the
/// shape of the data, and a list that reads differently in the two builds would
/// be the same bug twice.
class LocalUnitAttributesRepository implements UnitAttributesRepository {
  LocalUnitAttributesRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<UnitAttribute>> attributesOf(String unitId) async {
    // `createdAt` is the tie-breaker rather than decoration: positions are not
    // unique on purpose, so without it two facts sharing one could swap places
    // between reads.
    final rows =
        await (_database.select(_database.unitAttributes)
              ..where((row) => row.unitId.equals(unitId))
              ..orderBy([
                (row) => OrderingTerm.asc(row.position),
                (row) => OrderingTerm.asc(row.createdAt),
              ]))
            .get();

    return rows.map(_toAttribute).toList();
  }

  /// Appends, and works out where the end is inside a transaction.
  ///
  /// The cloud has an insert trigger do this so that two devices adding at once
  /// cannot both claim the same place. One device is not two, but two taps in
  /// quick succession are, and the transaction is what makes the second read the
  /// first.
  @override
  Future<void> addAttribute({
    required String unitId,
    required String name,
    required String value,
  }) => _database.transaction(() async {
    final position = await _nextPosition(unitId);

    await _database
        .into(_database.unitAttributes)
        .insert(
          UnitAttributesCompanion.insert(
            id: const Uuid().v4(),
            unitId: unitId,
            name: name,
            value: value,
            position: Value(position),
            createdAt: DateTime.now().toUtc(),
          ),
        );
  });

  @override
  Future<void> updateAttribute(UnitAttribute attribute) =>
      (_database.update(
        _database.unitAttributes,
      )..where((row) => row.id.equals(attribute.id))).write(
        UnitAttributesCompanion(
          name: Value(attribute.name),
          value: Value(attribute.value),
        ),
      );

  @override
  Future<void> deleteAttribute(String id) => (_database.delete(
    _database.unitAttributes,
  )..where((row) => row.id.equals(id))).go();

  /// In one transaction, because the RPC it replaces was a single statement: a
  /// loop that failed halfway would leave the list in an order nobody asked for
  /// and no read could explain.
  @override
  Future<void> reorder({
    required String unitId,
    required List<String> ids,
  }) => _database.transaction(() async {
    for (var place = 0; place < ids.length; place++) {
      // Matching `unitId` as well as the id keeps a row belonging to another
      // object a no-op, exactly as the `unit_id` in the RPC's join does.
      // Here it guards correctness rather than privacy, and it is worth
      // keeping so the two implementations cannot drift apart.
      await (_database.update(_database.unitAttributes)..where(
            (row) => row.id.equals(ids[place]) & row.unitId.equals(unitId),
          ))
          .write(UnitAttributesCompanion(position: Value(place)));
    }
  });

  /// One past the last place taken, or the first place when nothing is there.
  Future<int> _nextPosition(String unitId) async {
    final highest = _database.unitAttributes.position.max();

    final query = _database.selectOnly(_database.unitAttributes)
      ..addColumns([highest])
      ..where(_database.unitAttributes.unitId.equals(unitId));

    final taken = await query.map((row) => row.read(highest)).getSingle();

    return (taken ?? -1) + 1;
  }

  /// `position` does not travel: it is what the rows are sorted by, not
  /// something the app reads.
  UnitAttribute _toAttribute(UnitAttributeRow row) =>
      UnitAttribute(id: row.id, name: row.name, value: row.value);
}
