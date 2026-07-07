import 'package:dvir/features/auth/domain/models/app_user.dart';

/// Contract for authentication (Base). The `application` layer depends on this,
/// never on Supabase directly.
abstract interface class AuthRepository {
  /// Emits the current user on every sign-in / sign-out (null when signed out).
  Stream<AppUser?> authStateChanges();

  /// The user restored from local storage at startup, if any.
  AppUser? get currentUser;

  Future<void> signIn({required String email, required String password});

  Future<void> signUp({required String email, required String password});

  Future<void> signOut();
}
