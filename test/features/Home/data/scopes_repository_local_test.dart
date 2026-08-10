import 'package:drift/native.dart';
import 'package:dvir/core/database/app_database.dart';
import 'package:dvir/features/Home/data/scopes_repository_local.dart';
import 'package:dvir/features/Home/domain/models/scope_summary.dart';
import 'package:dvir/features/Units/data/units_repository_local.dart';
import 'package:dvir/features/Units/domain/types/unit_role.dart';
import 'package:dvir/features/Units/domain/types/unit_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late LocalUnitsRepository units;
  late LocalScopesRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    units = LocalUnitsRepository(database);
    repository = LocalScopesRepository(units);
  });
  tearDown(() => database.close());

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
