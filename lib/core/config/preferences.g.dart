// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Defaults to throwing, and `bootstrap` overrides it once the store is open.
///
/// Opened before the first frame rather than behind a future: `MaterialApp`
/// reads the theme from it, and a theme that arrives a frame late is a flash of
/// the wrong one on every start.

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

/// Defaults to throwing, and `bootstrap` overrides it once the store is open.
///
/// Opened before the first frame rather than behind a future: `MaterialApp`
/// reads the theme from it, and a theme that arrives a frame late is a flash of
/// the wrong one on every start.

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          SharedPreferencesWithCache,
          SharedPreferencesWithCache,
          SharedPreferencesWithCache
        >
    with $Provider<SharedPreferencesWithCache> {
  /// Defaults to throwing, and `bootstrap` overrides it once the store is open.
  ///
  /// Opened before the first frame rather than behind a future: `MaterialApp`
  /// reads the theme from it, and a theme that arrives a frame late is a flash of
  /// the wrong one on every start.
  SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $ProviderElement<SharedPreferencesWithCache> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferencesWithCache create(Ref ref) {
    return sharedPreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferencesWithCache value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferencesWithCache>(value),
    );
  }
}

String _$sharedPreferencesHash() => r'6a8c5052bd289b10052e9773062d42ae74e34723';
