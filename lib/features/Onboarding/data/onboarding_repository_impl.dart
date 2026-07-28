import 'package:dvir/core/config/supabase_providers.dart';
import 'package:dvir/core/error/failures.dart';
import 'package:dvir/core/error/supabase_error_guard.dart';
import 'package:dvir/features/Community/domain/models/community.dart';
import 'package:dvir/features/Community/domain/models/community_membership.dart';
import 'package:dvir/features/Community/domain/types/community_type.dart';
import 'package:dvir/features/Onboarding/data/onboarding_repository.dart';
import 'package:dvir/features/Onboarding/domain/models/scope_membership.dart';
import 'package:dvir/features/Units/domain/models/unit_membership.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

part 'onboarding_repository_impl.g.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl(this._client);

  final sb.SupabaseClient _client;

  @override
  Future<Community> createCommunity({
    required String name,
    required CommunityType type,
    String? address,
    String? city,
  }) => guardSupabase(() async {
    final row = await _client.rpc<Map<String, dynamic>>(
      'create_community',
      params: {
        'p_name': name,
        'p_type': type.dbValue,
        'p_address': address,
        'p_city': city,
      },
    );

    return Community.fromJson(row);
  });

  @override
  Future<ScopeMembership> joinByInvite(String inviteCode) =>
      guardSupabase(() async {
        final result = await _client.rpc<Map<String, dynamic>>(
          'join_by_invite',
          params: {'p_invite_code': inviteCode},
        );

        return _scopeFrom(result);
      });

  /// `join_by_invite` returns `{"scope": ..., "membership": {...}}` — the two
  /// branches carry different row types, so the payload is jsonb rather than a
  /// composite.
  ScopeMembership _scopeFrom(Map<String, dynamic> result) {
    final membership = result['membership'] as Map<String, dynamic>;

    return switch (result['scope']) {
      'community' => ScopeMembership.community(
        CommunityMembership.fromJson(membership),
      ),
      'unit' => ScopeMembership.unit(UnitMembership.fromJson(membership)),
      // Only reachable if the RPC grows a third scope and the app is older
      // than the database.
      _ => throw const ServerFailure(),
    };
  }
}

@Riverpod(keepAlive: true)
OnboardingRepository onboardingRepository(Ref ref) =>
    OnboardingRepositoryImpl(ref.watch(supabaseClientProvider));
