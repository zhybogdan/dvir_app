import 'package:dvir/app/bootstrap.dart';
import 'package:dvir/core/config/app_capabilities.dart';
import 'package:dvir/core/config/supabase_providers.dart';
import 'package:dvir/core/database/database_provider.dart';
import 'package:dvir/features/Auth/data/auth_repository_impl.dart';
import 'package:dvir/features/Auth/data/auth_repository_local.dart';
import 'package:dvir/features/Contacts/data/contacts_repository_impl.dart';
import 'package:dvir/features/Contacts/data/contacts_repository_local.dart';
import 'package:dvir/features/Documents/data/document_file_store.dart';
import 'package:dvir/features/Documents/data/documents_repository_impl.dart';
import 'package:dvir/features/Documents/data/documents_repository_local.dart';
import 'package:dvir/features/Home/data/scopes_repository_impl.dart';
import 'package:dvir/features/Home/data/scopes_repository_local.dart';
import 'package:dvir/features/Members/data/members_repository_impl.dart';
import 'package:dvir/features/Members/data/members_repository_local.dart';
import 'package:dvir/features/Units/data/unit_attributes_repository_impl.dart';
import 'package:dvir/features/Units/data/unit_attributes_repository_local.dart';
import 'package:dvir/features/Units/data/units_repository_impl.dart';
import 'package:dvir/features/Units/data/units_repository_local.dart';

/// Entry point of the `unit` flavor — one household and its own object.
///
/// Nothing here reaches a network. Everything an object holds — its record, its
/// papers, its numbers — and the answer to who is using the app come from the
/// device, so the start-up has no backend to bring up and no keys to read.
///
/// The Supabase package and the `.env` asset still travel in the build: both
/// are declared for the whole project, and Flutter has no per-flavour
/// dependencies. They cost bytes and nothing else — no call is made through
/// either.
Future<void> main() => bootstrap(() async {
  // Opened here rather than behind a provider: the documents directory is an
  // async lookup, and this callback is the one place in the app's start-up that
  // is allowed to wait.
  final files = await LocalDocumentFileStore.open();

  return [
    // What this build is, which is what the screens ask before offering
    // anything that needs a second person.
    appCapabilitiesProvider.overrideWithValue(const AppCapabilities.onDevice()),
    // Anything still reaching for a backend is a consumer this list forgot, and
    // this is what says so. Without it the same mistake surfaces as Supabase's
    // own "you must initialize before calling instance", which reads like a
    // start-up bug rather than a missing override.
    supabaseClientProvider.overrideWith(
      (ref) => throw UnsupportedError('This build has no backend.'),
    ),
    // Everything else agrees with this one: the router waits on its answer, and
    // `myUnitRole` matches the id against the residents list.
    authRepositoryProvider.overrideWith((ref) => const LocalAuthRepository()),
    unitsRepositoryProvider.overrideWith(
      (ref) => LocalUnitsRepository(ref.watch(appDatabaseProvider)),
    ),
    // Reads through the units repository rather than the database, so "my
    // objects" keeps one definition — hence the provider and not a second
    // instance.
    scopesRepositoryProvider.overrideWith(
      (ref) => LocalScopesRepository(ref.watch(unitsRepositoryProvider)),
    ),
    unitAttributesRepositoryProvider.overrideWith(
      (ref) => LocalUnitAttributesRepository(ref.watch(appDatabaseProvider)),
    ),
    contactsRepositoryProvider.overrideWith(
      (ref) => LocalContactsRepository(ref.watch(appDatabaseProvider)),
    ),
    documentsRepositoryProvider.overrideWith(
      (ref) => LocalDocumentsRepository(ref.watch(appDatabaseProvider), files),
    ),
    // Not a data source so much as the answer to "who am I here": `myUnitRole`
    // reads this list, and everything the hub offers a keeper hangs off it.
    membersRepositoryProvider.overrideWith(
      (ref) => const LocalMembersRepository(),
    ),
  ];
});
