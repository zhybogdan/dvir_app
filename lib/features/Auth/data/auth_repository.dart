import 'package:dvir/features/Auth/domain/models/app_user.dart';
import 'package:dvir/features/Auth/domain/types/sign_up_outcome.dart';

/// Contract for authentication (Base). The `application` layer depends on this,
/// never on Supabase directly.
abstract interface class AuthRepository {
  /// Emits the current user on every sign-in / sign-out (null when signed out).
  /// Replays the restored session on listen, so the first frame already knows.
  Stream<AppUser?> authStateChanges();

  Future<void> signIn({required String email, required String password});

  Future<SignUpOutcome> signUp({
    required String email,
    required String password,
  });

  Future<void> signOut();
}
