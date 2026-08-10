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

  setUp(() => database = AppDatabase(NativeDatabase.memory()));
  tearDown(() => database.close());

  Future<void> insertUnit({
    String id = 'unit',
    String? parentId,
    String label = 'Будинок',
    String? address,
    String? city,
  }) => database
      .into(database.units)
      .insert(
        UnitsCompanion.insert(
          id: id,
          parentId: Value(parentId),
          type: 'house',
          label: label,
          address: Value(address),
          city: Value(city),
        ),
      );

  Future<void> insertAttribute({
    String id = 'attribute',
    String name = 'Рік побудови',
    String value = '1998',
  }) => database
      .into(database.unitAttributes)
      .insert(
        UnitAttributesCompanion.insert(
          id: id,
          unitId: 'unit',
          name: name,
          value: value,
          createdAt: DateTime.utc(2026, 8, 10, 11, 30),
        ),
      );

  Future<void> insertDocument({
    String id = 'document',
    String title = 'Техпаспорт',
    String? originalName,
  }) => database
      .into(database.documents)
      .insert(
        DocumentsCompanion.insert(
          id: id,
          unitId: 'unit',
          title: title,
          storagePath: 'unit/$id.pdf',
          originalName: Value(originalName),
          createdAt: DateTime.utc(2026, 8, 10, 11, 30),
        ),
      );

  Future<void> insertContact({
    String id = 'contact',
    String name = 'Сергій',
    String? role,
    String? phone,
  }) => database
      .into(database.contacts)
      .insert(
        ContactsCompanion.insert(
          id: id,
          unitId: 'unit',
          name: name,
          role: Value(role),
          phone: Value(phone),
        ),
      );

  test('an object comes back the way it went in', () async {
    await insertUnit(city: 'Львів');

    final stored = await database.select(database.units).getSingle();

    expect(stored.id, 'unit');
    expect(stored.label, 'Будинок');
    expect(stored.city, 'Львів');
    expect(stored.parentId, isNull);
    expect(stored.areaM2, isNull);
  });

  test('a stored date reads back in UTC', () async {
    await insertUnit();
    await insertDocument();

    final stored = await database.select(database.documents).getSingle();

    // Worth pinning rather than discovering later: dates are kept as ISO-8601
    // text, and that conversion normalises to UTC. A repository comparing
    // against a local `DateTime.now()` would find them unequal for no visible
    // reason.
    expect(stored.createdAt.isUtc, isTrue);
    expect(stored.createdAt, DateTime.utc(2026, 8, 10, 11, 30));
  });

  test('deleting an object takes everything hanging off it', () async {
    await insertUnit();
    await insertAttribute();
    await insertDocument();
    await insertContact();

    await (database.delete(
      database.units,
    )..where((row) => row.id.equals('unit'))).go();

    // All three cascades only happen because `beforeOpen` turns foreign keys
    // on — SQLite ignores them otherwise, and every child would be orphaned.
    expect(await database.select(database.unitAttributes).get(), isEmpty);
    expect(await database.select(database.documents).get(), isEmpty);
    expect(await database.select(database.contacts).get(), isEmpty);
  });

  test('deleting an object takes the ones nested inside it', () async {
    await insertUnit();
    await insertUnit(id: 'garage', parentId: 'unit', label: 'Гараж');

    await (database.delete(
      database.units,
    )..where((row) => row.id.equals('unit'))).go();

    expect(await database.select(database.units).get(), isEmpty);
  });

  // What keeps `FieldLength` and the schema's own literals in agreement: drift
  // will not let the schema name the constant, so without these nothing would
  // notice the day one of them moves.
  final limits =
      <({String field, int max, Future<void> Function(String) write})>[
        (
          field: 'unit label',
          max: FieldLength.label,
          write: (text) => insertUnit(id: text.length.toString(), label: text),
        ),
        (
          field: 'unit address',
          max: FieldLength.address,
          write: (text) =>
              insertUnit(id: text.length.toString(), address: text),
        ),
        (
          field: 'unit city',
          max: FieldLength.city,
          write: (text) => insertUnit(id: text.length.toString(), city: text),
        ),
        (
          field: 'attribute name',
          max: FieldLength.attributeName,
          write: (text) =>
              insertAttribute(id: text.length.toString(), name: text),
        ),
        (
          field: 'attribute value',
          max: FieldLength.attributeValue,
          write: (text) =>
              insertAttribute(id: text.length.toString(), value: text),
        ),
        (
          field: 'document title',
          max: FieldLength.documentTitle,
          write: (text) =>
              insertDocument(id: text.length.toString(), title: text),
        ),
        (
          field: 'document original name',
          max: FieldLength.originalName,
          write: (text) =>
              insertDocument(id: text.length.toString(), originalName: text),
        ),
        (
          field: 'contact name',
          max: FieldLength.contactName,
          write: (text) =>
              insertContact(id: text.length.toString(), name: text),
        ),
        (
          field: 'contact role',
          max: FieldLength.contactRole,
          write: (text) =>
              insertContact(id: text.length.toString(), role: text),
        ),
        (
          field: 'contact phone',
          max: FieldLength.phone,
          write: (text) =>
              insertContact(id: text.length.toString(), phone: text),
        ),
      ];

  for (final limit in limits) {
    test(
      '${limit.field} takes ${limit.max} characters and not one more',
      () async {
        await insertUnit();

        await limit.write('д' * limit.max);

        expect(
          () => limit.write('д' * (limit.max + 1)),
          throwsA(isA<Exception>()),
        );
      },
    );
  }
}
