import 'package:dvir/core/config/local_identity.dart';
import 'package:dvir/features/Auth/data/auth_repository.dart';
import 'package:dvir/features/Auth/domain/models/app_user.dart';
import 'package:dvir/features/Auth/domain/types/sign_up_outcome.dart';

/// The one person using this build (Impl).
///
/// There is no account, and the app still has to answer "who am I" twice over:
/// the router waits for it before deciding anything, and `myUnitRole` compares
/// it against the residents list to decide what the hub offers. Both get the
/// same [localUserId], and that agreement is what makes the keeper of a house
/// able to add a paper to it.
///
/// [email] is empty because there is no address to give. Nothing displays it —
/// the profile shows a name and a phone number — and inventing one would put a
/// fiction on screen the day something does.
class LocalAuthRepository implements AuthRepository {
  const LocalAuthRepository();

  /// One value, never changed: nobody signs in or out of a database kept in the
  /// app's own folder. A new stream per call, so a second listener gets its own.
  @override
  Stream<AppUser?> authStateChanges() =>
      Stream.value(const AppUser(id: localUserId, email: ''));

  @override
  Future<void> signIn({required String email, required String password}) =>
      throw UnsupportedError('This build has no accounts.');

  @override
  Future<SignUpOutcome> signUp({
    required String email,
    required String password,
  }) => throw UnsupportedError('This build has no accounts.');

  @override
  Future<void> signOut() =>
      throw UnsupportedError('This build has no accounts.');
}
