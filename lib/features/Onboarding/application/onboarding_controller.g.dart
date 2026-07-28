// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Drives the three ways into the app and exposes their loading / error state.
///
/// Each action returns its result so the caller can use it — the invite code of
/// a freshly created scope, or which kind of scope a code turned out to open —
/// and null when the call failed, with the reason left in `state`.
///
/// The controller never navigates: an action that changes where the user
/// belongs ends by refreshing [myScopesProvider], and the router redirect takes
/// them from there.

@ProviderFor(OnboardingController)
final onboardingControllerProvider = OnboardingControllerProvider._();

/// Drives the three ways into the app and exposes their loading / error state.
///
/// Each action returns its result so the caller can use it — the invite code of
/// a freshly created scope, or which kind of scope a code turned out to open —
/// and null when the call failed, with the reason left in `state`.
///
/// The controller never navigates: an action that changes where the user
/// belongs ends by refreshing [myScopesProvider], and the router redirect takes
/// them from there.
final class OnboardingControllerProvider
    extends $AsyncNotifierProvider<OnboardingController, void> {
  /// Drives the three ways into the app and exposes their loading / error state.
  ///
  /// Each action returns its result so the caller can use it — the invite code of
  /// a freshly created scope, or which kind of scope a code turned out to open —
  /// and null when the call failed, with the reason left in `state`.
  ///
  /// The controller never navigates: an action that changes where the user
  /// belongs ends by refreshing [myScopesProvider], and the router redirect takes
  /// them from there.
  OnboardingControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingControllerHash();

  @$internal
  @override
  OnboardingController create() => OnboardingController();
}

String _$onboardingControllerHash() =>
    r'fb01296fefcffb9a124da602c5a4402765a5b483';

/// Drives the three ways into the app and exposes their loading / error state.
///
/// Each action returns its result so the caller can use it — the invite code of
/// a freshly created scope, or which kind of scope a code turned out to open —
/// and null when the call failed, with the reason left in `state`.
///
/// The controller never navigates: an action that changes where the user
/// belongs ends by refreshing [myScopesProvider], and the router redirect takes
/// them from there.

abstract class _$OnboardingController extends $AsyncNotifier<void> {
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
