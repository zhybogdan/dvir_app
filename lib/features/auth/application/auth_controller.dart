import 'dart:async';

import 'package:dvir/features/auth/data/auth_repository_impl.dart';
import 'package:dvir/features/auth/domain/models/app_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

/// Current signed-in user as a stream (null when signed out).
/// The router and any UI that needs "who am I" watch this.
@riverpod
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
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .signIn(email: email, password: password),
    );
  }

  Future<void> signUp({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .signUp(email: email, password: password),
    );
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).signOut(),
    );
  }
}
