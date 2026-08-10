import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// Every row class is suffixed `Row`. Drift would otherwise name them `Unit`,
// `Document` and `Contact`, each of which is already a domain model, and the
// collision only surfaces in the repository that has to import both.
//
// Lengths are literals rather than `FieldLength`, where the same numbers live
// for the forms: drift's generator cannot resolve a constant from another
// library and, instead of failing, emits a check with no limit at all. The
// boundary tests are what hold the two definitions together.
//
// What the cloud tables carry and these do not is the multi-tenant half —
// `community_id`, `uploaded_by`, invite codes, membership. A local database has
// one user, so there is nobody to scope a row to. Columns nothing reads are left
// out on the same grounds the domain models leave them out: `category` on
// documents and contacts, `email` on contacts, `building` / `entrance` /
// `floor` on units.

/// An object a household keeps, and the ones nested inside it.
@DataClassName('UnitRow')
@TableIndex(name: 'units_parent', columns: {#parentId})
class Units extends Table {
  TextColumn get id => text()();
  TextColumn get parentId =>
      text().nullable().references(Units, #id, onDelete: KeyAction.cascade)();
  TextColumn get type => text()();
  TextColumn get label => text().withLength(max: 120)();
  TextColumn get address => text().withLength(max: 200).nullable()();
  TextColumn get city => text().withLength(max: 80).nullable()();
  RealColumn get areaM2 => real().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// One free-form fact about an object — "Year built: 1998".
///
/// `createdAt` earns its place as the tiebreaker: the list reads by [position]
/// first, and two attributes added without reordering share one.
@DataClassName('UnitAttributeRow')
@TableIndex(name: 'unit_attributes_unit', columns: {#unitId, #position})
class UnitAttributes extends Table {
  TextColumn get id => text()();
  TextColumn get unitId =>
      text().references(Units, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text().withLength(max: 60)();
  TextColumn get value => text().withLength(max: 200)();
  IntColumn get position => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// A file kept against an object — a scan of the property passport, a contract.
///
/// [storagePath] keeps its cloud name although it now points inside the app's
/// own directory: the row knowing where its file is, rather than deriving it,
/// is what made a layout change a data migration instead of a broken list.
@DataClassName('DocumentRow')
@TableIndex(name: 'documents_unit', columns: {#unitId, #createdAt})
class Documents extends Table {
  TextColumn get id => text()();
  TextColumn get unitId =>
      text().references(Units, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text().withLength(max: 120)();
  TextColumn get storagePath => text()();
  TextColumn get mimeType => text().nullable()();
  IntColumn get sizeBytes => integer().nullable()();
  TextColumn get originalName => text().withLength(max: 260).nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// One telephone number the object keeps — "Serhii, the electrician".
@DataClassName('ContactRow')
@TableIndex(name: 'contacts_unit', columns: {#unitId, #name})
class Contacts extends Table {
  TextColumn get id => text()();
  TextColumn get unitId =>
      text().references(Units, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text().withLength(max: 120)();
  TextColumn get role => text().withLength(max: 80).nullable()();
  TextColumn get phone => text().withLength(max: 32).nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// The household's own database.
///
/// Built to be handed an executor rather than opening one itself, so a test can
/// pass an in-memory database and get the real schema without touching the
/// disk. [AppDatabase.onDevice] is what the app uses.
@DriftDatabase(tables: [Units, UnitAttributes, Documents, Contacts])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  AppDatabase.onDevice() : super(_openOnDevice());

  @override
  int get schemaVersion => 1;

  /// Dates as ISO-8601 text rather than drift's default unix integers.
  ///
  /// Costs a few bytes a row and buys two things: the file stays readable when
  /// something goes wrong, and the values already look like what Postgres
  /// returns for a `timestamptz`, so the day these rows are uploaded there is
  /// no conversion to get wrong.
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);

  /// SQLite ignores foreign keys unless each connection asks for them, so every
  /// `references` above would be documentation and nothing more without this. It
  /// has to run per connection, which is what `beforeOpen` is for.
  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) => customStatement('PRAGMA foreign_keys = ON'),
  );
}

/// The file the app keeps its database in.
///
/// Lazy because the documents directory is an async lookup and the constructor
/// is not, and on a background isolate so a slow query cannot hold up a frame.
LazyDatabase _openOnDevice() => LazyDatabase(() async {
  final directory = await getApplicationDocumentsDirectory();

  return NativeDatabase.createInBackground(
    File(p.join(directory.path, 'dvir.sqlite')),
  );
});
