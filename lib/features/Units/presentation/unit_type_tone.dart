import 'package:dvir/app/theme.dart';
import 'package:dvir/features/Units/domain/types/unit_type.dart';

/// The colour a [UnitType] is drawn in.
///
/// Beside `UnitTypeIcon` and shaped like it, with one difference worth saying
/// out loud: the glyph is per type, the colour is per **group**. The three
/// groups are `UnitTypeL10n.groupLabel`'s, not a second grouping invented
/// here — a flat and a cellar are told apart by their drawing, and by colour
/// only as far as one stands at the address and the other is inside it.
extension UnitTypeTone on UnitType {
  Tone get tone => switch (this) {
    UnitType.house || UnitType.apartment || UnitType.plot => AppTones.place,
    UnitType.room ||
    UnitType.bathroom ||
    UnitType.corridor ||
    UnitType.storeroom ||
    UnitType.balcony ||
    UnitType.loggia ||
    UnitType.basement => AppTones.room,
    UnitType.garage ||
    UnitType.summerKitchen ||
    UnitType.summerHouse ||
    UnitType.shed ||
    UnitType.pool => AppTones.building,
    UnitType.office || UnitType.custom => AppTones.other,
  };
}
