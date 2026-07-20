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
/// The controller never navigates: every action ends by refreshing
/// [myMembershipProvider], and the router redirect takes the user from there.

@ProviderFor(OnboardingController)
final onboardingControllerProvider = OnboardingControllerProvider._();

/// Drives the three ways into the app and exposes their loading / error state.
///
/// Each action returns its result so the caller can use it — the invite code of
/// a freshly created scope, or which kind of scope a code turned out to open —
/// and null when the call failed, with the reason left in `state`.
///
/// The controller never navigates: every action ends by refreshing
/// [myMembershipProvider], and the router redirect takes the user from there.
final class OnboardingControllerProvider
    extends $AsyncNotifierProvider<OnboardingController, void> {
  /// Drives the three ways into the app and exposes their loading / error state.
  ///
  /// Each action returns its result so the caller can use it — the invite code of
  /// a freshly created scope, or which kind of scope a code turned out to open —
  /// and null when the call failed, with the reason left in `state`.
  ///
  /// The controller never navigates: every action ends by refreshing
  /// [myMembershipProvider], and the router redirect takes the user from there.
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
    r'442ee04287178f1c144c85369f63d996e9b5cb6b';

/// Drives the three ways into the app and exposes their loading / error state.
///
/// Each action returns its result so the caller can use it — the invite code of
/// a freshly created scope, or which kind of scope a code turned out to open —
/// and null when the call failed, with the reason left in `state`.
///
/// The controller never navigates: every action ends by refreshing
/// [myMembershipProvider], and the router redirect takes the user from there.

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
