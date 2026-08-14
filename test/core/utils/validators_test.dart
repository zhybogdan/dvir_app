import 'package:dvir/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('validateRequired', () {
    test('null, empty or whitespace returns the message', () {
      expect(validateRequired(null, 'req'), 'req');
      expect(validateRequired('', 'req'), 'req');
      expect(validateRequired('   ', 'req'), 'req');
    });

    test('any real text passes', () {
      expect(validateRequired('Будинок 223', 'req'), isNull);
    });
  });

  group('validatePhone', () {
    test('empty passes — being required is a separate question', () {
      expect(validatePhone(null, 'bad'), isNull);
      expect(validatePhone('', 'bad'), isNull);
      expect(validatePhone('   ', 'bad'), isNull);
    });

    test('accepts a number as a person writes one down', () {
      expect(validatePhone('+38 (067) 123-45-67', 'bad'), isNull);
      expect(validatePhone('0671234567', 'bad'), isNull);
    });

    test('accepts the short numbers a household keeps', () {
      expect(validatePhone('102', 'bad'), isNull);
      expect(validatePhone('0 800 500 202', 'bad'), isNull);
    });

    test('rejects prose that would open an empty dialler', () {
      expect(validatePhone('дзвонити після 18', 'bad'), 'bad');
      expect(validatePhone('питати Сергія', 'bad'), 'bad');
    });

    test('rejects more digits than a telephone number has', () {
      expect(validatePhone('1234567890123456', 'bad'), 'bad');
    });
  });

  group('validateMaxLength', () {
    String message(int max) => 'max $max';

    test('empty and short text pass', () {
      expect(validateMaxLength(null, 10, message), isNull);
      expect(validateMaxLength('Дім', 10, message), isNull);
    });

    test('the limit itself passes, one past it does not', () {
      expect(validateMaxLength('a' * 10, 10, message), isNull);
      expect(validateMaxLength('a' * 11, 10, message), 'max 10');
    });

    test('measures what is stored, so trailing spaces do not count', () {
      expect(validateMaxLength('${'a' * 10}    ', 10, message), isNull);
    });

    // The gap this exists for: the field's own cap counts graphemes, the
    // database counts UTF-16, and an emoji is one of the first and two of the
    // second.
    test('counts emoji the way the database will', () {
      expect(validateMaxLength('😀' * 6, 10, message), 'max 10');
    });
  });

  group('validateOptionalPositiveNumber', () {
    test('empty is allowed — the field is optional', () {
      expect(validateOptionalPositiveNumber(null, 'bad'), isNull);
      expect(validateOptionalPositiveNumber('', 'bad'), isNull);
      expect(validateOptionalPositiveNumber('  ', 'bad'), isNull);
    });

    test('accepts a positive number with dot or comma', () {
      expect(validateOptionalPositiveNumber('72', 'bad'), isNull);
      expect(validateOptionalPositiveNumber('72,5', 'bad'), isNull);
      expect(validateOptionalPositiveNumber('0.25', 'bad'), isNull);
    });

    test('rejects zero, negatives and non-numbers', () {
      expect(validateOptionalPositiveNumber('0', 'bad'), 'bad');
      expect(validateOptionalPositiveNumber('-3', 'bad'), 'bad');
      expect(validateOptionalPositiveNumber('abc', 'bad'), 'bad');
    });
  });

  group('parseOptionalDouble', () {
    test('empty maps to null', () {
      expect(parseOptionalDouble(null), isNull);
      expect(parseOptionalDouble(''), isNull);
    });

    test('parses with either separator', () {
      expect(parseOptionalDouble('72'), 72.0);
      expect(parseOptionalDouble('72,5'), 72.5);
      expect(parseOptionalDouble('0.25'), 0.25);
    });

    test('unparseable maps to null rather than throwing', () {
      expect(parseOptionalDouble('abc'), isNull);
    });
  });
}
