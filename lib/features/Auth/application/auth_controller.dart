import 'dart:async';

import 'package:dvir/features/Auth/data/auth_repository_impl.dart';
import 'package:dvir/features/Auth/domain/models/app_user.dart';
import 'package:dvir/features/Auth/domain/types/sign_up_outcome.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

/// Current signed-in user as a stream (null when signed out).
/// The router and any UI that needs "who am I" watch this.
@Riverpod(keepAlive: true)
Stream<AppUser?> authState(Ref ref) =>
    ref.watch(authRepositoryProvider).authStateChanges();

/// Drives auth actions and exposes their loading / error state.
///
/// `AsyncValue.guard` runs the future and captures success or the thrown
/// [Failure] into `state`, so screens react with `.isLoading` / `.hasError`
/// without manual try/catch. On success the auth stream changes and the router
/// redirect handles navigation — the controller never navigates itself.
@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {}

  Future<void> signIn({required String email, required String password}) async {
    final repository = ref.read(authRepositoryProvider);

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => repository.signIn(email: email, password: password),
    );
  }

  /// Returns the outcome so the caller can tell "signed in" (router redirects)
  /// from "confirm your email" (stay put, show a notice); null means the call
  /// failed and the reason is in `state`.
  Future<SignUpOutcome?> signUp({
    required String email,
    required String password,
  }) async {
    final repository = ref.read(authRepositoryProvider);

    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => repository.signUp(email: email, password: password),
    );
    state = result;

    return result.value;
  }

  Future<void> signOut() async {
    final repository = ref.read(authRepositoryProvider);

    state = const AsyncLoading();
    state = await AsyncValue.guard(repository.signOut);
  }
}
