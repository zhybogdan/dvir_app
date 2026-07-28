import 'package:dvir/core/config/supabase_providers.dart';
import 'package:dvir/core/error/failures.dart';
import 'package:dvir/core/error/supabase_error_guard.dart';
import 'package:dvir/features/Profile/data/profile_repository.dart';
import 'package:dvir/features/Shared/domain/models/profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

part 'profile_repository_impl.g.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._client);

  final sb.SupabaseClient _client;

  @override
  Future<Profile> myProfile() => _forCurrentUser((userId) async {
    final row = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    // The signup trigger writes this row, so a missing one means the session
    // outlived the account behind it.
    if (row == null) throw const NotFoundFailure();

    return Profile.fromJson(row);
  });

  @override
  Future<Profile> save({String? fullName, String? phone}) =>
      _forCurrentUser((userId) async {
        final row = await _client
            .from('profiles')
            .update({'full_name': fullName, 'phone': phone})
            .eq('id', userId)
            .select()
            .single();

        return Profile.fromJson(row);
      });

  /// Runs [call] with the signed-in user's id, failing before the network when
  /// there is none.
  ///
  /// Filtering by that id is not the hand-written tenant filter the project
  /// bans: RLS lets a person read their co-residents' profiles too, so without
  /// it a write would be trusting the policy to have picked the right row.
  Future<Profile> _forCurrentUser(
    Future<Profile> Function(String userId) call,
  ) {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw const ScopeFailure(ScopeFailureReason.notAuthenticated);
    }

    return guardSupabase(() => call(userId));
  }
}

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) =>
    ProfileRepositoryImpl(ref.watch(supabaseClientProvider));
