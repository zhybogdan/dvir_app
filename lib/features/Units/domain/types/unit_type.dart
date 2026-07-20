import 'package:freezed_annotation/freezed_annotation.dart';

/// Kind of object, mirroring the `unit_type` Postgres enum.
///
/// [house] exists because a standalone object is most often a private house —
/// one family running its own address with no community around it.
///
/// Carries [dbValue] alongside `@JsonValue` for the same reason as
/// `CommunityType`: rows are read through json_serializable, but `create_unit`
/// takes the type as an RPC argument and has to write it back.
enum UnitType {
  @JsonValue('house')
  house('house'),
  @JsonValue('apartment')
  apartment('apartment'),
  @JsonValue('plot')
  plot('plot'),
  @JsonValue('garage')
  garage('garage'),
  @JsonValue('office')
  office('office'),
  @JsonValue('custom')
  custom('custom');

  const UnitType(this.dbValue);

  final String dbValue;
}
