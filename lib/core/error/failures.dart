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

/// A file could not be stored, read back or removed.
final class StorageFailure extends Failure {
  const StorageFailure(this.reason);

  final StorageFailureReason reason;

  @override
  String toString() => 'StorageFailure($reason)';
}

/// A backup file could not be written, read back or restored.
final class BackupFailure extends Failure {
  const BackupFailure(this.reason);

  final BackupFailureReason reason;

  @override
  String toString() => 'BackupFailure($reason)';
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
/// (`DV001`…`DV005`) precisely so this mapping never depends on the wording of
/// a Postgres error message.
enum ScopeFailureReason {
  /// No community and no object carries this invite code.
  invalidInviteCode,

  /// The caller is not an admin of the community / owner of the object.
  notAllowed,

  /// The session expired between opening the form and submitting it.
  notAuthenticated,

  /// The change would leave the scope with nobody able to run it — the last
  /// admin of a community, or the last owner of an object.
  lastAdmin,

  /// A moderator tried to approve, reject or block their own membership.
  selfModeration,

  unknown,
}

/// Why a Storage call was rejected. Storage has no SQLSTATEs to raise, so this
/// is mapped from HTTP status codes — see `storage_failure_mapper.dart`.
enum StorageFailureReason {
  /// Over the bucket's `file_size_limit` — 20 MB since `0010`.
  tooLarge,

  /// A type the bucket's `allowed_mime_types` does not list.
  typeNotAllowed,

  /// The object is not there: a row that outlived its file.
  missing,

  /// The storage policies refused — not a keeper of the object that owns the
  /// file.
  notAllowed,

  /// The file came down but the device has nothing to show it with. Not a
  /// Storage answer at all; it shares this type because from the reader's side
  /// it is the same sentence — the file did not open.
  cannotOpen,

  unknown,
}

/// Why a backup was refused.
///
/// Nothing maps onto this from a backend — a copy is written and read by this
/// app alone — so what is left are the file the person picked, the device's own
/// storage, and how far a restore got before it stopped. That last one is the
/// reason there are two of them: after the rows are in, "nothing changed" would
/// be false.
enum BackupFailureReason {
  /// Not a zip, or a zip with none of our parts in it — the person picked the
  /// wrong file.
  notABackup,

  /// Written by a newer build, which may keep columns this one would drop on
  /// restoring. Refused rather than read partially.
  fromNewerApp,

  /// The copy could not be written. Room on the device, most likely: an export
  /// needs about twice what it ends up weighing, because the snapshot of the
  /// database sits beside the archive until it is packed into it.
  cannotWrite,

  /// The chosen file could not be read at all — gone, or handed over by a
  /// provider that has since dropped it. Not the same as "not a backup": the
  /// file may be a perfectly good copy that is simply out of reach.
  cannotRead,

  /// The copy was good and putting it back failed before anything changed. The
  /// rows go in one transaction, and the files are only touched after it.
  restoreFailed,

  /// The rows were restored and some of the files were not. Said plainly
  /// because the record now disagrees with the documents behind it, and
  /// restoring from the same copy again fixes it.
  filesIncomplete,

  unknown,
}
