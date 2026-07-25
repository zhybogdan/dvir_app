import 'package:dvir/core/config/supabase_providers.dart';
import 'package:dvir/core/error/supabase_error_guard.dart';
import 'package:dvir/features/Community/domain/models/community_membership.dart';
import 'package:dvir/features/Community/domain/types/member_role.dart';
import 'package:dvir/features/Members/data/members_repository.dart';
import 'package:dvir/features/Members/domain/models/community_member_view.dart';
import 'package:dvir/features/Members/domain/models/unit_member_view.dart';
import 'package:dvir/features/Shared/domain/models/profile.dart';
import 'package:dvir/features/Shared/domain/types/member_status.dart';
import 'package:dvir/features/Units/domain/models/unit_membership.dart';
import 'package:dvir/features/Units/domain/types/unit_role.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

part 'members_repository_impl.g.dart';

/// Membership columns plus the profile behind them, in one round trip. The
/// embed only became possible in `0004_members_moderation.sql`, which gave both
/// member tables a foreign key to `profiles` for PostgREST to follow.
const String _withProfile = '*, profiles(*)';

class MembersRepositoryImpl implements MembersRepository {
  MembersRepositoryImpl(this._client);

  final sb.SupabaseClient _client;

  @override
  Future<List<CommunityMemberView>> communityMembers(String communityId) =>
      guardSupabase(() async {
        final rows = await _client
            .from('community_members')
            .select(_withProfile)
            .eq('community_id', communityId)
            .order('created_at');

        return rows
            .map(
              (row) => CommunityMemberView(
                membership: CommunityMembership.fromJson(row),
                profile: _profileFrom(row),
              ),
            )
            .toList();
      });

  @override
  Future<List<UnitMemberView>> unitMembers(String unitId) =>
      guardSupabase(() async {
        final rows = await _client
            .from('unit_members')
            .select(_withProfile)
            .eq('unit_id', unitId)
            .order('created_at');

        return rows
            .map(
              (row) => UnitMemberView(
                membership: UnitMembership.fromJson(row),
                profile: _profileFrom(row),
              ),
            )
            .toList();
      });

  @override
  Future<void> setCommunityMemberStatus({
    required String memberId,
    required MemberStatus status,
  }) => guardSupabase(
    () => _client.rpc<void>(
      'set_community_member_status',
      params: {'p_member_id': memberId, 'p_status': status.dbValue},
    ),
  );

  @override
  Future<void> setCommunityMemberRole({
    required String memberId,
    required MemberRole role,
  }) => guardSupabase(
    () => _client.rpc<void>(
      'set_community_member_role',
      params: {'p_member_id': memberId, 'p_role': role.dbValue},
    ),
  );

  @override
  Future<void> setUnitMemberStatus({
    required String memberId,
    required MemberStatus status,
  }) => guardSupabase(
    () => _client.rpc<void>(
      'set_unit_member_status',
      params: {'p_member_id': memberId, 'p_status': status.dbValue},
    ),
  );

  @override
  Future<void> setUnitMemberRole({
    required String memberId,
    required UnitRole role,
  }) => guardSupabase(
    () => _client.rpc<void>(
      'set_unit_member_role',
      params: {'p_member_id': memberId, 'p_role': role.dbValue},
    ),
  );

  @override
  Future<void> removeCommunityMember(String memberId) => guardSupabase(
    () => _client.from('community_members').delete().eq('id', memberId),
  );

  @override
  Future<void> removeUnitMember(String memberId) => guardSupabase(
    () => _client.from('unit_members').delete().eq('id', memberId),
  );

  /// Null when the caller may see the membership but not the person behind it —
  /// see [CommunityMemberView.profile].
  Profile? _profileFrom(Map<String, dynamic> row) {
    final profile = row['profiles'];

    return profile is Map<String, dynamic> ? Profile.fromJson(profile) : null;
  }
}

@Riverpod(keepAlive: true)
MembersRepository membersRepository(Ref ref) =>
    MembersRepositoryImpl(ref.watch(supabaseClientProvider));
