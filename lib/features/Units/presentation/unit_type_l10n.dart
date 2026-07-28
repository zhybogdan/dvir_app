import 'package:dvir/features/Units/domain/types/unit_type.dart';
import 'package:dvir/l10n/app_localizations.dart';

/// Human-readable label for a [UnitType].
///
/// Lives in presentation, not on the domain enum: the enum stays a pure list of
/// database values, and the wording is a UI concern that belongs with the arb.
/// The switch is exhaustive, so a new type fails to compile until it is named.
extension UnitTypeL10n on UnitType {
  String label(AppLocalizations l10n) => switch (this) {
    UnitType.house => l10n.unitTypeHouse,
    UnitType.apartment => l10n.unitTypeApartment,
    UnitType.room => l10n.unitTypeRoom,
    UnitType.garage => l10n.unitTypeGarage,
    UnitType.plot => l10n.unitTypePlot,
    UnitType.basement => l10n.unitTypeBasement,
    UnitType.summerKitchen => l10n.unitTypeSummerKitchen,
    UnitType.summerHouse => l10n.unitTypeSummerHouse,
    UnitType.shed => l10n.unitTypeShed,
    UnitType.pool => l10n.unitTypePool,
    UnitType.balcony => l10n.unitTypeBalcony,
    UnitType.loggia => l10n.unitTypeLoggia,
    UnitType.bathroom => l10n.unitTypeBathroom,
    UnitType.corridor => l10n.unitTypeCorridor,
    UnitType.storeroom => l10n.unitTypeStoreroom,
    UnitType.office => l10n.unitTypeOffice,
    UnitType.custom => l10n.unitTypeCustom,
  };

  /// The heading this type sits under in the picker.
  ///
  /// Seventeen types in one run is a list to be scrolled through; four headings
  /// make it a list to be jumped into. The grouping follows where a thing
  /// physically is — at the address, inside the walls, or standing apart in the
  /// yard — because that is how someone recalling their own household thinks of
  /// it.
  String groupLabel(AppLocalizations l10n) => switch (this) {
    UnitType.house ||
    UnitType.apartment ||
    UnitType.plot => l10n.unitTypeGroupMain,
    UnitType.room ||
    UnitType.bathroom ||
    UnitType.corridor ||
    UnitType.storeroom ||
    UnitType.balcony ||
    UnitType.loggia ||
    UnitType.basement => l10n.unitTypeGroupRooms,
    UnitType.garage ||
    UnitType.summerKitchen ||
    UnitType.summerHouse ||
    UnitType.shed ||
    UnitType.pool => l10n.unitTypeGroupBuildings,
    UnitType.office || UnitType.custom => l10n.unitTypeGroupOther,
  };
}
