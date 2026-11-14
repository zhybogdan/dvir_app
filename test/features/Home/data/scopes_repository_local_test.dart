import 'package:drift/native.dart';
import 'package:dvir/core/config/local_identity.dart';
import 'package:dvir/core/database/app_database.dart';
import 'package:dvir/features/Home/data/scopes_repository_local.dart';
import 'package:dvir/features/Home/domain/models/scope_summary.dart';
import 'package:dvir/features/Units/data/units_repository_local.dart';
import 'package:dvir/features/Units/domain/types/unit_role.dart';
import 'package:dvir/features/Units/domain/types/unit_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

void main() {
  late AppDatabase database;
  late LocalUnitsRepository units;
  late LocalScopesRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    units = LocalUnitsRepository(database);
    repository = LocalScopesRepository(units, database);
  });
  tearDown(() => database.close());

  /// A file row written straight to the database: what is under test is the
  /// tally, and the repository that would normally write this one also writes
  /// a file to disk.
  Future<void> addDocument(String unitId) => database
      .into(database.documents)
      .insert(
        DocumentsCompanion.insert(
          id: '$unitId-${const Uuid().v4()}',
          unitId: unitId,
          title: 'Договір',
          storagePath: 'documents/$unitId.pdf',
          createdAt: DateTime.now(),
        ),
      );

  Future<void> addAttribute(String unitId) => database
      .into(database.unitAttributes)
      .insert(
        UnitAttributesCompanion.insert(
          id: '$unitId-${const Uuid().v4()}',
          unitId: unitId,
          name: 'Рік побудови',
          value: '1998',
          createdAt: DateTime.now(),
        ),
      );

  test('a household with nothing in it belongs nowhere', () async {
    // What the router reads as "create your first object" rather than as a
    // list still loading.
    expect(await repository.myScopes(), isEmpty);
  });

  test('every object is a line the person owns and is let into', () async {
    await units.createUnit(label: 'Будинок', type: UnitType.house);

    final scope = (await repository.myScopes()).single;

    expect(scope, isA<UnitSummary>());
    expect(scope.isActive, isTrue);

    final summary = scope as UnitSummary;
    expect(summary.unit?.label, 'Будинок');
    expect(summary.membership.role, UnitRole.owner);
    expect(summary.membership.userId, localUserId);
  });

  test('an object reports what it holds, and only its own', () async {
    final house = await units.createUnit(
      label: 'Будинок',
      type: UnitType.house,
    );
    final garage = await units.createUnit(
      label: 'Гараж',
      type: UnitType.garage,
    );

    await addDocument(house.id);
    await addDocument(house.id);
    await addDocument(garage.id);
    await addAttribute(house.id);

    final scopes = await repository.myScopes();
    final counts = {
      for (final scope in scopes.cast<UnitSummary>())
        scope.unit?.label: scope.counts,
    };

    // Grouped by the database in one query, so the risk being pinned is that
    // one object's rows land on another's card.
    expect(counts['Будинок'], (documents: 2, attributes: 1));
    expect(counts['Гараж'], (documents: 1, attributes: 0));
  });

  test('an object with nothing in it counts zero, not nothing', () async {
    // Zero and "unknown" read differently on the card: the local build can
    // always see everything, so an empty object is empty rather than unread.
    await units.createUnit(label: 'Будинок', type: UnitType.house);

    final scope = (await repository.myScopes()).single as UnitSummary;

    expect(scope.counts, (documents: 0, attributes: 0));
  });

  test('a nested object arrives too, for the home list to fold', () async {
    final house = await units.createUnit(
      label: 'Будинок',
      type: UnitType.house,
    );
    await units.createUnit(
      label: 'Гараж',
      type: UnitType.garage,
      parentId: house.id,
    );

    // Both lines are returned rather than filtered here: `arrangeScopes` is
    // what folds a child into its parent's card, and it can only do that if the
    // child is in the list to begin with.
    expect(await repository.myScopes(), hasLength(2));
  });
}
