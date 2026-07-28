import 'package:dvir/features/Units/domain/types/unit_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'unit.freezed.dart';
part 'unit.g.dart';

/// An object — a house, apartment, plot or garage.
///
/// Both nullable ids carry meaning:
/// - [communityId] null → the object stands alone, owned by its residents and
///   belonging to no community;
/// - [parentId] null → it is a top-level object rather than something inside a
///   house.
///
/// [inviteCode] is null on anything that was read rather than created: since
/// `0005` the column is not readable off the row at all, and only
/// `create_unit` — which returns its own result — and the owner-only
/// `unit_invite_code()` RPC hand it over.
@freezed
abstract class Unit with _$Unit {
  const factory Unit({
    required String id,
    required String label,
    required UnitType type,
    @JsonKey(name: 'invite_code') String? inviteCode,
    @JsonKey(name: 'community_id') String? communityId,
    @JsonKey(name: 'parent_id') String? parentId,
    String? address,
    String? city,
    @JsonKey(name: 'area_m2') double? areaM2,
  }) = _Unit;

  factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);
}
