// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_history.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(backupHistory)
final backupHistoryProvider = BackupHistoryProvider._();

final class BackupHistoryProvider
    extends $FunctionalProvider<BackupHistory, BackupHistory, BackupHistory>
    with $Provider<BackupHistory> {
  BackupHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backupHistoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$backupHistoryHash();

  @$internal
  @override
  $ProviderElement<BackupHistory> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BackupHistory create(Ref ref) {
    return backupHistory(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BackupHistory value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BackupHistory>(value),
    );
  }
}

String _$backupHistoryHash() => r'83704f81bf9bacca91ddede289bfbae81f64b98b';
