// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_attributes_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(unitAttributesRepository)
final unitAttributesRepositoryProvider = UnitAttributesRepositoryProvider._();

final class UnitAttributesRepositoryProvider
    extends
        $FunctionalProvider<
          UnitAttributesRepository,
          UnitAttributesRepository,
          UnitAttributesRepository
        >
    with $Provider<UnitAttributesRepository> {
  UnitAttributesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unitAttributesRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unitAttributesRepositoryHash();

  @$internal
  @override
  $ProviderElement<UnitAttributesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UnitAttributesRepository create(Ref ref) {
    return unitAttributesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UnitAttributesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UnitAttributesRepository>(value),
    );
  }
}

String _$unitAttributesRepositoryHash() =>
    r'525467a6ac55f1b5999c69f831fecedad7c386ab';
