import 'package:drift/native.dart';
import 'package:dvir/core/database/app_database.dart';
import 'package:dvir/features/Auth/application/auth_controller.dart';
import 'package:dvir/features/Auth/data/auth_repository_impl.dart';
import 'package:dvir/features/Auth/data/auth_repository_local.dart';
import 'package:dvir/features/Home/application/my_scopes_controller.dart';
import 'package:dvir/features/Home/data/scopes_repository_impl.dart';
import 'package:dvir/features/Home/data/scopes_repository_local.dart';
import 'package:dvir/features/Units/application/unit_actions_controller.dart';
import 'package:dvir/features/Units/application/unit_form_controller.dart';
import 'package:dvir/features/Units/data/units_repository_impl.dart';
import 'package:dvir/features/Units/data/units_repository_local.dart';
import 'package:dvir/features/Units/domain/types/unit_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// The router reads `myScopesProvider` to decide where a person may stand, and
// the screens navigate the instant a controller returns. So what is pinned here
// is an ordering: by the time the action hands control back, the list must
// already be the new one. Riverpod serves the previous value while a provider
// reloads — deliberately — which is what made a plain `invalidate` look right
// and behave wrong.
//
// Every assertion below therefore reads the list **synchronously**, with no
// await and no pump: an answer that needs one more turn of the loop is exactly
// the bug.

void main() {
  late AppDatabase database;
  late ProviderContainer container;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    final units = LocalUnitsRepository(database);

    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWith(
          (ref) => const LocalAuthRepository(),
        ),
        unitsRepositoryProvider.overrideWith((ref) => units),
        scopesRepositoryProvider.overrideWith(
          (ref) => LocalScopesRepository(units),
        ),
      ],
    );

    // Auth is a stream, and a stream provider nobody is subscribed to never
    // starts: its `.future` then waits for an emission that will not come. The
    // app has the router listening; here it has to be said out loud.
    container.listen(authStateProvider, (previous, next) {});
  });
  tearDown(() async {
    container.dispose();
    await database.close();
  });

  /// The list as the router would find it right now.
  List<Object> scopesNow() =>
      container.read(myScopesProvider).value?.scopes ?? const [];

  /// `myScopes` answers null until it knows whose list it is, and auth arrives
  /// as a stream. The app covers this by holding the splash; a test has to wait
  /// for the same emission, or it measures a list that was never about anyone.
  Future<void> signedIn() => container.read(authStateProvider.future);

  test('creating an object leaves the list already holding it', () async {
    await signedIn();

    // Read once first, so there is a previous answer for Riverpod to serve —
    // without this the provider has never been built and cannot be stale.
    expect((await container.read(myScopesProvider.future))?.scopes, isEmpty);

    final created = await container
        .read(unitFormControllerProvider.notifier)
        .create(label: 'Будинок 223', type: UnitType.house);

    expect(created, isNotNull);
    expect(scopesNow(), hasLength(1));
  });

  test('deleting the last object leaves the list already empty', () async {
    await signedIn();

    final created = await container
        .read(unitFormControllerProvider.notifier)
        .create(label: 'Будинок 223', type: UnitType.house);
    final unitId = created?.id;

    expect(unitId, isNotNull);
    expect(scopesNow(), hasLength(1));

    // Actions are fired from callbacks and watched by nobody, so without a
    // listener the notifier is disposed the moment it is read and its result
    // lands nowhere — the same rule the screens follow.
    final actions = unitActionsProvider(unitId ?? '');
    container.listen(actions, (previous, next) {});

    final deleted = await container.read(actions.notifier).delete();

    expect(deleted, isTrue);
    expect(scopesNow(), isEmpty);
  });
}
