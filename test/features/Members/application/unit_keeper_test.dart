import 'dart:async';

import 'package:dvir/features/Members/application/unit_members_controller.dart';
import 'package:dvir/features/Units/domain/types/unit_role.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// Who may write into an object's record. The database decides it for real, in
// `is_unit_keeper()` (0008), and this only mirrors it — which is precisely why
// it is worth pinning down. The two ways of being wrong are not equally
// visible: offering a write the database refuses ends in a message on screen,
// while hiding a button it would have allowed is a feature that silently is not
// there.

bool _keeps(UnitRole? role) {
  final container = ProviderContainer(
    overrides: [myUnitRoleProvider.overrideWith((ref, unitId) => role)],
  );
  addTearDown(container.dispose);

  return container.read(isUnitKeeperProvider('u1'));
}

void main() {
  test('an owner keeps the record of their own object', () {
    expect(_keeps(UnitRole.owner), isTrue);
  });

  // The reason the facts got a table of their own instead of a column on
  // `units`, which only an owner may update.
  test('so does their family', () {
    expect(_keeps(UnitRole.family), isTrue);
  });

  test('a tenant reads the record and writes nothing into it', () {
    expect(_keeps(UnitRole.tenant), isFalse);
  });

  test('someone with no role in the object writes nothing either', () {
    expect(_keeps(null), isFalse);
  });

  // Loading counts as "no", the same way it does for an owner: what a keeper is
  // offered appears once the role is known, rather than flashing and being
  // taken away.
  test('nothing is offered while the role is still being read', () {
    final container = ProviderContainer(
      overrides: [
        myUnitRoleProvider.overrideWith(
          (ref, unitId) => Completer<UnitRole?>().future,
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(isUnitKeeperProvider('u1')), isFalse);
  });
}
