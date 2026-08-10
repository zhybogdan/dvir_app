import 'package:drift/native.dart';
import 'package:dvir/core/database/app_database.dart';
import 'package:dvir/features/Contacts/data/contacts_repository_local.dart';
import 'package:dvir/features/Contacts/domain/models/contact.dart';
import 'package:dvir/features/Shared/domain/types/scope_ref.dart';
import 'package:dvir/features/Units/data/units_repository_local.dart';
import 'package:dvir/features/Units/domain/types/unit_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late LocalContactsRepository repository;
  late ScopeRef scope;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    repository = LocalContactsRepository(database);

    final unit = await LocalUnitsRepository(
      database,
    ).createUnit(label: 'Будинок', type: UnitType.house);
    scope = ScopeRef.unit(unit.id);
  });
  tearDown(() => database.close());

  Future<void> add(String name, {String? role, String? phone}) =>
      repository.addContact(scope: scope, name: name, role: role, phone: phone);

  Future<List<String>> names() async =>
      (await repository.contactsOf(scope)).map((one) => one.name).toList();

  test('a contact comes back with what it was given', () async {
    await add('Сергій', role: 'Електрик', phone: '+380671112233');

    final stored = (await repository.contactsOf(scope)).single;

    expect(stored.name, 'Сергій');
    expect(stored.role, 'Електрик');
    expect(stored.phone, '+380671112233');
  });

  test('a contact with only a name is still a contact', () async {
    await add('Мама');

    final stored = (await repository.contactsOf(scope)).single;

    expect(stored.role, isNull);
    expect(stored.phone, isNull);
  });

  // The reason the sorting is done in Dart. SQLite compares bytes, and in UTF-8
  // every capital Cyrillic letter comes before every lowercase one — so by the
  // database's own order this list would read "Сергій, Ярема, мама", with every
  // lowercase name exiled to the end.
  test('lowercase names take their alphabetical place, not the end', () async {
    await add('Ярема');
    await add('мама');
    await add('Сергій');

    expect(await names(), ['мама', 'Сергій', 'Ярема']);
  });

  test('contacts of another object are not in this list', () async {
    final other = await LocalUnitsRepository(
      database,
    ).createUnit(label: 'Дача', type: UnitType.summerHouse);

    await add('Сергій');
    await repository.addContact(scope: ScopeRef.unit(other.id), name: 'Петро');

    expect(await names(), ['Сергій']);
  });

  test('an edited contact keeps its place in the list', () async {
    await add('Сергій', role: 'Електрик');
    await add('Ярема');

    final stored = (await repository.contactsOf(scope)).first;
    await repository.updateContact(
      Contact(id: stored.id, name: 'Сергій', role: 'Сантехнік', phone: '101'),
    );

    final updated = await repository.contactsOf(scope);

    expect(updated.first.role, 'Сантехнік');
    expect(updated.first.phone, '101');
    expect(updated.map((one) => one.name), ['Сергій', 'Ярема']);
  });

  test('a deleted contact leaves the list', () async {
    await add('Сергій');
    await add('Ярема');

    final stored = (await repository.contactsOf(scope)).first;
    await repository.deleteContact(stored.id);

    expect(await names(), ['Ярема']);
  });

  test('a community scope refuses rather than answers emptily', () async {
    const community = ScopeRef.community('any');

    expect(() => repository.contactsOf(community), throwsUnsupportedError);
    expect(
      () => repository.addContact(scope: community, name: 'Сергій'),
      throwsUnsupportedError,
    );
  });
}
