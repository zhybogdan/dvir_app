// `isNull` is a column predicate in drift and a matcher in flutter_test, and
// this file wants the matcher.
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:dvir/core/database/app_database.dart';
import 'package:dvir/core/utils/field_lengths.dart';
import 'package:flutter_test/flutter_test.dart';

/// The schema answers for itself here: an in-memory database runs the same
/// `CREATE TABLE` the device does, so a constraint that is wrong is wrong in
/// both.
void main() {
  late AppDatabase database;

  UnitsCompanion house({
    required String id,
    String? parentId,
    String label = 'Будинок',
  }) => UnitsCompanion.insert(
    id: id,
    parentId: Value(parentId),
    type: 'house',
    label: label,
    createdAt: DateTime.utc(2026, 8, 10, 11, 30),
    updatedAt: DateTime.utc(2026, 8, 10, 11, 30),
  );

  setUp(() => database = AppDatabase(NativeDatabase.memory()));
  tearDown(() => database.close());

  test('an object comes back the way it went in', () async {
    await database.into(database.units).insert(house(id: 'a'));

    final stored = await database.select(database.units).getSingle();

    expect(stored.id, 'a');
    expect(stored.label, 'Будинок');
    expect(stored.parentId, isNull);
    expect(stored.areaM2, isNull);
  });

  test('a stored date reads back in UTC', () async {
    await database.into(database.units).insert(house(id: 'a'));

    final stored = await database.select(database.units).getSingle();

    // Worth pinning rather than discovering later: dates are kept as ISO-8601
    // text, and that conversion normalises to UTC. A repository comparing
    // against a local `DateTime.now()` would find them unequal for no visible
    // reason.
    expect(stored.createdAt.isUtc, isTrue);
    expect(stored.createdAt, DateTime.utc(2026, 8, 10, 11, 30));
  });

  test('deleting an object takes the ones nested inside it', () async {
    await database.into(database.units).insert(house(id: 'parent'));
    await database.into(database.units).insert(
      house(id: 'child', parentId: 'parent', label: 'Гараж'),
    );

    await (database.delete(
      database.units,
    )..where((row) => row.id.equals('parent'))).go();

    // The cascade only happens because `beforeOpen` turns foreign keys on —
    // SQLite ignores them otherwise, and the child would be left orphaned.
    expect(await database.select(database.units).get(), isEmpty);
  });

  // These two are what keep `FieldLength` and the schema's own literals in
  // agreement — drift will not let the schema name the constant, so nothing
  // else would notice the day one of them moves.
  test('a label of exactly the allowed length is stored', () async {
    await database
        .into(database.units)
        .insert(house(id: 'a', label: 'д' * FieldLength.label));

    final stored = await database.select(database.units).getSingle();

    expect(stored.label.length, FieldLength.label);
  });

  test('a label one character longer is refused', () async {
    Future<void> insert() => database
        .into(database.units)
        .insert(house(id: 'a', label: 'д' * (FieldLength.label + 1)));

    expect(insert, throwsA(isA<Exception>()));
  });
}
