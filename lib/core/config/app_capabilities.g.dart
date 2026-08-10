// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_capabilities.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Defaults to the connected build, so that a screen or a test which says
/// nothing about flavours behaves as it always has. `main_unit.dart` overrides
/// it with [AppCapabilities.onDevice].

@ProviderFor(appCapabilities)
final appCapabilitiesProvider = AppCapabilitiesProvider._();

/// Defaults to the connected build, so that a screen or a test which says
/// nothing about flavours behaves as it always has. `main_unit.dart` overrides
/// it with [AppCapabilities.onDevice].

final class AppCapabilitiesProvider
    extends
        $FunctionalProvider<AppCapabilities, AppCapabilities, AppCapabilities>
    with $Provider<AppCapabilities> {
  /// Defaults to the connected build, so that a screen or a test which says
  /// nothing about flavours behaves as it always has. `main_unit.dart` overrides
  /// it with [AppCapabilities.onDevice].
  AppCapabilitiesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appCapabilitiesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appCapabilitiesHash();

  @$internal
  @override
  $ProviderElement<AppCapabilities> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppCapabilities create(Ref ref) {
    return appCapabilities(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppCapabilities value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppCapabilities>(value),
    );
  }
}

String _$appCapabilitiesHash() => r'e19d7e0f17da0f86793f203a6a54de4e04ca9ac9';
