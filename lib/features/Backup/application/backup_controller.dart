import 'dart:async';
import 'dart:io';

import 'package:dvir/core/config/app_version.dart';
import 'package:dvir/core/database/database_provider.dart';
import 'package:dvir/core/riverpod/guarded_actions.dart';
import 'package:dvir/core/utils/share.dart';
import 'package:dvir/features/Backup/data/backup_file_picker.dart';
import 'package:dvir/features/Backup/data/backup_history.dart';
import 'package:dvir/features/Backup/data/backup_service.dart';
import 'package:dvir/features/Backup/domain/models/backup_manifest.dart';
import 'package:dvir/features/Backup/domain/models/device_contents.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'backup_controller.g.dart';

/// What the phone holds, for the settings screen to print above the button
/// that copies it.
@riverpod
Stream<DeviceContents> deviceContents(Ref ref) =>
    ref.watch(backupServiceProvider).watchContents();

/// When this phone last sent a copy of itself somewhere — null until it has.
///
/// Shown under what the phone holds, because a device-only app's one real risk
/// is a copy made on the first day and never again: the phone is lost a year
/// later with a year of records nobody saved.
@Riverpod(keepAlive: true)
class LastBackup extends _$LastBackup {
  @override
  DateTime? build() => ref.watch(backupHistoryProvider).lastSharedAt;

  Future<void> record(DateTime at) {
    final history = ref.read(backupHistoryProvider);
    state = at;

    return history.recordShared(at);
  }
}

/// Making a copy of everything on the phone, and putting one back.
///
/// **A screen driving this must also listen to it** — nothing watches it for a
/// value, so without a listener it is disposed as soon as it is read and its
/// refusals reach nobody.
///
/// Restoring is deliberately three calls and not one: pick, read, replace. What
/// sits between the second and the third is the person being shown what they
/// are about to swap in and saying yes, and a single method would have to ask
/// that question from inside the data layer.
@riverpod
class BackupActions extends _$BackupActions with GuardedActions {
  @override
  FutureOr<void> build() {}

  /// Writes a copy and opens the share sheet on it. False when it failed, in
  /// which case the listener has already said why.
  ///
  /// The date is kept only once the sheet was not simply closed: a copy
  /// written and then dropped is not one the person has.
  Future<bool> share() {
    final service = ref.read(backupServiceProvider);
    final lastBackup = ref.read(lastBackupProvider.notifier);

    return guardedVoid(() async {
      // Both before the file is written, so that a slow version lookup cannot
      // land between the archive and the sheet.
      final workspace = await ref.read(backupWorkspaceProvider.future);
      final version = await ref.read(appVersionProvider.future);

      final archive = await service.write(into: workspace, appVersion: version);

      final shared = await shareFile(archive.path);
      if (shared) await lastBackup.record(DateTime.now());
    });
  }

  /// What the person picked, or null when they backed out — the one answer that
  /// is not a failure and must not be reported as one.
  Future<File?> pick() => ref.read(backupFilePickerProvider).pick();

  /// What [file] says about itself, or null when it is not a copy this build
  /// can read.
  Future<BackupManifest?> read(File file) {
    final service = ref.read(backupServiceProvider);

    return guarded(() => service.read(file));
  }

  /// Replaces everything on the phone with what [file] holds.
  ///
  /// Afterwards the database provider is thrown away rather than a list of
  /// screens being refreshed. Every repository watches it, so one line is what
  /// makes the whole tree below stale — and a hand-written list of what to
  /// re-read is what the next feature forgets to join.
  Future<bool> restore(File file) {
    final service = ref.read(backupServiceProvider);

    return guardedVoid(
      () async => service.restore(
        file,
        work: await ref.read(backupWorkspaceProvider.future),
      ),
      onSuccess: () => ref.invalidate(appDatabaseProvider),
    );
  }
}
