import 'package:freezed_annotation/freezed_annotation.dart';

/// Kind of object, mirroring the `unit_type` Postgres enum.
///
/// Covers both what stands at an address and what is inside it: a household
/// record is as much about the cellar and the summer kitchen as about the house
/// itself. The object's *name* is free text — this only fixes its category, so
/// that an icon can be picked and rooms can one day be counted and totalled
/// apart from outbuildings. Anything unforeseen goes under [custom].
///
/// Declaration order is the order of the picker, and it is **grouped**: the
/// sheet draws a heading wherever the group changes and reads the list as
/// given, so a value moved out of its run would split its own heading in two.
/// See `UnitTypeL10n.groupLabel`.
///
/// Reordering is safe — nothing persists an index; `@JsonValue` is what travels.
///
/// Carries [dbValue] alongside `@JsonValue` for the same reason as
/// `CommunityType`: rows are read through json_serializable, but `create_unit`
/// takes the type as an RPC argument and has to write it back.
enum UnitType {
  // Стоїть за адресою.
  @JsonValue('house')
  house('house'),
  @JsonValue('apartment')
  apartment('apartment'),
  @JsonValue('plot')
  plot('plot'),

  // Усередині.
  @JsonValue('room')
  room('room'),
  @JsonValue('bathroom')
  bathroom('bathroom'),
  @JsonValue('corridor')
  corridor('corridor'),
  @JsonValue('storeroom')
  storeroom('storeroom'),
  @JsonValue('balcony')
  balcony('balcony'),
  @JsonValue('loggia')
  loggia('loggia'),
  @JsonValue('basement')
  basement('basement'),

  // Окремі споруди.
  @JsonValue('garage')
  garage('garage'),
  @JsonValue('summer_kitchen')
  summerKitchen('summer_kitchen'),
  @JsonValue('summer_house')
  summerHouse('summer_house'),
  @JsonValue('shed')
  shed('shed'),
  @JsonValue('pool')
  pool('pool'),

  @JsonValue('office')
  office('office'),
  @JsonValue('custom')
  custom('custom');

  const UnitType(this.dbValue);

  final String dbValue;
}
