import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// An object a household keeps: a house, a flat, a garage, and whatever is
/// nested inside them.
///
/// The row is named `UnitRow` rather than drift's default `Unit`, which would
/// collide with the domain model of the same name the moment a repository
/// imports both. Everything here is storage; the mapping to `Unit` belongs to
/// the repository.
///
/// What the cloud table carries and this one does not is the whole
/// multi-tenant half — `community_id`, `invite_code`, `created_by`,
/// `owner_member_id`. A local database has one user, so there is nobody to
/// scope a row to and nobody to invite.
///
/// `type` stays plain text instead of drift's `textEnum`, which would drag a
/// feature's domain enum into `core/`. The repository parses it, the way it
/// already parses the column coming back from PostgREST.
@DataClassName('UnitRow')
class Units extends Table {
  TextColumn get id => text()();

  /// The object this one sits inside — a garage on a plot, a room in a flat.
  TextColumn get parentId =>
      text().nullable().references(Units, #id, onDelete: KeyAction.cascade)();

  TextColumn get type => text()();

  // Literals rather than `FieldLength`, which is where the same numbers live
  // for the forms: drift's generator cannot resolve a constant from another
  // library and, instead of failing, emits `checkTextLength()` with no limit at
  // all — the constraint disappears silently. The boundary test is what holds
  // the two definitions together.
  TextColumn get label => text().withLength(max: 120)();
  TextColumn get building => text().withLength(max: 40).nullable()();
  TextColumn get entrance => text().withLength(max: 40).nullable()();
  IntColumn get floor => integer().nullable()();
  TextColumn get address => text().withLength(max: 200).nullable()();
  TextColumn get city => text().withLength(max: 80).nullable()();
  RealColumn get areaM2 => real().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// The household's own database.
///
/// Built to be handed an executor rather than opening one itself, so a test can
/// pass an in-memory database and get the real schema without touching the
/// disk. [AppDatabase.onDevice] is what the app uses.
@DriftDatabase(tables: [Units])
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

  /// SQLite ignores foreign keys unless each connection asks for them, so the
  /// `parentId` reference above would be documentation and nothing more without
  /// this. It has to run per connection, which is what `beforeOpen` is for.
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
