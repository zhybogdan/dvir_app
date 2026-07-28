import 'package:dvir/features/Units/domain/types/unit_type.dart';

/// What may be put inside what.
///
/// Without this every object offers all seventeen types, so a garage can be
/// given a flat and a bathroom a garage. The rules follow the physical thing
/// rather than the data: a plot is the only object a house stands on, a flat
/// has rooms but no outbuildings, and a room contains nothing at all.
///
/// Lives in `domain/` next to `member_permissions` and for the same reason —
/// it is the answer to a question, not a widget, so both the type picker and
/// the "add" button can ask it and be sure they agree.

/// Everything within the walls.
const Set<UnitType> _rooms = {
  UnitType.room,
  UnitType.bathroom,
  UnitType.corridor,
  UnitType.storeroom,
  UnitType.balcony,
  UnitType.loggia,
  UnitType.basement,
};

/// What stands apart in the yard — a summer house excluded, because it holds
/// rooms of its own and belongs to a plot rather than to another building.
const Set<UnitType> _outbuildings = {
  UnitType.garage,
  UnitType.summerKitchen,
  UnitType.shed,
  UnitType.pool,
};

/// The small dry corners a single building can be divided into. A garage has a
/// pit and a shelf room; it does not have a hallway or a balcony.
const Set<UnitType> _insideOneBuilding = {
  UnitType.room,
  UnitType.bathroom,
  UnitType.storeroom,
  UnitType.basement,
};

/// Objects that stand on their own, with nothing above them.
///
/// A garage, a summer house and an office are here as well as a house: the
/// product is aimed at garage co-ops and dachas too, where the garage — or the
/// cottage with no plot registered around it — *is* the whole record somebody
/// keeps.
const Set<UnitType> _topLevel = {
  UnitType.house,
  UnitType.apartment,
  UnitType.plot,
  UnitType.garage,
  UnitType.summerHouse,
  UnitType.office,
  UnitType.custom,
};

/// What [parent] may contain, or the top level when [parent] is null.
Set<UnitType> allowedChildTypes(UnitType? parent) => switch (parent) {
  null => _topLevel,

  // What a dacha is: the ground is the record, and everything stands on it.
  UnitType.plot => {
    UnitType.house,
    UnitType.summerHouse,
    ..._outbuildings,
    UnitType.office,
    UnitType.custom,
  },

  UnitType.house || UnitType.summerHouse => {
    ..._rooms,
    ..._outbuildings,
    UnitType.office,
    UnitType.custom,
  },

  UnitType.apartment => {..._rooms, UnitType.office, UnitType.custom},

  UnitType.garage ||
  UnitType.shed ||
  UnitType.summerKitchen ||
  UnitType.office => {..._insideOneBuilding, UnitType.custom},

  // Deliberately wide: "other" is what the list failed to foresee, so the one
  // thing it must not do is refuse the case it exists for. Only a flat and a
  // plot stay out — those are records of their own, not parts of something.
  UnitType.custom => {
    UnitType.house,
    UnitType.summerHouse,
    ..._rooms,
    ..._outbuildings,
    UnitType.office,
    UnitType.custom,
  },

  // Leaves. A room divided further is a room, and a pool holds water.
  UnitType.room ||
  UnitType.bathroom ||
  UnitType.corridor ||
  UnitType.storeroom ||
  UnitType.balcony ||
  UnitType.loggia ||
  UnitType.basement ||
  UnitType.pool => const {},
};

/// Whether anything at all may be added inside [type] — what the "add" button
/// on the hub is shown by.
bool canHoldChildren(UnitType type) => allowedChildTypes(type).isNotEmpty;

/// The list a type picker offers, in the enum's own grouped order.
///
/// [current] is kept even where the rules would now refuse it: an object typed
/// before these rules existed must stay editable, and a picker whose value is
/// missing from its own options would silently retype it on the next save.
List<UnitType> unitTypeOptions({required UnitType? parent, UnitType? current}) {
  final allowed = allowedChildTypes(parent);

  return UnitType.values
      .where((type) => allowed.contains(type) || type == current)
      .toList();
}
