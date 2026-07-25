// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Auth and membership read as one value, so a redirect never sees one of them
/// ahead of the other.
///
/// Watching both here puts them in a single dependency node, and `myMembership`
/// watches auth itself — so Riverpod recomputes it before this provider and the
/// pair is always consistent. Subscribing to the two separately let an auth
/// emission reach the router while membership still held the previous session's
/// answer, and a signed-in member was briefly ruled to belong nowhere.

@ProviderFor(navigationState)
final navigationStateProvider = NavigationStateProvider._();

/// Auth and membership read as one value, so a redirect never sees one of them
/// ahead of the other.
///
/// Watching both here puts them in a single dependency node, and `myMembership`
/// watches auth itself — so Riverpod recomputes it before this provider and the
/// pair is always consistent. Subscribing to the two separately let an auth
/// emission reach the router while membership still held the previous session's
/// answer, and a signed-in member was briefly ruled to belong nowhere.

final class NavigationStateProvider
    extends
        $FunctionalProvider<NavigationState, NavigationState, NavigationState>
    with $Provider<NavigationState> {
  /// Auth and membership read as one value, so a redirect never sees one of them
  /// ahead of the other.
  ///
  /// Watching both here puts them in a single dependency node, and `myMembership`
  /// watches auth itself — so Riverpod recomputes it before this provider and the
  /// pair is always consistent. Subscribing to the two separately let an auth
  /// emission reach the router while membership still held the previous session's
  /// answer, and a signed-in member was briefly ruled to belong nowhere.
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

String _$navigationStateHash() => r'0877831166034432f0419c9f62f0c502554becc2';

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

String _$routerHash() => r'f526beaab06c5085aa715771de3e981da52b454d';
