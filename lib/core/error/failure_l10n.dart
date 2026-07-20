import 'package:dvir/core/error/failures.dart';
import 'package:dvir/l10n/app_localizations.dart';

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
      AuthFailureReason.weakPassword => l10n.errorWeakPassword,
      AuthFailureReason.emailNotConfirmed => l10n.errorEmailNotConfirmed,
      AuthFailureReason.tooManyRequests => l10n.errorTooManyRequests,
      AuthFailureReason.unknown => l10n.errorAuthUnknown,
    },
  };
}
