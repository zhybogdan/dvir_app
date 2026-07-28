import 'package:freezed_annotation/freezed_annotation.dart';

/// Kind of object, mirroring the `unit_type` Postgres enum.
///
/// Covers both what stands at an address and what is inside it: a household
/// record is as much about the cellar and the summer kitchen as about the house
/// itself. The object's *name* is free text — this only fixes its category, so
/// that an icon can be picked and rooms can one day be counted and totalled
/// apart from outbuildings. Anything unforeseen goes under [custom].
///
/// Declaration order is the order of the picker, so the likely choices come
/// first and [custom] comes last.
///
/// Carries [dbValue] alongside `@JsonValue` for the same reason as
/// `CommunityType`: rows are read through json_serializable, but `create_unit`
/// takes the type as an RPC argument and has to write it back.
enum UnitType {
  @JsonValue('house')
  house('house'),
  @JsonValue('apartment')
  apartment('apartment'),
  @JsonValue('room')
  room('room'),
  @JsonValue('garage')
  garage('garage'),
  @JsonValue('plot')
  plot('plot'),
  @JsonValue('basement')
  basement('basement'),
  @JsonValue('summer_kitchen')
  summerKitchen('summer_kitchen'),
  @JsonValue('summer_house')
  summerHouse('summer_house'),
  @JsonValue('shed')
  shed('shed'),
  @JsonValue('pool')
  pool('pool'),
  @JsonValue('balcony')
  balcony('balcony'),
  @JsonValue('loggia')
  loggia('loggia'),
  @JsonValue('bathroom')
  bathroom('bathroom'),
  @JsonValue('corridor')
  corridor('corridor'),
  @JsonValue('storeroom')
  storeroom('storeroom'),
  @JsonValue('office')
  office('office'),
  @JsonValue('custom')
  custom('custom');

  const UnitType(this.dbValue);

  final String dbValue;
}
