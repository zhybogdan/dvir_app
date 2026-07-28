import 'package:dvir/features/Community/domain/models/community.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'created_scope.freezed.dart';

/// A scope the user has just created, held only long enough for the success
/// screen to show its invite code.
///
/// Sealed like `ScopeMembership`: the success screen words its title and hint
/// per kind, so a third kind must not compile until it has been worded.
@freezed
sealed class CreatedScope with _$CreatedScope {
  const CreatedScope._();

  const factory CreatedScope.community(Community community) = CreatedCommunity;

  const factory CreatedScope.unit(Unit unit) = CreatedUnit;

  /// What the scope is called — the two models spell it differently.
  String get name => switch (this) {
    CreatedCommunity(:final community) => community.name,
    CreatedUnit(:final unit) => unit.label,
  };

  /// Nullable only because an object read back from a list carries no code
  /// since `0005`. A freshly created one always does — `create_unit` returns
  /// the row it wrote, and that path bypasses the column privilege.
  String? get inviteCode => switch (this) {
    CreatedCommunity(:final community) => community.inviteCode,
    CreatedUnit(:final unit) => unit.inviteCode,
  };
}
