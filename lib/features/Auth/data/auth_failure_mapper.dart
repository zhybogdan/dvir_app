import 'package:dvir/core/error/failures.dart';

/// GoTrue error codes → domain reasons.
///
/// The code is a plain string chosen by the backend, so anything we don't
/// recognise (including `null`, which GoTrue returns for errors raised before
/// a response arrives) degrades to [AuthFailureReason.unknown].
///
/// See https://supabase.com/docs/reference/dart/auth-error-codes
AuthFailureReason authFailureReasonFrom(String? code) => switch (code) {
  'invalid_credentials' => AuthFailureReason.invalidCredentials,
  'user_already_exists' ||
  'email_exists' => AuthFailureReason.emailAlreadyRegistered,
  // Supabase refuses example/test domains outright, so this fires on
  // `test@test.com` long before the address is ever checked for delivery.
  'email_address_invalid' => AuthFailureReason.emailAddressInvalid,
  'weak_password' => AuthFailureReason.weakPassword,
  'email_not_confirmed' => AuthFailureReason.emailNotConfirmed,
  'over_request_rate_limit' ||
  'over_email_send_rate_limit' ||
  'over_sms_send_rate_limit' => AuthFailureReason.tooManyRequests,
  'signup_disabled' => AuthFailureReason.signUpDisabled,
  _ => AuthFailureReason.unknown,
};
