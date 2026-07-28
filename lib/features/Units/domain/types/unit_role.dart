import 'package:freezed_annotation/freezed_annotation.dart';

/// Who a person is inside an object (`unit_role` Postgres enum).
///
/// The tenant / owner split is not cosmetic: a tenant reads everything about
/// the object but has no vote at the assembly, because that right follows
/// ownership.
///
/// Carries [dbValue] as well as `@JsonValue` because `set_unit_member_role`
/// takes it as an RPC argument, so the value travels back as well as in.
enum UnitRole {
  @JsonValue('owner')
  owner('owner'),
  @JsonValue('family')
  family('family'),
  @JsonValue('tenant')
  tenant('tenant');

  const UnitRole(this.dbValue);

  final String dbValue;
}
