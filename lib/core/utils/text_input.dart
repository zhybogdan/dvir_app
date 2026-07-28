import 'package:flutter/services.dart';

/// Forces field input to upper case as the user types — for invite codes,
/// which are stored and compared upper case.
class UpperCaseTextFormatter extends TextInputFormatter {
  const UpperCaseTextFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) => newValue.copyWith(text: newValue.text.toUpperCase());
}

/// Latin letters and digits only — keeps Cyrillic and separators out of an
/// invite code regardless of the active keyboard layout.
final inviteCodeFormatters = <TextInputFormatter>[
  FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]')),
  const UpperCaseTextFormatter(),
];

/// What an optional text field actually holds: its trimmed text, or null when
/// the user left it alone.
///
/// The distinction matters at the far end — a column set to `''` is a value the
/// user chose, while null is the absence of one, and only the second reads as
/// "not filled in". Takes the text rather than the controller so this stays out
/// of the widget layer, like the other parsers here.
String? trimmedOrNull(String value) {
  final trimmed = value.trim();

  return trimmed.isEmpty ? null : trimmed;
}
