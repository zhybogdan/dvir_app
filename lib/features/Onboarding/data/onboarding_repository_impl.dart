import 'dart:io';

import 'package:dvir/core/config/supabase_providers.dart';
import 'package:dvir/core/error/failures.dart';
import 'package:dvir/core/logging/app_logger.dart';
import 'package:dvir/features/Community/domain/models/community.dart';
import 'package:dvir/features/Community/domain/models/community_membership.dart';
import 'package:dvir/features/Community/domain/types/community_type.dart';
import 'package:dvir/features/Onboarding/data/onboarding_failure_mapper.dart';
import 'package:dvir/features/Onboarding/data/onboarding_repository.dart';
import 'package:dvir/features/Onboarding/domain/models/scope_membership.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/features/Units/domain/models/unit_membership.dart';
import 'package:dvir/features/Units/domain/types/unit_type.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

part 'onboarding_repository_impl.g.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl(this._client);

  final sb.SupabaseClient _client;

  @override
  Stream<ScopeMembership?> watchMyMembership() =>
      Stream.fromFuture(_fetchMyMembership());

  @override
  Future<Community> createCommunity({
    required String name,
    required CommunityType type,
    String? address,
    String? city,
  }) => _run(() async {
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
  Future<Unit> createUnit({
    required String label,
    required UnitType type,
    String? parentId,
    String? communityId,
    String? address,
    String? city,
    double? areaM2,
  }) => _run(() async {
    final row = await _client.rpc<Map<String, dynamic>>(
      'create_unit',
      params: {
        'p_label': label,
        'p_type': type.dbValue,
        'p_parent_id': parentId,
        'p_community_id': communityId,
        'p_address': address,
        'p_city': city,
        'p_area_m2': areaM2,
      },
    );

    return Unit.fromJson(row);
  });

  @override
  Future<ScopeMembership> joinByInvite(String inviteCode) => _run(() async {
    final result = await _client.rpc<Map<String, dynamic>>(
      'join_by_invite',
      params: {'p_invite_code': inviteCode},
    );

    return _scopeFrom(result);
  });

  /// The user's single scope, community first.
  ///
  /// Filtering by `user_id` is not the hand-written tenant filter the project
  /// bans: RLS lets a member see their co-members too, so without it this would
  /// return somebody else's row.
  Future<ScopeMembership?> _fetchMyMembership() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    return _run(() async {
      final community = await _client
          .from('community_members')
          .select()
          .eq('user_id', userId)
          .order('created_at')
          .limit(1)
          .maybeSingle();

      if (community != null) {
        return ScopeMembership.community(
          CommunityMembership.fromJson(community),
        );
      }

      final unit = await _client
          .from('unit_members')
          .select()
          .eq('user_id', userId)
          .order('created_at')
          .limit(1)
          .maybeSingle();

      return unit == null
          ? null
          : ScopeMembership.unit(UnitMembership.fromJson(unit));
    });
  }

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

  /// Runs a Supabase call, translating its low-level errors into typed
  /// [Failure]s so nothing Supabase-shaped escapes the data layer.
  ///
  /// Every branch rethrows with the *original* stack trace: a bare `throw`
  /// inside a `catch` restarts the trace here, which would point every failure
  /// at this method instead of at the call that actually broke.
  Future<T> _run<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on sb.PostgrestException catch (error, stackTrace) {
      // The backend message is English and never reaches the UI, but it is the
      // only clue left when the code is one we don't map yet.
      appLogger.d('Postgres rejected a call: ${error.code} ${error.message}');
      Error.throwWithStackTrace(
        ScopeFailure(scopeFailureReasonFrom(error.code)),
        stackTrace,
      );
    } on http.ClientException catch (error, stackTrace) {
      // PostgREST does not wrap transport failures the way GoTrue does, so a
      // dead connection arrives as the HTTP client's own exception.
      appLogger.d('Could not reach Supabase: ${error.message}');
      Error.throwWithStackTrace(const NetworkFailure(), stackTrace);
    } on SocketException catch (_, stackTrace) {
      // Belt and braces: a raw socket error would otherwise be misfiled as
      // "unexpected".
      Error.throwWithStackTrace(const NetworkFailure(), stackTrace);
    } catch (error, stackTrace) {
      appLogger.e(
        'Unexpected error during a Supabase call',
        error: error,
        stackTrace: stackTrace,
      );
      Error.throwWithStackTrace(const UnknownFailure(), stackTrace);
    }
  }
}

@Riverpod(keepAlive: true)
OnboardingRepository onboardingRepository(Ref ref) =>
    OnboardingRepositoryImpl(ref.watch(supabaseClientProvider));
