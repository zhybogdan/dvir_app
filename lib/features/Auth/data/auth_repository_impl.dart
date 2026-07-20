import 'dart:io';

import 'package:dvir/core/config/supabase_providers.dart';
import 'package:dvir/core/error/failures.dart';
import 'package:dvir/core/logging/app_logger.dart';
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
  ///
  /// Every branch rethrows with the *original* stack trace: a bare `throw`
  /// inside a `catch` restarts the trace here, which would point every failure
  /// at this method instead of at the call that actually broke.
  Future<T> _run<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on sb.AuthRetryableFetchException catch (error, stackTrace) {
      // GoTrue wraps every transport failure (DNS, timeout, refused socket)
      // into this subclass of `AuthException` and leaves `code` empty, so it
      // has to be caught *before* the general branch below — otherwise every
      // connectivity problem is reported to the user as an auth error.
      appLogger.d('Auth call could not reach Supabase: ${error.message}');
      Error.throwWithStackTrace(const NetworkFailure(), stackTrace);
    } on sb.AuthException catch (error, stackTrace) {
      // The backend message is English and never reaches the UI, but it is the
      // only clue left when the code is one we don't map yet.
      appLogger.d('Supabase rejected an auth call: ${error.message}');
      Error.throwWithStackTrace(
        AuthFailure(authFailureReasonFrom(error.code)),
        stackTrace,
      );
    } on SocketException catch (_, stackTrace) {
      // Belt and braces: calls that go through GoTrue never land here, but a
      // raw socket error would otherwise be misfiled as "unexpected".
      Error.throwWithStackTrace(const NetworkFailure(), stackTrace);
    } catch (error, stackTrace) {
      // Not a case we anticipated — the raw error is all we will ever have.
      appLogger.e(
        'Unexpected error during an auth call',
        error: error,
        stackTrace: stackTrace,
      );
      Error.throwWithStackTrace(const UnknownFailure(), stackTrace);
    }
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) =>
    AuthRepositoryImpl(ref.watch(supabaseClientProvider));
