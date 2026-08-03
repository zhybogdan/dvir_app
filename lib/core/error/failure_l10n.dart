import 'package:dvir/core/error/failures.dart';
import 'package:dvir/l10n/app_localizations.dart';

/// Whatever was thrown, as text for the user.
///
/// Anything that is not a [Failure] degrades to the generic message — a raw
/// `toString()` would leak backend English into the UI. Lives here rather than
/// in a widget so a toast and a full-screen error read the same wording.
String errorMessage(Object? error, AppLocalizations l10n) =>
    error is Failure ? error.message(l10n) : l10n.errorUnknown;

/// Turns a [Failure] into the text shown to the user.
///
/// Lives next to the failure types (not in a screen) so the same cause always
/// reads the same way, whichever screen raised it. The switches are exhaustive
/// — a new [Failure] or [AuthFailureReason] fails to compile until it gets a
/// translation.
extension FailureL10n on Failure {
  String message(AppLocalizations l10n) => switch (this) {
    NetworkFailure() => l10n.errorNetwork,
    ServerFailure() => l10n.errorServer,
    NotFoundFailure() => l10n.errorNotFound,
    UnknownFailure() => l10n.errorUnknown,
    AuthFailure(:final reason) => switch (reason) {
      AuthFailureReason.invalidCredentials => l10n.errorInvalidCredentials,
      AuthFailureReason.emailAlreadyRegistered =>
        l10n.errorEmailAlreadyRegistered,
      AuthFailureReason.emailAddressInvalid => l10n.errorEmailAddressInvalid,
      AuthFailureReason.signUpDisabled => l10n.errorSignUpDisabled,
      AuthFailureReason.weakPassword => l10n.errorWeakPassword,
      AuthFailureReason.emailNotConfirmed => l10n.errorEmailNotConfirmed,
      AuthFailureReason.tooManyRequests => l10n.errorTooManyRequests,
      AuthFailureReason.unknown => l10n.errorAuthUnknown,
    },
    StorageFailure(:final reason) => switch (reason) {
      StorageFailureReason.tooLarge => l10n.errorFileTooLarge,
      StorageFailureReason.typeNotAllowed => l10n.errorFileTypeNotAllowed,
      StorageFailureReason.missing => l10n.errorFileMissing,
      StorageFailureReason.cannotOpen => l10n.errorFileCannotOpen,
      // The same sentence a refused row gets: from the user's side a policy
      // that says no is one thing, whichever half of the database said it.
      StorageFailureReason.notAllowed => l10n.errorNotAllowed,
      StorageFailureReason.unknown => l10n.errorFileUnknown,
    },
    ScopeFailure(:final reason) => switch (reason) {
      ScopeFailureReason.invalidInviteCode => l10n.errorInvalidInviteCode,
      ScopeFailureReason.notAllowed => l10n.errorNotAllowed,
      ScopeFailureReason.notAuthenticated => l10n.errorNotAuthenticated,
      ScopeFailureReason.lastAdmin => l10n.errorLastAdmin,
      ScopeFailureReason.selfModeration => l10n.errorSelfModeration,
      ScopeFailureReason.unknown => l10n.errorScopeUnknown,
    },
  };
}
