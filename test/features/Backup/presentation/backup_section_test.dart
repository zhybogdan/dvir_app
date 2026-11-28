import 'dart:io';

import 'package:drift/native.dart';
import 'package:dvir/core/config/app_locales.dart';
import 'package:dvir/core/database/app_database.dart';
import 'package:dvir/core/database/database_provider.dart';
import 'package:dvir/core/extensions/date_time_x.dart';
import 'package:dvir/features/Backup/application/backup_controller.dart';
import 'package:dvir/features/Backup/data/backup_file_picker.dart';
import 'package:dvir/features/Backup/data/backup_history.dart';
import 'package:dvir/features/Backup/data/backup_service.dart';
import 'package:dvir/features/Backup/domain/models/backup_manifest.dart';
import 'package:dvir/features/Backup/domain/models/device_contents.dart';
import 'package:dvir/features/Backup/presentation/components/backup_section.dart';
import 'package:dvir/features/Shared/presentation/dv_confirm_dialog.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:dvir/l10n/app_localizations_uk.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path/path.dart' as p;

// The real service over a real database and a real archive, with only the file
// picker faked: what is worth testing here is the order of the three steps —
// pick, name what is in the copy, replace — and a fake service would be a fake
// of exactly the part that makes the question worth asking.

/// A phone that last shared a copy at [lastSharedAt], or never.
class _History implements BackupHistory {
  _History(this.lastSharedAt);

  @override
  DateTime? lastSharedAt;

  @override
  Future<void> recordShared(DateTime at) async => lastSharedAt = at;
}

/// Hands back whatever the test picked, including nothing.
class _Picker implements BackupFilePicker {
  const _Picker(this.file);

  final File? file;

  @override
  Future<File?> pick() async => file;
}

