// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Auth and scopes read as one value, so a redirect never sees one of them
/// ahead of the other.
///
/// Watching both here puts them in a single dependency node, and `myScopes`
/// watches auth itself — so Riverpod recomputes it before this provider and the
/// pair is always consistent. Subscribing to the two separately let an auth
/// emission reach the router while the scope list still held the previous
/// session's answer, and a signed-in member was briefly ruled to belong
/// nowhere.

@ProviderFor(navigationState)
final navigationStateProvider = NavigationStateProvider._();

/// Auth and scopes read as one value, so a redirect never sees one of them
/// ahead of the other.
///
/// Watching both here puts them in a single dependency node, and `myScopes`
/// watches auth itself — so Riverpod recomputes it before this provider and the
/// pair is always consistent. Subscribing to the two separately let an auth
/// emission reach the router while the scope list still held the previous
/// session's answer, and a signed-in member was briefly ruled to belong
/// nowhere.

final class NavigationStateProvider
    extends
        $FunctionalProvider<NavigationState, NavigationState, NavigationState>
    with $Provider<NavigationState> {
  /// Auth and scopes read as one value, so a redirect never sees one of them
  /// ahead of the other.
  ///
  /// Watching both here puts them in a single dependency node, and `myScopes`
  /// watches auth itself — so Riverpod recomputes it before this provider and the
  /// pair is always consistent. Subscribing to the two separately let an auth
  /// emission reach the router while the scope list still held the previous
  /// session's answer, and a signed-in member was briefly ruled to belong
  /// nowhere.
  NavigationStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'navigationStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$navigationStateHash();

  @$internal
  @override
  $ProviderElement<NavigationState> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NavigationState create(Ref ref) {
    return navigationState(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NavigationState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NavigationState>(value),
    );
  }
}

String _$navigationStateHash() => r'9dd3b33d28b203d1abc78f82269e7d653ab72ff4';

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

String _$routerHash() => r'a855f280a1c43766f30a7a1387d19e36eac9bf17';
