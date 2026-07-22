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
