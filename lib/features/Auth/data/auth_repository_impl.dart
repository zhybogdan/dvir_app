import 'dart:io';

import 'package:dvir/core/config/supabase_providers.dart';
import 'package:dvir/core/error/failures.dart';
import 'package:dvir/features/Auth/data/auth_failure_mapper.dart';
import 'package:dvir/features/Auth/data/auth_repository.dart';
import 'package:dvir/features/Auth/domain/models/app_user.dart';
import 'package:dvir/features/Auth/domain/types/sign_up_outcome.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

part 'auth_repository_impl.g.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._client);

  final sb.SupabaseClient _client;

  AppUser? _mapUser(sb.User? user) =>
      user == null ? null : AppUser(id: user.id, email: user.email ?? '');

  @override
  Stream<AppUser?> authStateChanges() => _client.auth.onAuthStateChange.map(
    (event) => _mapUser(event.session?.user),
  );

  @override
  Future<void> signIn({required String email, required String password}) =>
      _run(
        () => _client.auth.signInWithPassword(email: email, password: password),
      );

  @override
  Future<SignUpOutcome> signUp({
    required String email,
    required String password,
  }) async {
    final response = await _run(
      () => _client.auth.signUp(email: email, password: password),
    );

    // With "confirm email" enabled Supabase returns a user but no session:
    // there is nothing to redirect to yet, the user has to open the link first.
    return response.session == null
        ? SignUpOutcome.confirmationRequired
        : SignUpOutcome.signedIn;
  }

  @override
  Future<void> signOut() => _run(() => _client.auth.signOut());

  /// Runs a Supabase auth call, translating its low-level errors into typed
  /// [Failure]s so nothing Supabase-shaped escapes the data layer.
  Future<T> _run<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on sb.AuthException catch (e) {
      throw AuthFailure(authFailureReasonFrom(e.code));
    } on SocketException {
      throw const NetworkFailure();
    } catch (_) {
      throw const UnknownFailure();
    }
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) =>
    AuthRepositoryImpl(ref.watch(supabaseClientProvider));
