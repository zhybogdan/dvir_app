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
