import 'package:drift/native.dart';
import 'package:dvir/core/database/app_database.dart';
import 'package:dvir/core/error/failures.dart';
import 'package:dvir/features/Units/data/units_repository_local.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/features/Units/domain/types/unit_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late LocalUnitsRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = LocalUnitsRepository(database);
  });
  tearDown(() => database.close());

  Future<Unit> create({required String label, String? parentId}) =>
      repository.createUnit(
        label: label,
        type: UnitType.house,
        parentId: parentId,
      );

  test('a created object reads back with what it was given', () async {
    final created = await repository.createUnit(
      label: 'Будинок',
      type: UnitType.summerHouse,
      address: 'вул. Шевченка, 1',
      areaM2: 96.5,
    );

    final stored = await repository.unitById(created.id);

    expect(stored.label, 'Будинок');
    expect(stored.type, UnitType.summerHouse);
    expect(stored.address, 'вул. Шевченка, 1');
    expect(stored.areaM2, 96.5);
    // Both are absences with meaning: no community owns it, and nobody can be
    // let in.
    expect(stored.communityId, isNull);
    expect(stored.inviteCode, isNull);
  });

  test('the objects read in alphabetical order', () async {
    await create(label: 'Гараж');
    await create(label: 'Будинок');
    await create(label: 'Дача');

    final units = await repository.myUnits();

    expect(units.map((unit) => unit.label), ['Будинок', 'Гараж', 'Дача']);
  });

  test('children are only the ones nested in this object', () async {
    final house = await create(label: 'Будинок');
    final dacha = await create(label: 'Дача');
    await create(label: 'Гараж', parentId: house.id);

    expect(
      (await repository.childrenOf(house.id)).map((unit) => unit.label),
      ['Гараж'],
    );
    expect(await repository.childrenOf(dacha.id), isEmpty);
  });

  test('an object that is not there is a NotFoundFailure', () async {
    await expectLater(
      repository.unitById('nobody'),
      throwsA(isA<NotFoundFailure>()),
    );
  });

  test('editing an object leaves where it sits alone', () async {
    final house = await create(label: 'Будинок');
    final garage = await create(label: 'Гараж', parentId: house.id);

    final saved = await repository.updateUnit(
      garage.copyWith(label: 'Майстерня', city: 'Львів'),
    );

    expect(saved.label, 'Майстерня');
    expect(saved.city, 'Львів');
    // The one that matters: writing the model wholesale would carry parentId
    // along and quietly move the object out of the house it stands on.
    expect(saved.parentId, house.id);
  });

  test('deleting an object takes the ones nested inside it', () async {
    final house = await create(label: 'Будинок');
    await create(label: 'Гараж', parentId: house.id);

    await repository.deleteUnit(house.id);

    expect(await repository.myUnits(), isEmpty);
  });

  test('what this build cannot have refuses rather than answers', () async {
    expect(() => repository.topLevelUnitsOf('any'), throwsUnsupportedError);
    expect(() => repository.inviteCode('any'), throwsUnsupportedError);
    expect(() => repository.rotateInviteCode('any'), throwsUnsupportedError);

    await expectLater(
      repository.createUnit(
        label: 'Будинок',
        type: UnitType.house,
        communityId: 'any',
      ),
      throwsUnsupportedError,
    );
  });
}
