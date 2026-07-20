import 'package:freezed_annotation/freezed_annotation.dart';

/// Kind of object, mirroring the `unit_type` Postgres enum.
///
/// [house] exists because a standalone object is most often a private house —
/// one family running its own address with no community around it.
///
/// The `@JsonValue` literals are the database values; changing one without a
/// migration silently breaks every insert and read.
enum UnitType {
  @JsonValue('house')
  house,
  @JsonValue('apartment')
  apartment,
  @JsonValue('plot')
  plot,
  @JsonValue('garage')
  garage,
  @JsonValue('office')
  office,
  @JsonValue('custom')
  custom,
}
