// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Defaults to throwing, and `main_unit.dart` overrides it.
///
/// The mirror of what that file does to `supabaseClientProvider`, for the
/// opposite reason: a copy of the whole phone only means something where the
/// phone is the only place the data lives. A build with a backend behind it
/// backs up on the server, not by zipping a device, so there is nothing here
/// for it to be given.

@ProviderFor(backupService)
final backupServiceProvider = BackupServiceProvider._();

/// Defaults to throwing, and `main_unit.dart` overrides it.
///
/// The mirror of what that file does to `supabaseClientProvider`, for the
/// opposite reason: a copy of the whole phone only means something where the
/// phone is the only place the data lives. A build with a backend behind it
/// backs up on the server, not by zipping a device, so there is nothing here
/// for it to be given.

final class BackupServiceProvider
    extends $FunctionalProvider<BackupService, BackupService, BackupService>
    with $Provider<BackupService> {
  /// Defaults to throwing, and `main_unit.dart` overrides it.
  ///
  /// The mirror of what that file does to `supabaseClientProvider`, for the
  /// opposite reason: a copy of the whole phone only means something where the
  /// phone is the only place the data lives. A build with a backend behind it
  /// backs up on the server, not by zipping a device, so there is nothing here
  /// for it to be given.
  BackupServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backupServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$backupServiceHash();

  @$internal
  @override
  $ProviderElement<BackupService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BackupService create(Ref ref) {
    return backupService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BackupService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BackupService>(value),
    );
  }
}

String _$backupServiceHash() => r'd4e55a792a7518e46cda94d30731d0941fd74f1d';

/// Where a copy is written and where one is unpacked.
///
/// The system temp folder on purpose. The copy is handed straight to the share
/// sheet and is of no use afterwards, and the app's own documents folder is
/// where the object's files live — copies accumulating in there would be
/// counted as the weight of the object they are a copy of.

@ProviderFor(backupWorkspace)
final backupWorkspaceProvider = BackupWorkspaceProvider._();

/// Where a copy is written and where one is unpacked.
///
/// The system temp folder on purpose. The copy is handed straight to the share
/// sheet and is of no use afterwards, and the app's own documents folder is
/// where the object's files live — copies accumulating in there would be
/// counted as the weight of the object they are a copy of.

final class BackupWorkspaceProvider
    extends
        $FunctionalProvider<
          AsyncValue<Directory>,
          Directory,
          FutureOr<Directory>
        >
    with $FutureModifier<Directory>, $FutureProvider<Directory> {
  /// Where a copy is written and where one is unpacked.
  ///
  /// The system temp folder on purpose. The copy is handed straight to the share
  /// sheet and is of no use afterwards, and the app's own documents folder is
  /// where the object's files live — copies accumulating in there would be
  /// counted as the weight of the object they are a copy of.
  BackupWorkspaceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backupWorkspaceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$backupWorkspaceHash();

  @$internal
  @override
  $FutureProviderElement<Directory> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Directory> create(Ref ref) {
    return backupWorkspace(ref);
  }
}

String _$backupWorkspaceHash() => r'9a10774dc6dd62c487b6af42cc9757c067a7af13';
