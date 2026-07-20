/// Base type for all domain-level failures.
///
/// Data sources translate low-level errors (e.g. `PostgrestException`,
/// `AuthException`, `SocketException`) into these and throw them. Riverpod's
/// [AsyncValue] catches the throw and the UI renders the text via the
/// `FailureL10n` extension.
///
/// Failures carry a *cause*, never a user-facing string: the wording lives in
/// the arb files, so backend English never reaches the screen.
sealed class Failure implements Exception {
  const Failure();
}

/// No / lost internet connection.
final class NetworkFailure extends Failure {
  const NetworkFailure();
}

/// Backend rejected the request or returned an unexpected response.
final class ServerFailure extends Failure {
  const ServerFailure();
}

/// Sign in / sign up / session problems.
final class AuthFailure extends Failure {
  const AuthFailure(this.reason);

  final AuthFailureReason reason;

  @override
  String toString() => 'AuthFailure($reason)';
}

/// Requested entity does not exist (or is not visible under RLS).
final class NotFoundFailure extends Failure {
  const NotFoundFailure();
}

/// Creating or joining a scope (a community or an object) was rejected.
final class ScopeFailure extends Failure {
  const ScopeFailure(this.reason);

  final ScopeFailureReason reason;

  @override
  String toString() => 'ScopeFailure($reason)';
}

/// Anything we did not anticipate.
final class UnknownFailure extends Failure {
  const UnknownFailure();
}

/// Why an auth call was rejected. Data sources map Supabase (GoTrue) error
/// codes onto this, so adding a locale never means touching the data layer.
enum AuthFailureReason {
  invalidCredentials,
  emailAlreadyRegistered,
  emailAddressInvalid,
  weakPassword,
  emailNotConfirmed,
  tooManyRequests,
  signUpDisabled,
  unknown,
}

/// Why a scope call was rejected. The bootstrap RPCs raise custom SQLSTATEs
/// (`DV001`…`DV003`) precisely so this mapping never depends on the wording of
/// a Postgres error message.
enum ScopeFailureReason {
  /// No community and no object carries this invite code.
  invalidInviteCode,

  /// The caller is not an admin of the community / owner of the object.
  notAllowed,

  /// The session expired between opening the form and submitting it.
  notAuthenticated,

  unknown,
}
