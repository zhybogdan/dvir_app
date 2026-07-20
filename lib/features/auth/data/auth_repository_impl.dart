import 'dart:io';

import 'package:dvir/core/config/supabase_providers.dart';
import 'package:dvir/core/error/failures.dart';
import 'package:dvir/features/auth/data/auth_repository.dart';
import 'package:dvir/features/auth/domain/models/app_user.dart';
import 'package:dvir/features/auth/domain/types/sign_up_outcome.dart';
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
      throw AuthFailure(_reasonOf(e));
    } on SocketException {
      throw const NetworkFailure();
    } catch (_) {
      throw const UnknownFailure();
    }
  }

  /// GoTrue error codes → domain reasons.
  /// See https://supabase.com/docs/reference/dart/auth-error-codes
  AuthFailureReason _reasonOf(sb.AuthException e) => switch (e.code) {
    'invalid_credentials' => AuthFailureReason.invalidCredentials,
    'user_already_exists' ||
    'email_exists' => AuthFailureReason.emailAlreadyRegistered,
    'weak_password' => AuthFailureReason.weakPassword,
    'email_not_confirmed' => AuthFailureReason.emailNotConfirmed,
    'over_request_rate_limit' ||
    'over_email_send_rate_limit' => AuthFailureReason.tooManyRequests,
    _ => AuthFailureReason.unknown,
  };
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) =>
    AuthRepositoryImpl(ref.watch(supabaseClientProvider));
