import 'package:dvir/features/Home/data/scopes_repository.dart';
import 'package:dvir/features/Home/domain/models/scope_summary.dart';
import 'package:dvir/features/Shared/domain/types/member_status.dart';
import 'package:dvir/features/Units/data/units_repository.dart';
import 'package:dvir/features/Units/domain/models/unit_membership.dart';
import 'package:dvir/features/Units/domain/types/unit_role.dart';

/// Who everything belongs to when there is no account to belong to.
///
/// A constant rather than an empty string so that a row carrying it reads as a
/// deliberate answer, and so the router has something to compare against once
/// it stops asking an auth repository who is signed in.
const String localUserId = 'local';

/// The home list without memberships (Impl).
///
/// Reads through [UnitsRepository] rather than the database, so "my objects"
/// has one definition however it is asked for.
class LocalScopesRepository implements ScopesRepository {
  LocalScopesRepository(this._units);

  final UnitsRepository _units;

  @override
  Future<List<ScopeSummary>> myScopes() async {
    final units = await _units.myUnits();

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
        ),
    ];
  }
}
