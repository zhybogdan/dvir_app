import 'package:dvir/app/icons.dart';
import 'package:dvir/features/Units/domain/types/unit_type.dart';
import 'package:material_ui/material_ui.dart';

/// The glyph a [UnitType] is drawn with.
///
/// Beside `UnitTypeL10n` and for the same reason: the enum stays a plain list
/// of database values, and how a type looks is a UI concern. The switch is
/// exhaustive, so a new type does not compile until it is given a glyph.
extension UnitTypeIcon on UnitType {
  IconData get icon => switch (this) {
    UnitType.house => AppIcons.unitHouse,
    UnitType.summerHouse => AppIcons.unitSummerHouse,
    UnitType.apartment => AppIcons.unitApartment,
    UnitType.room => AppIcons.unitRoom,
    UnitType.corridor => AppIcons.unitCorridor,
    UnitType.garage => AppIcons.unitGarage,
    UnitType.plot => AppIcons.unitPlot,
    UnitType.basement => AppIcons.unitBasement,
    UnitType.storeroom => AppIcons.unitStoreroom,
    UnitType.summerKitchen => AppIcons.unitSummerKitchen,
    UnitType.shed => AppIcons.unitShed,
    UnitType.pool => AppIcons.unitPool,
    UnitType.balcony => AppIcons.unitBalcony,
    UnitType.loggia => AppIcons.unitLoggia,
    UnitType.bathroom => AppIcons.unitBathroom,
    UnitType.office => AppIcons.unitOffice,
    UnitType.custom => AppIcons.unitOther,
  };
}
