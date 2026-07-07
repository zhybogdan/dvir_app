/// Base type for all domain-level failures.
///
/// Data sources translate low-level errors (e.g. `PostgrestException`,
/// `AuthException`, `SocketException`) into these and throw them. Riverpod's
/// [AsyncValue] catches the throw and the UI renders a message via
/// `.when(error: ...)` — so we get typed errors without a `Result` wrapper.
sealed class Failure implements Exception {
  const Failure(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// No / lost internet connection.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

/// Backend rejected the request or returned an unexpected response.
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went wrong on the server']);
}

/// Sign in / sign up / session problems.
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed']);
}

/// Requested entity does not exist (or is not visible under RLS).
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Not found']);
}

/// Anything we did not anticipate.
class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Unexpected error']);
}
