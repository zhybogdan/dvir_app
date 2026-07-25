// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'created_scope_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Carries a freshly created scope to the success screen.
///
/// Deliberately not `GoRouterState.extra`: go_router serialises extra into the
/// navigation state, and every router refresh — membership reloading, for one —
/// hands it back JSON-decoded as a plain `Map`. The typed model is gone by then,
/// so the screen's `is Unit` check fails and the invite code is lost.

@ProviderFor(CreatedScopeController)
final createdScopeControllerProvider = CreatedScopeControllerProvider._();

/// Carries a freshly created scope to the success screen.
///
/// Deliberately not `GoRouterState.extra`: go_router serialises extra into the
/// navigation state, and every router refresh — membership reloading, for one —
/// hands it back JSON-decoded as a plain `Map`. The typed model is gone by then,
/// so the screen's `is Unit` check fails and the invite code is lost.
final class CreatedScopeControllerProvider
    extends $NotifierProvider<CreatedScopeController, CreatedScope?> {
  /// Carries a freshly created scope to the success screen.
  ///
  /// Deliberately not `GoRouterState.extra`: go_router serialises extra into the
  /// navigation state, and every router refresh — membership reloading, for one —
  /// hands it back JSON-decoded as a plain `Map`. The typed model is gone by then,
  /// so the screen's `is Unit` check fails and the invite code is lost.
  CreatedScopeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createdScopeControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createdScopeControllerHash();

  @$internal
  @override
  CreatedScopeController create() => CreatedScopeController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreatedScope? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreatedScope?>(value),
    );
  }
}

String _$createdScopeControllerHash() =>
    r'8423b8868a02c06eaad47b87f9749386df5c6033';

/// Carries a freshly created scope to the success screen.
///
/// Deliberately not `GoRouterState.extra`: go_router serialises extra into the
/// navigation state, and every router refresh — membership reloading, for one —
/// hands it back JSON-decoded as a plain `Map`. The typed model is gone by then,
/// so the screen's `is Unit` check fails and the invite code is lost.

abstract class _$CreatedScopeController extends $Notifier<CreatedScope?> {
  CreatedScope? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CreatedScope?, CreatedScope?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CreatedScope?, CreatedScope?>,
              CreatedScope?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
