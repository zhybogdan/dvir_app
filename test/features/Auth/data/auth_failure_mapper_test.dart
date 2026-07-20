import 'package:dvir/core/error/failures.dart';
import 'package:dvir/features/Auth/data/auth_failure_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

// The codes are plain strings from GoTrue: a typo here silently degrades every
// error to "unknown", which the user only ever sees as a generic message.
void main() {
  group('authFailureReasonFrom', () {
    test('maps known GoTrue codes', () {
      expect(
        authFailureReasonFrom('invalid_credentials'),
        AuthFailureReason.invalidCredentials,
      );
      expect(
        authFailureReasonFrom('weak_password'),
        AuthFailureReason.weakPassword,
      );
      expect(
        authFailureReasonFrom('email_not_confirmed'),
        AuthFailureReason.emailNotConfirmed,
      );
    });

    test('maps both aliases for an already-registered email', () {
      expect(
        authFailureReasonFrom('user_already_exists'),
        AuthFailureReason.emailAlreadyRegistered,
      );
      expect(
        authFailureReasonFrom('email_exists'),
        AuthFailureReason.emailAlreadyRegistered,
      );
    });

    test('maps both rate-limit codes', () {
      expect(
        authFailureReasonFrom('over_request_rate_limit'),
        AuthFailureReason.tooManyRequests,
      );
      expect(
        authFailureReasonFrom('over_email_send_rate_limit'),
        AuthFailureReason.tooManyRequests,
      );
    });

    test('degrades unknown and missing codes instead of throwing', () {
      expect(authFailureReasonFrom(null), AuthFailureReason.unknown);
      expect(authFailureReasonFrom(''), AuthFailureReason.unknown);
      expect(
        authFailureReasonFrom('something_new_from_the_backend'),
        AuthFailureReason.unknown,
      );
    });
  });
}
