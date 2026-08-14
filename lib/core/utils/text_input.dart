import 'package:dvir/core/utils/field_lengths.dart';
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

/// How many characters `generate_invite_code()` produces.
const int inviteCodeLength = 8;

/// Latin letters and digits only, and no more than a code's worth of them.
///
/// The filter keeps Cyrillic and separators out regardless of the active
/// keyboard layout. The length limit is what makes a *paste* behave: dropping
/// the whole share message in leaves the letters of every word stuck together,
/// and without a cap the field silently holds a forty-character string that the
/// backend can only answer with "no such code".
final inviteCodeFormatters = <TextInputFormatter>[
  FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]')),
  LengthLimitingTextInputFormatter(inviteCodeLength),
  const UpperCaseTextFormatter(),
];

/// What a telephone number is made of, spacing included.
///
/// Shared because the same number is typed in two places — a household contact
/// and the profile — and only one of them was keeping letters out. The keyboard
/// offers them on some devices whatever `TextInputType.phone` asks for.
///
/// The cap is the contact column's own: it is the only one of the two that is
/// stored with a length, and a profile phone longer than a contact's would be a
/// number neither field could hold.
final phoneFormatters = <TextInputFormatter>[
  FilteringTextInputFormatter.allow(RegExp(r'[0-9+()\-\s]')),
  LengthLimitingTextInputFormatter(FieldLength.phone),
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
