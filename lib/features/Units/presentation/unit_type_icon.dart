import 'package:dvir/app/icons.dart';
import 'package:dvir/features/Units/domain/types/unit_type.dart';
import 'package:flutter/material.dart';

/// The glyph a [UnitType] is drawn with.
///
/// Beside `UnitTypeL10n` and for the same reason: the enum stays a plain list
/// of database values, and how a type looks is a UI concern. The switch is
/// exhaustive, so a new type does not compile until it is given a glyph.
///
/// Several types share one — a house and a summer house, a basement and a
/// storeroom — because Material has no separate drawing for them. Where the
/// icon set does, they part here without anything else changing.
extension UnitTypeIcon on UnitType {
  IconData get icon => switch (this) {
    UnitType.house || UnitType.summerHouse => AppIcons.unitHouse,
    UnitType.apartment => AppIcons.unitApartment,
    UnitType.room || UnitType.corridor => AppIcons.unitRoom,
    UnitType.garage => AppIcons.unitGarage,
    UnitType.plot => AppIcons.unitPlot,
    UnitType.basement || UnitType.storeroom => AppIcons.unitStorage,
    UnitType.summerKitchen => AppIcons.unitSummerKitchen,
    UnitType.shed => AppIcons.unitShed,
    UnitType.pool => AppIcons.unitPool,
    UnitType.balcony || UnitType.loggia => AppIcons.unitBalcony,
    UnitType.bathroom => AppIcons.unitBathroom,
    UnitType.office => AppIcons.unitOffice,
    UnitType.custom => AppIcons.unitOther,
  };
}
