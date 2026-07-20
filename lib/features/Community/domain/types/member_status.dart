import 'package:freezed_annotation/freezed_annotation.dart';

/// Where a join request stands (`member_status` Postgres enum).
///
/// Only [active] grants access to community content; the other three all mean
/// "no access", but the router sends them to different screens.
enum MemberStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('active')
  active,
  @JsonValue('rejected')
  rejected,
  @JsonValue('blocked')
  blocked,
}
