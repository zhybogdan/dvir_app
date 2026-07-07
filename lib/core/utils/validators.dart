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
