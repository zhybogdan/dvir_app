// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Root navigation with auth- and membership-based redirects.
///
/// Both inputs come from providers (the repositories), never from Supabase
/// directly — the router stays on the app side of the data boundary and there
/// is a single subscription each behind the whole app.

@ProviderFor(router)
final routerProvider = RouterProvider._();

/// Root navigation with auth- and membership-based redirects.
///
/// Both inputs come from providers (the repositories), never from Supabase
/// directly — the router stays on the app side of the data boundary and there
/// is a single subscription each behind the whole app.

final class RouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// Root navigation with auth- and membership-based redirects.
  ///
  /// Both inputs come from providers (the repositories), never from Supabase
  /// directly — the router stays on the app side of the data boundary and there
  /// is a single subscription each behind the whole app.
  RouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'routerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$routerHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return router(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$routerHash() => r'171dc4e01e0ce19653908127c1c89cc3d5abccf7';
