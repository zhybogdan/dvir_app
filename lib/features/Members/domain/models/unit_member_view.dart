import 'package:dvir/features/Shared/domain/models/profile.dart';
import 'package:dvir/features/Units/domain/models/unit_membership.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'unit_member_view.freezed.dart';

/// One row of an object's residents list — the counterpart of
/// `CommunityMemberView`, nullable [profile] included and for the same reason.
@freezed
abstract class UnitMemberView with _$UnitMemberView {
  const factory UnitMemberView({
    required UnitMembership membership,
    Profile? profile,
  }) = _UnitMemberView;
}
