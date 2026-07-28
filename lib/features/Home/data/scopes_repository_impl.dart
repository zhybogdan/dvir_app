import 'package:dvir/core/config/supabase_providers.dart';
import 'package:dvir/core/error/supabase_error_guard.dart';
import 'package:dvir/features/Community/domain/models/community.dart';
import 'package:dvir/features/Community/domain/models/community_membership.dart';
import 'package:dvir/features/Home/data/scopes_repository.dart';
import 'package:dvir/features/Home/domain/models/scope_summary.dart';
import 'package:dvir/features/Units/data/unit_columns.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/features/Units/domain/models/unit_membership.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

part 'scopes_repository_impl.g.dart';

class ScopesRepositoryImpl implements ScopesRepository {
  ScopesRepositoryImpl(this._client);

  final sb.SupabaseClient _client;

  @override
  Future<List<ScopeSummary>> myScopes() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return const [];

    return guardSupabase(() async {
      // Filtering by `user_id` is not the hand-written tenant filter the
      // project bans: RLS lets a member see their co-members' rows too, so
      // without it this would collect other people's memberships.
      // `ascending` defaults to *false* in postgrest-dart, so it is spelled out
      // here and everywhere else: the list reads in the order the person joined,
      // which is what makes the newest request the last one.
      //
      // Sent together rather than one after the other: neither reads the
      // other's answer, so awaiting them in turn just adds one round trip to
      // every open and every refresh of this screen.
      //
      // `Future.wait` rather than the record's `.wait`, which would wrap a
      // failure in a `ParallelWaitError`. That would hide the
      // `PostgrestException` from `guardSupabase` and every backend error here
      // would degrade to "unexpected".
      final responses = await Future.wait([
        _client
            .from('community_members')
            .select('*, communities(*)')
            .eq('user_id', userId)
            .order('created_at', ascending: true),
        _client
            .from('unit_members')
            .select('*, units($unitColumns)')
            .eq('user_id', userId)
            .order('created_at', ascending: true),
      ]);

      final communities = responses.first;
      final units = responses.last;

      return [
        for (final row in communities)
          ScopeSummary.community(
            membership: CommunityMembership.fromJson(row),
            community: _embedded(row, 'communities', Community.fromJson),
          ),
        for (final row in units)
          ScopeSummary.unit(
            membership: UnitMembership.fromJson(row),
            unit: _embedded(row, 'units', Unit.fromJson),
          ),
      ];
    });
  }

  /// The joined scope, or null when RLS refused it — which is the normal answer
  /// for a membership that is not active yet.
  T? _embedded<T>(
    Map<String, dynamic> row,
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final value = row[key];

    return value is Map<String, dynamic> ? fromJson(value) : null;
  }
}

@Riverpod(keepAlive: true)
ScopesRepository scopesRepository(Ref ref) =>
    ScopesRepositoryImpl(ref.watch(supabaseClientProvider));
