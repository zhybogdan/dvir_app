import 'dart:math' as math;

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

/// Keeps a field to one line of visible text.
///
/// Every field in this app is a single line, and every one of them ends up in a
/// tile — so a value pasted out of a PDF brings its line breaks along and makes
/// one card twice the height of its neighbours. Replaced with a space rather
/// than dropped: "вул. Соборна\n15" is two things, and joining them without a
/// gap invents "Соборна15".
///
/// The invisible characters go for a different reason. They arrive from the web
/// with a copied string, cannot be seen in the field or in the list, and the
/// direction overrides among them render everything after them backwards. What
/// is *not* stripped is the zero-width joiner: it is what holds a family emoji
/// together, and removing it would quietly break the text it was meant to
/// protect.
class SingleLineTextFormatter extends TextInputFormatter {
  const SingleLineTextFormatter();

  static final _breaks = RegExp(r'[\r\n\t\v\f]');

  /// Zero-width space and byte-order mark, then the direction marks and the
  /// two override ranges. Written as escapes on purpose: as literals these are
  /// invisible in the source too, and nobody could review the line.
  static final _invisible = RegExp(
    r'[\u200B\uFEFF\u200E\u200F\u202A-\u202E\u2066-\u2069]',
  );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final cleaned = newValue.text
        .replaceAll(_breaks, ' ')
        .replaceAll(_invisible, '');

    if (cleaned == newValue.text) return newValue;

    // Cleaning only ever shortens, so the caret is clamped rather than
    // recomputed — after a paste it lands at the end of what arrived.
    return TextEditingValue(
      text: cleaned,
      selection: TextSelection.collapsed(
        offset: math.min(newValue.selection.end, cleaned.length),
      ),
    );
  }
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
