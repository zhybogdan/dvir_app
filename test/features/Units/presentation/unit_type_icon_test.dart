import 'package:dvir/features/Units/domain/types/unit_type.dart';
import 'package:dvir/features/Units/presentation/unit_type_icon.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // The font was drawn so that no two types have to share; one quietly mapped
  // to a neighbour's glyph is the mistake the switch cannot catch.
  test('every type has a drawing of its own', () {
    final icons = UnitType.values.map((type) => type.icon).toSet();

    expect(icons, hasLength(UnitType.values.length));
  });

  test('every type is drawn from the app font', () {
    for (final type in UnitType.values) {
      expect(type.icon.fontFamily, 'PropertyIcons', reason: type.name);
    }
  });
}
