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

/// An optional positive number (area, …). Empty passes; anything present must
/// parse to a number greater than zero. Accepts both ',' and '.' as separator.
String? validateOptionalPositiveNumber(String? value, String message) {
  final raw = value?.trim().replaceAll(',', '.') ?? '';
  if (raw.isEmpty) return null;
  final number = double.tryParse(raw);
  return (number == null || number <= 0) ? message : null;
}

/// Parses an optional decimal field; null when empty or unparseable.
double? parseOptionalDouble(String? value) {
  final raw = value?.trim().replaceAll(',', '.') ?? '';
  return raw.isEmpty ? null : double.tryParse(raw);
}
