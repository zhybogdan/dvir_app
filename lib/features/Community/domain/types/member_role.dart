import 'package:freezed_annotation/freezed_annotation.dart';

/// What a member may do inside a community (`member_role` Postgres enum).
/// Permissions themselves are enforced by RLS — this only drives the UI.
enum MemberRole {
  @JsonValue('admin')
  admin,
  @JsonValue('member')
  member,
  @JsonValue('accountant')
  accountant,
  @JsonValue('worker')
  worker,
}
