import 'package:freezed_annotation/freezed_annotation.dart';

/// Kind of community, mirroring the `community_type` Postgres enum.
///
/// The `@JsonValue` literals are the database values — changing one here
/// without a migration silently breaks every insert and read.
enum CommunityType {
  @JsonValue('osbb')
  osbb,
  @JsonValue('residential_complex')
  residentialComplex,
  @JsonValue('dacha_cooperative')
  dachaCooperative,
  @JsonValue('garage_cooperative')
  garageCooperative,
  @JsonValue('cottage_town')
  cottageTown,
  @JsonValue('dormitory')
  dormitory,
  @JsonValue('custom')
  custom,
}
