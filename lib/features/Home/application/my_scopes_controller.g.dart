// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_scopes_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Every scope the current user belongs to, approved or not.
///
/// Rebuilt on every auth change on purpose: a membership belongs to whoever is
/// signed in, and signing out must not leave the previous user's scopes on
/// screen for the next one.

@ProviderFor(myScopes)
final myScopesProvider = MyScopesProvider._();

/// Every scope the current user belongs to, approved or not.
///
/// Rebuilt on every auth change on purpose: a membership belongs to whoever is
/// signed in, and signing out must not leave the previous user's scopes on
/// screen for the next one.

final class MyScopesProvider
    extends
        $FunctionalProvider<
          AsyncValue<MyScopes?>,
          MyScopes?,
          FutureOr<MyScopes?>
        >
    with $FutureModifier<MyScopes?>, $FutureProvider<MyScopes?> {
  /// Every scope the current user belongs to, approved or not.
  ///
  /// Rebuilt on every auth change on purpose: a membership belongs to whoever is
  /// signed in, and signing out must not leave the previous user's scopes on
  /// screen for the next one.
  MyScopesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myScopesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myScopesHash();

  @$internal
  @override
  $FutureProviderElement<MyScopes?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<MyScopes?> create(Ref ref) {
    return myScopes(ref);
  }
}

String _$myScopesHash() => r'ab36381f161ce8304719108af95816e00bf78ea5';
