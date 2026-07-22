// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Current signed-in user as a stream (null when signed out).
/// The router and any UI that needs "who am I" watch this.

@ProviderFor(authState)
final authStateProvider = AuthStateProvider._();

/// Current signed-in user as a stream (null when signed out).
/// The router and any UI that needs "who am I" watch this.

final class AuthStateProvider
    extends
        $FunctionalProvider<AsyncValue<AppUser?>, AppUser?, Stream<AppUser?>>
    with $FutureModifier<AppUser?>, $StreamProvider<AppUser?> {
  /// Current signed-in user as a stream (null when signed out).
  /// The router and any UI that needs "who am I" watch this.
  AuthStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authStateHash();

  @$internal
  @override
  $StreamProviderElement<AppUser?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<AppUser?> create(Ref ref) {
    return authState(ref);
  }
}

String _$authStateHash() => r'6ce439e56f78a7861b8f3d71d298011f47656b9a';

/// Drives auth actions and exposes their loading / error state.
///
/// `AsyncValue.guard` runs the future and captures success or the thrown
/// [Failure] into `state`, so screens react with `.isLoading` / `.hasError`
/// without manual try/catch. On success the auth stream changes and the router
/// redirect handles navigation — the controller never navigates itself.

@ProviderFor(AuthController)
final authControllerProvider = AuthControllerProvider._();

/// Drives auth actions and exposes their loading / error state.
///
/// `AsyncValue.guard` runs the future and captures success or the thrown
/// [Failure] into `state`, so screens react with `.isLoading` / `.hasError`
/// without manual try/catch. On success the auth stream changes and the router
/// redirect handles navigation — the controller never navigates itself.
final class AuthControllerProvider
    extends $AsyncNotifierProvider<AuthController, void> {
  /// Drives auth actions and exposes their loading / error state.
  ///
  /// `AsyncValue.guard` runs the future and captures success or the thrown
  /// [Failure] into `state`, so screens react with `.isLoading` / `.hasError`
  /// without manual try/catch. On success the auth stream changes and the router
  /// redirect handles navigation — the controller never navigates itself.
  AuthControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authControllerHash();

  @$internal
  @override
  AuthController create() => AuthController();
}

String _$authControllerHash() => r'16bc29f15aa7545c3b2bfe0e82fed44282704636';

/// Drives auth actions and exposes their loading / error state.
///
/// `AsyncValue.guard` runs the future and captures success or the thrown
/// [Failure] into `state`, so screens react with `.isLoading` / `.hasError`
/// without manual try/catch. On success the auth stream changes and the router
/// redirect handles navigation — the controller never navigates itself.

abstract class _$AuthController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
