import 'package:dvir/features/Units/domain/models/unit_attribute.dart';

/// Contract for the record an object keeps about itself (Base).
///
/// Kept apart from `UnitsRepository` rather than folded into it: the facts have
/// their own table, their own write rule — a `family` member keeps them, an
/// owner alone edits the object itself — and nothing here goes through an RPC.
abstract interface class UnitAttributesRepository {
  /// The object's facts, in the order its keeper put them in.
  Future<List<UnitAttribute>> attributesOf(String unitId);

  /// Appends a fact. Where it lands in the order is the database's answer, not
  /// the caller's: two devices adding at once would both claim the same place.
  Future<void> addAttribute({
    required String unitId,
    required String name,
    required String value,
  });

  /// Saves the wording of a fact. Its place in the order is not editable this
  /// way — reordering is a move of the whole list, not of one row.
  Future<void> updateAttribute(UnitAttribute attribute);

  Future<void> deleteAttribute(String id);

  /// Puts the object's facts in the order [ids] are given in.
  ///
  /// The whole list, not the one row that moved: a drag changes the place of
  /// every row after it, and sending them one by one would leave a half-applied
  /// order behind the first failed call.
  Future<void> reorder({required String unitId, required List<String> ids});
}
