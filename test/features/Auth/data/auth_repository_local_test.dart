import 'package:dvir/core/config/local_identity.dart';
import 'package:dvir/features/Auth/data/auth_repository_local.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const repository = LocalAuthRepository();

  test('somebody is always signed in, and it is the local person', () async {
    final user = await repository.authStateChanges().first;

    // The id has to be exactly this: `myUnitRole` compares it against the
    // residents list, and a mismatch leaves the keeper of a house unable to add
    // anything to it — with no error to explain why.
    expect(user?.id, localUserId);
  });

  test('the answer arrives without waiting for a network', () async {
    // The router holds the splash until auth resolves, so a stream that only
    // emitted later would be a blank screen for as long as it took.
    expect(repository.authStateChanges(), emits(isNotNull));
  });

  test('there is no account to sign in to, out of, or up for', () {
    expect(
      () => repository.signIn(email: 'a@b.c', password: 'secret'),
      throwsUnsupportedError,
    );
    expect(
      () => repository.signUp(email: 'a@b.c', password: 'secret'),
      throwsUnsupportedError,
    );
    expect(repository.signOut, throwsUnsupportedError);
  });
}
