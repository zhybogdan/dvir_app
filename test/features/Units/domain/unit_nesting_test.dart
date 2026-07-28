import 'package:dvir/features/Units/domain/types/unit_type.dart';
import 'package:dvir/features/Units/domain/unit_nesting.dart';
import 'package:flutter_test/flutter_test.dart';

// The rules exist because the form used to offer all seventeen types wherever
// it was opened. What is checked here is that the absurd cases are gone and the
// real ones survived — a dacha is a plot with a house on it, and somebody whose
// whole record is one garage still has rooms to put in it.
void main() {
  group('what cannot be nested', () {
    test('a garage holds no second garage', () {
      expect(
        allowedChildTypes(UnitType.garage),
        isNot(contains(UnitType.garage)),
      );
    });

    test('a garage holds no flat and no house', () {
      final allowed = allowedChildTypes(UnitType.garage);

      expect(allowed, isNot(contains(UnitType.apartment)));
      expect(allowed, isNot(contains(UnitType.house)));
    });

    test('a flat holds rooms but nothing that stands in a yard', () {
      final allowed = allowedChildTypes(UnitType.apartment);

      expect(allowed, contains(UnitType.room));
      expect(allowed, isNot(contains(UnitType.garage)));
      expect(allowed, isNot(contains(UnitType.pool)));
    });

    test('rooms and a pool are leaves', () {
      for (final type in [
        UnitType.room,
        UnitType.bathroom,
        UnitType.corridor,
        UnitType.storeroom,
        UnitType.balcony,
        UnitType.loggia,
        UnitType.basement,
        UnitType.pool,
      ]) {
        expect(canHoldChildren(type), isFalse, reason: type.name);
      }
    });
  });

  group('what has to keep working', () {
    // A dacha: the plot is the record, and the house is on it.
    test('a house stands on a plot but never inside another house', () {
      expect(allowedChildTypes(UnitType.plot), contains(UnitType.house));
      expect(
        allowedChildTypes(UnitType.house),
        isNot(contains(UnitType.house)),
      );
    });

    // Somebody working from home, and a co-working floor recorded as "other".
    test('an office fits wherever people actually put one', () {
      for (final parent in [
        UnitType.house,
        UnitType.apartment,
        UnitType.plot,
        UnitType.custom,
      ]) {
        expect(
          allowedChildTypes(parent),
          contains(UnitType.office),
          reason: parent.name,
        );
      }
    });

    // A cottage with no plot registered around it is still somebody's record.
    test('a summer house may stand on its own', () {
      expect(allowedChildTypes(null), contains(UnitType.summerHouse));
    });

    test('a house holds both rooms and outbuildings', () {
      final allowed = allowedChildTypes(UnitType.house);

      expect(allowed, contains(UnitType.room));
      expect(allowed, contains(UnitType.garage));
    });

    // The garage co-op case: one garage is somebody's whole record.
    test('a garage stands on its own and still holds a pit', () {
      expect(allowedChildTypes(null), contains(UnitType.garage));
      expect(allowedChildTypes(UnitType.garage), contains(UnitType.basement));
    });

    // A flat is a record of its own; nothing contains one, not even a house —
    // a block of flats is a community, which is a different thing entirely.
    test('a flat is never nested in anything', () {
      for (final parent in UnitType.values) {
        expect(
          allowedChildTypes(parent),
          isNot(contains(UnitType.apartment)),
          reason: parent.name,
        );
      }

      expect(allowedChildTypes(null), contains(UnitType.apartment));
    });

    // "Other" exists for the case the list failed to foresee, so it has to be
    // the widest of them all.
    test('other holds everything a house or a plot holds', () {
      final other = allowedChildTypes(UnitType.custom);

      for (final parent in [UnitType.house, UnitType.plot]) {
        expect(
          other,
          containsAll(
            allowedChildTypes(parent).where((t) => t != UnitType.apartment),
          ),
          reason: parent.name,
        );
      }
    });
  });

  group('the options a picker is given', () {
    test('keep the enum order, which is the grouping', () {
      final options = unitTypeOptions(parent: UnitType.house);

      expect(
        options,
        orderedEquals(
          UnitType.values.where(allowedChildTypes(UnitType.house).contains),
        ),
      );
    });

    // Objects typed before these rules existed must stay editable, and a value
    // missing from its own picker would be retyped on the next save.
    test('keep a current type the rules would now refuse', () {
      final options = unitTypeOptions(
        parent: UnitType.garage,
        current: UnitType.apartment,
      );

      expect(options, contains(UnitType.apartment));
    });

    test('offer a standalone object what may stand on its own', () {
      final options = unitTypeOptions(parent: null);

      expect(options, contains(UnitType.house));
      expect(options, contains(UnitType.plot));
      expect(options, isNot(contains(UnitType.room)));
    });
  });
}
