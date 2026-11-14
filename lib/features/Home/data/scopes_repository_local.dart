import 'package:drift/drift.dart';
import 'package:dvir/core/config/local_identity.dart';
import 'package:dvir/core/database/app_database.dart';
import 'package:dvir/features/Home/data/scopes_repository.dart';
import 'package:dvir/features/Home/domain/models/scope_summary.dart';
import 'package:dvir/features/Shared/domain/types/member_status.dart';
import 'package:dvir/features/Units/data/units_repository.dart';
import 'package:dvir/features/Units/domain/models/unit_membership.dart';
import 'package:dvir/features/Units/domain/types/unit_role.dart';

/// The home list without memberships (Impl).
///
/// The objects come through [UnitsRepository] rather than the database, so "my
/// objects" has one definition however it is asked for. The database is here
/// only for what that repository has no business answering: how much each
/// object holds.
class LocalScopesRepository implements ScopesRepository {
  LocalScopesRepository(this._units, this._database);

  final UnitsRepository _units;
  final AppDatabase _database;

  @override
  Future<List<ScopeSummary>> myScopes() async {
    final units = await _units.myUnits();
    // Two queries for the whole screen rather than two per object: the tally
    // is grouped by the database, and an object missing from a group has
    // nothing of that kind.
    final documents = await _countBy(
      _database.documents,
      _database.documents.unitId,
    );
    final attributes = await _countBy(
      _database.unitAttributes,
      _database.unitAttributes.unitId,
    );

    // The membership is invented, and every field of it is true: there is one
    // person, they own what they keep, and nothing is waiting for approval.
    // Inventing it here rather than making `ScopeSummary.membership` nullable
    // leaves the model — and every screen and test reading it — untouched.
    return [
      for (final unit in units)
        ScopeSummary.unit(
          membership: UnitMembership(
            id: unit.id,
            unitId: unit.id,
            userId: localUserId,
            role: UnitRole.owner,
            status: MemberStatus.active,
          ),
          unit: unit,
          // Zero rather than null, unlike the cloud: there is nothing here
          // that could hide a row, so an empty tally means empty.
          counts: (
            documents: documents[unit.id] ?? 0,
            attributes: attributes[unit.id] ?? 0,
          ),
        ),
    ];
  }

  /// How many rows each object has in [table], keyed by object.
  Future<Map<String, int>> _countBy(
    TableInfo<Table, dynamic> table,
    GeneratedColumn<String> unitId,
  ) async {
    final total = countAll();
    final rows =
        await (_database.selectOnly(table)
              ..addColumns([unitId, total])
              ..groupBy([unitId]))
            .get();

    final counts = <String, int>{};
    for (final row in rows) {
      final id = row.read(unitId);
      final count = row.read(total);
      if (id != null && count != null) counts[id] = count;
    }

    return counts;
  }
}