void main() {
  final l10n = AppLocalizationsUk();

  late Directory root;
  late AppDatabase database;
  late BackupService service;
  late File archive;
  late File notACopy;
  late BackupManifest manifest;

  // Everything that touches a file is prepared here and nothing is prepared
  // inside a test, and that is not tidiness. A `testWidgets` body runs with the
  // clock replaced, where a plain `await` on real file work never completes —
  // the test does not fail, it stops, and it stops the suite with it. `setUp`
  // runs outside that, which is why the same two lines work here and hang
  // there.
  setUp(() async {
    root = await Directory.systemTemp.createTemp('dvir-backup-section');
    database = AppDatabase(
      NativeDatabase(File(p.join(root.path, 'dvir.sqlite'))),
    );
    service = BackupService(
      database: database,
      documents: Directory(p.join(root.path, 'documents')),
    );

    await database
        .into(database.units)
        .insert(
          UnitsCompanion.insert(id: 'home', type: 'house', label: 'Будинок'),
        );

    // The copy is made while the object is there and restored after it is
    // gone, so "it came back" is the thing being asserted.
    archive = await service.write(into: root, appVersion: '1.0.0 (1)');
    manifest = await service.read(archive);
    await database.customStatement('delete from units');

    notACopy = File(p.join(root.path, 'photo.jpg'));
    await notACopy.writeAsString('not a zip at all');
  });

  tearDown(() async {
    await database.close();
    await root.delete(recursive: true);
  });

  Future<int> units() async {
    final row = await database
        .customSelect('select count(*) as count from units')
        .getSingle();

    return row.read<int>('count');
  }

  Future<void> pump(
    WidgetTester tester, {
    File? picked,
    DateTime? lastSharedAt,
    DeviceContents contents = const DeviceContents(
      units: 3,
      documents: 14,
      bytes: 28 * 1024 * 1024,
    ),
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          backupServiceProvider.overrideWithValue(service),
          backupWorkspaceProvider.overrideWith((ref) async => root),
          backupFilePickerProvider.overrideWithValue(_Picker(picked)),
          backupHistoryProvider.overrideWithValue(_History(lastSharedAt)),
          // A fixed value rather than the service's own stream: a drift query
          // started under the test's replaced clock never completes, and the
          // close in `tearDown` then waits on it for ever.
          deviceContentsProvider.overrideWith((ref) => Stream.value(contents)),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocales.delegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: BackupSection()),
        ),
      ),
    );

    await tester.pump();
  }

  /// Lets the real file work finish, then rebuilds — and the reason it is not
  /// `pumpAndSettle` is worth keeping.
  ///
  /// Two things make that method the wrong tool here. While an action runs the
  /// button shows an indefinite `CircularProgressIndicator`, which schedules a
  /// frame forever: `pumpAndSettle` pumps until it gives up, and it gives up
  /// later than the test's own timeout, so the suite stops instead of failing.
  /// And `pump` on its own only drains microtasks, while reading a zip,
  /// unpacking it and copying files is real work that completes on the event
  /// loop — `runAsync` is what lets it get on with it.
  Future<void> work(WidgetTester tester) async {
    for (var turn = 0; turn < 10; turn++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump(const Duration(milliseconds: 20));
    }
  }

  testWidgets('says where the data is and how much of it there is', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text(l10n.settingsStoredHere), findsOneWidget);
    expect(find.text('3 об’єкти · 14 документів · 28 МБ'), findsOneWidget);
  });

  testWidgets('says how long ago the last copy was made', (tester) async {
    await pump(
      tester,
      lastSharedAt: DateTime.now().subtract(const Duration(days: 5)),
    );

    expect(find.text('Остання копія: 5 днів тому'), findsOneWidget);
  });

  testWidgets('a phone that never made a copy says so', (tester) async {
    await pump(tester);

    expect(find.text(l10n.backupLastNever), findsOneWidget);
  });

  testWidgets('a phone under a megabyte is weighed in kilobytes', (
    tester,
  ) async {
    await pump(
      tester,
      contents: const DeviceContents(units: 1, documents: 0, bytes: 300000),
    );

    expect(find.text('1 об’єкт · 0 документів · 293 КБ'), findsOneWidget);
  });

  testWidgets('a phone with no object yet is not weighed at all', (
    tester,
  ) async {
    await pump(
      tester,
      contents: const DeviceContents(units: 0, documents: 0, bytes: 40960),
    );

    expect(find.text(l10n.settingsStoredHere), findsOneWidget);
    expect(find.textContaining('КБ'), findsNothing);
  });

  testWidgets('both actions are offered, each saying what it does', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text(l10n.backupCreate), findsOneWidget);
    expect(find.text(l10n.backupCreateHint), findsOneWidget);
    expect(find.text(l10n.backupRestore), findsOneWidget);
    expect(find.text(l10n.backupRestoreHint), findsOneWidget);
  });

  testWidgets('backing out of the picker asks nothing and changes nothing', (
    tester,
  ) async {
    await pump(tester);

    await tester.tap(find.text(l10n.backupRestore));
    await work(tester);

    expect(find.byType(DvConfirmDialog), findsNothing);
    expect(await units(), 0);
  });

  testWidgets('a file that is not a copy stops before the question', (
    tester,
  ) async {
    await pump(tester, picked: notACopy);

    await tester.tap(find.text(l10n.backupRestore));
    await work(tester);

    expect(find.byType(DvConfirmDialog), findsNothing);
    expect(await units(), 0);
  });

  testWidgets('the copy is named before it is allowed to replace anything', (
    tester,
  ) async {
    await pump(tester, picked: archive);

    await tester.tap(find.text(l10n.backupRestore));
    await work(tester);

    expect(
      find.text(
        l10n.backupRestoreConfirmBody(manifest.createdAt.asShortDate, 1, 0, 0),
      ),
      findsOneWidget,
    );
    // Still nothing replaced: the question is in front of the work, not behind
    // it.
    expect(await units(), 0);

    await tester.tap(find.text(l10n.backupRestoreConfirmCta));
    await work(tester);

    expect(await units(), 1);
  });

  testWidgets('saying no to the question leaves the data alone', (
    tester,
  ) async {
    await pump(tester, picked: archive);

    await tester.tap(find.text(l10n.backupRestore));
    await work(tester);

    await tester.tap(find.text(l10n.cancel));
    await work(tester);

    expect(await units(), 0);
  });
}
