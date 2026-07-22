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
  });
}
