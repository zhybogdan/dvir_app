import 'package:freezed_annotation/freezed_annotation.dart';

/// Kind of community, mirroring the `community_type` Postgres enum.
///
/// Carries [dbValue] as well as `@JsonValue` because this enum travels both
/// ways: json_serializable reads it off a row, and `create_community` needs it
/// written back as an RPC argument. The two literals sit on one line so they
/// cannot quietly drift apart. Changing either without a migration silently
/// breaks every insert and read.
enum CommunityType {
  @JsonValue('osbb')
  osbb('osbb'),
  @JsonValue('residential_complex')
  residentialComplex('residential_complex'),
  @JsonValue('dacha_cooperative')
  dachaCooperative('dacha_cooperative'),
  @JsonValue('garage_cooperative')
  garageCooperative('garage_cooperative'),
  @JsonValue('cottage_town')
  cottageTown('cottage_town'),
  @JsonValue('dormitory')
  dormitory('dormitory'),
  @JsonValue('custom')
  custom('custom');

  const CommunityType(this.dbValue);

  final String dbValue;
}
