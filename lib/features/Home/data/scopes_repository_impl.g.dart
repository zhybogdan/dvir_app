// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scopes_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(scopesRepository)
final scopesRepositoryProvider = ScopesRepositoryProvider._();

final class ScopesRepositoryProvider
    extends
        $FunctionalProvider<
          ScopesRepository,
          ScopesRepository,
          ScopesRepository
        >
    with $Provider<ScopesRepository> {
  ScopesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scopesRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scopesRepositoryHash();

  @$internal
  @override
  $ProviderElement<ScopesRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ScopesRepository create(Ref ref) {
    return scopesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScopesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScopesRepository>(value),
    );
  }
}

String _$scopesRepositoryHash() => r'a0c81a30193478152b28556faf45cc49f75dc2a8';
