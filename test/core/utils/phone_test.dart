import 'package:dvir/core/utils/phone.dart';
import 'package:flutter_test/flutter_test.dart';

// A number is typed to be read and dialled as digits, and the gap between the
// two is where the call is quietly lost: a dialler handed "+38 (067) 123-45-67"
// may open empty and say nothing about why.
void main() {
  group('dialableNumber', () {
    test('keeps the digits and drops what was there for the eye', () {
      expect(dialableNumber('+38 (067) 123-45-67'), '+380671234567');
      expect(dialableNumber('067 123 45 67'), '0671234567');
      expect(dialableNumber('0-800-500-101'), '0800500101');
    });

    test('the plus survives only in front, where it means something', () {
      expect(dialableNumber('  +380671234567  '), '+380671234567');
      // Inside a number a plus is a typo; keeping it would make the dialler
      // refuse a number that is otherwise fine.
      expect(dialableNumber('067+1234567'), '0671234567');
    });

    test('a number with nothing to dial comes back empty', () {
      expect(dialableNumber(''), isEmpty);
      expect(dialableNumber('   '), isEmpty);
      // Digits picked out of prose are not a number: dialling 18 would look
      // like the tap worked.
      expect(dialableNumber('дзвонити після 18'), isEmpty);
      // A lone plus is not a number either.
      expect(dialableNumber('+'), isEmpty);
    });

    // The floor is three digits rather than something safer, because these are
    // numbers a household actually writes down.
    test('an emergency number is short and still a number', () {
      expect(dialableNumber('101'), '101');
      expect(dialableNumber('112'), '112');
    });
  });
}
