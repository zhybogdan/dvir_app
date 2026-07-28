import 'package:freezed_annotation/freezed_annotation.dart';

/// What a member may do inside a community (`member_role` Postgres enum).
/// Permissions themselves are enforced by RLS — this only drives the UI.
///
/// Carries [dbValue] as well as `@JsonValue` because `set_community_member_role`
/// takes it as an RPC argument, so the value travels back as well as in.
enum MemberRole {
  @JsonValue('admin')
  admin('admin'),
  @JsonValue('member')
  member('member'),
  @JsonValue('accountant')
  accountant('accountant'),
  @JsonValue('worker')
  worker('worker');

  const MemberRole(this.dbValue);

  final String dbValue;
}
