import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/features/Units/domain/types/unit_type.dart';

/// Contract for reading and managing objects (Base).
///
/// Creation lives here rather than in the onboarding repository even though
/// onboarding is what calls it first: an object is created from three places by
/// the end of Phase 4 — onboarding, a community, and another object — and all
/// three have to go through the same RPC and the same argument shape.
abstract interface class UnitsRepository {
  /// Objects the signed-in user is personally attached to.
  ///
  /// Goes through `unit_members` rather than reading `units` directly: RLS also
  /// shows an active community member every object *in* their community, which
  /// is a different list from "mine".
  Future<List<Unit>> myUnits();

  /// Top-level objects of one community — houses, plots, garage boxes. What
  /// hangs inside them comes from [childrenOf].
  Future<List<Unit>> topLevelUnitsOf(String communityId);

  Future<List<Unit>> childrenOf(String parentId);

  Future<Unit> unitById(String id);

  /// Creates an object with the caller as its owner.
  ///
  /// Three shapes, decided by what is passed: inside [parentId] (inherits that
  /// object's community), inside [communityId] (admins only), or neither — a
  /// standalone object belonging to no community at all.
  Future<Unit> createUnit({
    required String label,
    required UnitType type,
    String? parentId,
    String? communityId,
    String? address,
    String? city,
    double? areaM2,
  });

  /// Saves what an object *is* — its label, type, address and area.
  ///
  /// Where it sits (`community_id`, `parent_id`) and how people get in
  /// (`invite_code`) are not editable this way; the database refuses those
  /// columns outside their own RPCs.
  Future<Unit> updateUnit(Unit unit);

  /// Deletes an object **and everything nested under it** — child objects and
  /// every membership cascade from this row.
  Future<void> deleteUnit(String id);

  /// Issues a fresh invite code, invalidating the old one.
  Future<String> rotateInviteCode(String unitId);
}
