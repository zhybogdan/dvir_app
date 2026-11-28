// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// What the phone holds, for the settings screen to print above the button
/// that copies it.

@ProviderFor(deviceContents)
final deviceContentsProvider = DeviceContentsProvider._();

/// What the phone holds, for the settings screen to print above the button
/// that copies it.

final class DeviceContentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<DeviceContents>,
          DeviceContents,
          Stream<DeviceContents>
        >
    with $FutureModifier<DeviceContents>, $StreamProvider<DeviceContents> {
  /// What the phone holds, for the settings screen to print above the button
  /// that copies it.
  DeviceContentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceContentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceContentsHash();

  @$internal
  @override
  $StreamProviderElement<DeviceContents> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<DeviceContents> create(Ref ref) {
    return deviceContents(ref);
  }
}

String _$deviceContentsHash() => r'659f60e7f4d4fc748c6dcfe265fcc98fe1ec030c';

/// When this phone last sent a copy of itself somewhere — null until it has.
///
/// Shown under what the phone holds, because a device-only app's one real risk
/// is a copy made on the first day and never again: the phone is lost a year
/// later with a year of records nobody saved.

@ProviderFor(LastBackup)
final lastBackupProvider = LastBackupProvider._();

/// When this phone last sent a copy of itself somewhere — null until it has.
///
/// Shown under what the phone holds, because a device-only app's one real risk
/// is a copy made on the first day and never again: the phone is lost a year
/// later with a year of records nobody saved.
final class LastBackupProvider
    extends $NotifierProvider<LastBackup, DateTime?> {
  /// When this phone last sent a copy of itself somewhere — null until it has.
  ///
  /// Shown under what the phone holds, because a device-only app's one real risk
  /// is a copy made on the first day and never again: the phone is lost a year
  /// later with a year of records nobody saved.
  LastBackupProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lastBackupProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lastBackupHash();

  @$internal
  @override
  LastBackup create() => LastBackup();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime?>(value),
    );
  }
}

String _$lastBackupHash() => r'0a599d8e33dd3cb9824af3f0d48b11746ef78bb4';

/// When this phone last sent a copy of itself somewhere — null until it has.
///
/// Shown under what the phone holds, because a device-only app's one real risk
/// is a copy made on the first day and never again: the phone is lost a year
/// later with a year of records nobody saved.

abstract class _$LastBackup extends $Notifier<DateTime?> {
  DateTime? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DateTime?, DateTime?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime?, DateTime?>,
              DateTime?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
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

@ProviderFor(BackupActions)
final backupActionsProvider = BackupActionsProvider._();

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
final class BackupActionsProvider
    extends $AsyncNotifierProvider<BackupActions, void> {
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
  BackupActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backupActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$backupActionsHash();

  @$internal
  @override
  BackupActions create() => BackupActions();
}

String _$backupActionsHash() => r'037931a07b4e83744614f80f32a7812bc70d33b3';

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

abstract class _$BackupActions extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
