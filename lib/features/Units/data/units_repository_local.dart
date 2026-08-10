import 'package:drift/drift.dart';
import 'package:dvir/core/database/app_database.dart';
import 'package:dvir/core/error/failures.dart';
import 'package:dvir/features/Units/data/units_repository.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/features/Units/domain/types/unit_type.dart';
import 'package:uuid/uuid.dart';

/// The objects of one household, kept on the device (Impl).
///
/// Most of what the cloud implementation has to ask the database for is simply
/// true here: there is one person, everything stored is theirs, and no row is
/// hidden from them. So `myUnits` is every object rather than a join through
/// `unit_members`.
///
/// What loses its meaning entirely — the community queries and the invite codes
/// — throws instead of answering emptily. An empty list would let a screen that
/// cannot exist in this flavour render as merely unpopulated, which is a build
/// mistake wearing the costume of a normal state.
class LocalUnitsRepository implements UnitsRepository {
  LocalUnitsRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<Unit>> myUnits() async {
    final rows =
        await (_database.select(_database.units)
              ..orderBy([(row) => OrderingTerm.asc(row.label)]))
            .get();

    return rows.map(_toUnit).toList();
  }

  @override
  Future<List<Unit>> topLevelUnitsOf(String communityId) =>
      throw UnsupportedError('This build has no communities.');

  @override
  Future<List<Unit>> childrenOf(String parentId) async {
    final rows =
        await (_database.select(_database.units)
              ..where((row) => row.parentId.equals(parentId))
              ..orderBy([(row) => OrderingTerm.asc(row.label)]))
            .get();

    return rows.map(_toUnit).toList();
  }

  @override
  Future<Unit> unitById(String id) async {
    final row =
        await (_database.select(_database.units)
              ..where((row) => row.id.equals(id)))
            .getSingleOrNull();

    if (row == null) throw const NotFoundFailure();

    return _toUnit(row);
  }

  @override
  Future<Unit> createUnit({
    required String label,
    required UnitType type,
    String? parentId,
    String? communityId,
    String? address,
    String? city,
    double? areaM2,
  }) async {
    if (communityId != null) {
      throw UnsupportedError('This build has no communities to create in.');
    }

    // The id is generated here rather than by the database, as it is in the
    // cloud: a document's storage key is its row id, so ids have to exist
    // before the row that carries them.
    final id = const Uuid().v4();

    await _database
        .into(_database.units)
        .insert(
          UnitsCompanion.insert(
            id: id,
            parentId: Value(parentId),
            type: type.dbValue,
            label: label,
            address: Value(address),
            city: Value(city),
            areaM2: Value(areaM2),
          ),
        );

    return unitById(id);
  }

  @override
  Future<Unit> updateUnit(Unit unit) async {
    // Written out column by column for the reason the cloud implementation
    // does it: this is the list of what an owner may edit, and where the object
    // sits is not part of it.
    await (_database.update(_database.units)
          ..where((row) => row.id.equals(unit.id)))
        .write(
          UnitsCompanion(
            label: Value(unit.label),
            type: Value(unit.type.dbValue),
            address: Value(unit.address),
            city: Value(unit.city),
            areaM2: Value(unit.areaM2),
          ),
        );

    return unitById(unit.id);
  }

  /// Deletes an object and, through the schema's cascades, everything nested
  /// under it along with its attributes, documents and contacts.
  @override
  Future<void> deleteUnit(String id) =>
      (_database.delete(_database.units)..where((row) => row.id.equals(id)))
          .go();

  @override
  Future<String> inviteCode(String unitId) =>
      throw UnsupportedError('This build has nobody to invite.');

  @override
  Future<String> rotateInviteCode(String unitId) =>
      throw UnsupportedError('This build has nobody to invite.');

  /// `communityId` and `inviteCode` stay null, which is what they mean: an
  /// object that belongs to no community and lets nobody in.
  Unit _toUnit(UnitRow row) => Unit(
    id: row.id,
    label: row.label,
    type: UnitType.fromDbValue(row.type),
    parentId: row.parentId,
    address: row.address,
    city: row.city,
    areaM2: row.areaM2,
  );
}
