// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'units_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(unitsRepository)
final unitsRepositoryProvider = UnitsRepositoryProvider._();

final class UnitsRepositoryProvider
    extends
        $FunctionalProvider<UnitsRepository, UnitsRepository, UnitsRepository>
    with $Provider<UnitsRepository> {
  UnitsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unitsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unitsRepositoryHash();

  @$internal
  @override
  $ProviderElement<UnitsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UnitsRepository create(Ref ref) {
    return unitsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UnitsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UnitsRepository>(value),
    );
  }
}

String _$unitsRepositoryHash() => r'612590784ea674f489f465115975e418a0884a2f';
