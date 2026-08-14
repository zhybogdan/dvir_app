import 'package:dvir/core/utils/field_lengths.dart';
import 'package:dvir/core/utils/text_input.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Applies a formatter chain to [text] the way a field would, starting from an
/// empty previous value.
String _run(List<TextInputFormatter> formatters, String text) {
  var value = TextEditingValue(text: text);
  for (final formatter in formatters) {
    value = formatter.formatEditUpdate(TextEditingValue.empty, value);
  }
  return value.text;
}

void main() {
  test('UpperCaseTextFormatter upper-cases as typed', () {
    const formatter = UpperCaseTextFormatter();
    final result = formatter.formatEditUpdate(
      TextEditingValue.empty,
      const TextEditingValue(text: 'a3xy'),
    );
    expect(result.text, 'A3XY');
  });

  group('inviteCodeFormatters', () {
    test('strip Cyrillic, spaces and symbols, keeping latin and digits', () {
      expect(_run(inviteCodeFormatters, 'аб c3-xY!'), 'C3XY');
    });

    test('leave a clean code untouched but upper-cased', () {
      expect(_run(inviteCodeFormatters, 'a3f9c1b2'), 'A3F9C1B2');
    });

    // Pasting the whole share message used to leave the letters of every word
    // stuck together in the field, and the backend could only answer "no such
    // code" to a forty-character string.
    test('cap a paste at the length of a code', () {
      final pasted = _run(
        inviteCodeFormatters,
        'Приєднуйтесь до House 1011 у застосунку Двір. '
        'Код запрошення: AAB55582',
      );

      expect(pasted.length, inviteCodeLength);
    });
  });

  group('SingleLineTextFormatter', () {
    const formatter = SingleLineTextFormatter();

    String clean(String text) => _run([formatter], text);

    test('a paste out of a document keeps its words apart', () {
      expect(clean('вул. Соборна\n15'), 'вул. Соборна 15');
      expect(clean('Рік\tпобудови'), 'Рік побудови');
    });

    test('invisible characters are dropped', () {
      expect(clean('Договір\u200B\uFEFF'), 'Договір');
      expect(clean('\u202EДоговір'), 'Договір');
    });

    // Removing it would split one emoji into four, which is the opposite of
    // protecting what was typed.
    test('the joiner inside an emoji is left alone', () {
      const family = '👨‍👩‍👧‍👦';

      expect(clean(family), family);
    });

    test('ordinary text is handed back untouched', () {
      const text = 'Будинок 223';

      expect(clean(text), text);
    });

    test('the caret cannot outrun the shortened text', () {
      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(
          text: 'Дім\u200B',
          selection: TextSelection.collapsed(offset: 4),
        ),
      );

      expect(result.text, 'Дім');
      expect(result.selection.baseOffset, 3);
    });
  });

  group('phoneFormatters', () {
    test('keep what a number is written with, drop the rest', () {
      expect(
        _run(phoneFormatters, '+38 (067) 123-45-67'),
        '+38 (067) 123-45-67',
      );
      expect(_run(phoneFormatters, 'дзвонити 067 після 18'), ' 067  18');
    });

    test('cap at what the column stores', () {
      final pasted = _run(phoneFormatters, '0' * 60);

      expect(pasted.length, FieldLength.phone);
    });
  });

  test('trimmedOrNull tells an untouched field from a filled one', () {
    expect(trimmedOrNull('  '), isNull);
    expect(trimmedOrNull(''), isNull);
    expect(trimmedOrNull('  Kyiv '), 'Kyiv');
  });
}
