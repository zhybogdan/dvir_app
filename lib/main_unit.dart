import 'package:dvir/app/bootstrap.dart';
import 'package:dvir/core/config/env.dart';
import 'package:dvir/core/config/secure_local_storage.dart';
import 'package:dvir/core/database/database_provider.dart';
import 'package:dvir/core/logging/logging_http_client.dart';
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
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

/// Entry point of the `unit` flavor — one household and its own object.
///
/// What an object holds — its record, its papers, its numbers — is read from
/// and written to the device. Supabase is still brought up because the account,
/// the residents list and the profile have not moved yet; when they do, this
/// callback stops needing a network at all.
Future<void> main() => bootstrap(() async {
  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: Env.supabaseUrl,
    publishableKey: Env.supabaseAnonKey,
    authOptions: FlutterAuthClientOptions(localStorage: SecureLocalStorage()),
    httpClient: kDebugMode ? LoggingHttpClient(http.Client()) : null,
  );

  // Opened here rather than behind a provider: the documents directory is an
  // async lookup, and this callback is the one place in the app's start-up that
  // is allowed to wait.
  final files = await LocalDocumentFileStore.open();

  return [
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
