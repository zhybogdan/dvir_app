import 'package:dvir/core/utils/phone.dart';
import 'package:dvir/l10n/app_localizations.dart';

/// Shared `TextFormField` validators. Returning null means "valid".
String? validateEmail(String? value, AppLocalizations l10n) {
  final v = value?.trim() ?? '';
  if (v.isEmpty) return l10n.emailRequired;
  final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v);
  return ok ? null : l10n.invalidEmail;
}

String? validatePassword(String? value, AppLocalizations l10n) {
  final v = value ?? '';
  if (v.isEmpty) return l10n.passwordRequired;
  if (v.length < 6) return l10n.passwordTooShort;
  return null;
}

/// A required free-text field (community name, object label). [message] carries
/// the field-specific wording so one validator serves every such field.
String? validateRequired(String? value, String message) =>
    (value?.trim().isEmpty ?? true) ? message : null;

/// An optional telephone number, judged by what will actually be dialled.
///
/// Empty passes, so a required number composes this with [validateRequired] and
/// "no number" stays a different sentence from "not a number".
///
/// A field full of words passes "not empty" and then opens an empty dialler,
/// which is the failure this is here for. The ceiling is E.164's own fifteen
/// digits: past it the field is holding something that was never a telephone
/// number — a card, an account, a passport pasted into the wrong row. Short
/// service numbers stay welcome, because a household writes down 102 and 103.
String? validatePhone(String? value, String message) {
  final raw = value?.trim() ?? '';
  if (raw.isEmpty) return null;

  // Empty when there was nothing to dial: `dialableNumber` already refuses
  // anything under three digits.
  final digits = dialableNumber(raw).replaceAll('+', '');

  return digits.isEmpty || digits.length > 15 ? message : null;
}

/// Text no longer than the column that will hold it. [message] is given the
/// limit, because a refusal that does not say how much is too much leaves the
/// person deleting characters one at a time.
///
/// Counts UTF-16 code units, the way drift's `withLength` counts, and not the
/// graphemes the field's own cap is measured in. The two agree on every
/// alphabet and part company on emoji, where 120 of them are 120 characters to
/// the keyboard and 480 to the database — which is exactly the case this is
/// here to answer, with a sentence rather than a failed write.
String? validateMaxLength(
  String? value,
  int max,
  String Function(int) message,
) {
  final length = value?.trim().length ?? 0;

  return length > max ? message(max) : null;
}
