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
