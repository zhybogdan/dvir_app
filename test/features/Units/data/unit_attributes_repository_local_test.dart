import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:dvir/core/database/app_database.dart';
import 'package:dvir/features/Units/data/unit_attributes_repository_local.dart';
import 'package:dvir/features/Units/data/units_repository_local.dart';
import 'package:dvir/features/Units/domain/models/unit_attribute.dart';
import 'package:dvir/features/Units/domain/types/unit_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late LocalUnitAttributesRepository repository;
  late String unitId;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    repository = LocalUnitAttributesRepository(database);

    final unit = await LocalUnitsRepository(
      database,
    ).createUnit(label: 'Будинок', type: UnitType.house);
    unitId = unit.id;
  });
  tearDown(() => database.close());

  Future<void> add(String name) =>
      repository.addAttribute(unitId: unitId, name: name, value: '1998');

  Future<List<String>> names() async =>
      (await repository.attributesOf(unitId)).map((fact) => fact.name).toList();

  test('facts stand in the order they were added', () async {
    await add('Рік побудови');
    await add('Матеріал стін');
    await add('Поверховість');

    expect(await names(), ['Рік побудови', 'Матеріал стін', 'Поверховість']);
  });

  test('facts of another object are not in this list', () async {
    final other = await LocalUnitsRepository(
      database,
    ).createUnit(label: 'Дача', type: UnitType.summerHouse);

    await add('Рік побудови');
    await repository.addAttribute(
      unitId: other.id,
      name: 'Ділянка',
      value: '6',
    );

    expect(await names(), ['Рік побудови']);
  });

  test('a shared position is broken by when the fact was written', () async {
    // Positions are deliberately not unique, and `addAttribute` never produces
    // a duplicate — so the rows are written straight to the table to put the
    // read's tie-breaker under test rather than the writer.
    await database
        .into(database.unitAttributes)
        .insert(
          UnitAttributesCompanion.insert(
            id: 'later',
            unitId: unitId,
            name: 'Другий',
            value: '2',
            position: const Value(0),
            createdAt: DateTime.utc(2026, 8, 10, 12),
          ),
        );
    await database
        .into(database.unitAttributes)
        .insert(
          UnitAttributesCompanion.insert(
            id: 'earlier',
            unitId: unitId,
            name: 'Перший',
            value: '1',
            position: const Value(0),
            createdAt: DateTime.utc(2026, 8, 10, 11),
          ),
        );

    expect(await names(), ['Перший', 'Другий']);
  });

  test('reordering puts the list in the order it was given', () async {
    await add('Перший');
    await add('Другий');
    await add('Третій');

    final facts = await repository.attributesOf(unitId);
    await repository.reorder(
      unitId: unitId,
      ids: [facts[2].id, facts[0].id, facts[1].id],
    );

    expect(await names(), ['Третій', 'Перший', 'Другий']);
  });

  test('reordering cannot move a fact of another object', () async {
    final other = await LocalUnitsRepository(
      database,
    ).createUnit(label: 'Дача', type: UnitType.summerHouse);

    await repository.addAttribute(unitId: other.id, name: 'Перший', value: '1');
    await repository.addAttribute(unitId: other.id, name: 'Другий', value: '2');

    final theirs = await repository.attributesOf(other.id);
    await repository.reorder(unitId: unitId, ids: [theirs[1].id, theirs[0].id]);

    // Untouched: the id belongs to another object, so the write matched nothing
    // rather than reaching into a list it was not asked about.
    expect((await repository.attributesOf(other.id)).map((fact) => fact.name), [
      'Перший',
      'Другий',
    ]);
  });

  test('editing a fact changes its wording and not its place', () async {
    await add('Перший');
    await add('Другий');

    final facts = await repository.attributesOf(unitId);
    await repository.updateAttribute(
      UnitAttribute(id: facts.last.id, name: 'Переписаний', value: '2024'),
    );

    final updated = await repository.attributesOf(unitId);

    expect(updated.map((fact) => fact.name), ['Перший', 'Переписаний']);
    expect(updated.last.value, '2024');
  });

  test('a deleted fact leaves the list', () async {
    await add('Перший');
    await add('Другий');

    final facts = await repository.attributesOf(unitId);
    await repository.deleteAttribute(facts.first.id);

    expect(await names(), ['Другий']);
  });
}
