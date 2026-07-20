import 'package:freezed_annotation/freezed_annotation.dart';

/// Who a person is inside an object (`unit_role` Postgres enum).
///
/// The tenant / owner split is not cosmetic: a tenant reads everything about
/// the object but has no vote at the assembly, because that right follows
/// ownership.
enum UnitRole {
  @JsonValue('owner')
  owner,
  @JsonValue('family')
  family,
  @JsonValue('tenant')
  tenant,
}
