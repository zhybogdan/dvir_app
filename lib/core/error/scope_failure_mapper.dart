import 'package:dvir/core/error/failures.dart';

/// Postgres SQLSTATEs → domain reasons.
///
/// The scope RPCs raise custom codes (`0002_units_as_scopes.sql`,
/// `0004_members_moderation.sql`) instead of relying on their message text, so
/// rewording an exception in SQL can never change what the user is told.
///
/// `42501` is Postgres' own `insufficient_privilege`, which is what a blocked
/// RLS write surfaces as — the same "you may not do this" from the user's side.
ScopeFailureReason scopeFailureReasonFrom(String? code) => switch (code) {
  'DV001' => ScopeFailureReason.invalidInviteCode,
  'DV002' || '42501' => ScopeFailureReason.notAllowed,
  'DV003' => ScopeFailureReason.notAuthenticated,
  'DV004' => ScopeFailureReason.lastAdmin,
  'DV005' => ScopeFailureReason.selfModeration,
  _ => ScopeFailureReason.unknown,
};
