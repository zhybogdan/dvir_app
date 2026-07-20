// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Root navigation with auth-based redirects.
///
/// Auth state comes from [authStateProvider] (the repository), never from
/// Supabase directly — the router stays on the app side of the data boundary
/// and there is a single subscription behind the whole app.
///
/// For now it's a two-state guard: signed out vs signed in. Community
/// onboarding (auth but no community → onboarding, pending approval, etc.) is
/// layered on in Phase 3 per the roadmap.

@ProviderFor(router)
final routerProvider = RouterProvider._();

/// Root navigation with auth-based redirects.
///
/// Auth state comes from [authStateProvider] (the repository), never from
/// Supabase directly — the router stays on the app side of the data boundary
/// and there is a single subscription behind the whole app.
///
/// For now it's a two-state guard: signed out vs signed in. Community
/// onboarding (auth but no community → onboarding, pending approval, etc.) is
/// layered on in Phase 3 per the roadmap.

final class RouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// Root navigation with auth-based redirects.
  ///
  /// Auth state comes from [authStateProvider] (the repository), never from
  /// Supabase directly — the router stays on the app side of the data boundary
  /// and there is a single subscription behind the whole app.
  ///
  /// For now it's a two-state guard: signed out vs signed in. Community
  /// onboarding (auth but no community → onboarding, pending approval, etc.) is
  /// layered on in Phase 3 per the roadmap.
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

String _$routerHash() => r'8faab8d0deaa28a39f31e4979e5c44189ac52be6';
