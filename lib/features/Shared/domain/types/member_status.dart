import 'package:freezed_annotation/freezed_annotation.dart';

/// Where a join request stands (`member_status` Postgres enum).
///
/// Shared by both scopes on purpose: the database uses one enum for
/// `community_members` and `unit_members`, and joining either follows the same
/// pending → active flow.
///
/// Only [active] grants access to a scope's content; the other three all mean
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
