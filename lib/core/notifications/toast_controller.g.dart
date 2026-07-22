// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toast_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Holds the toasts currently on screen and the timers that retire them.
///
/// App-global and mounted above the router (see the overlay in `app/`), so a
/// toast survives navigation the way a `ScaffoldMessenger` one cannot, and can
/// be raised from anywhere that holds a `ref` — no `BuildContext`, no
/// `context.mounted` dance after an await.
///
/// `keepAlive` because this is app-wide state with live timers: an autoDispose
/// gap would cancel a toast mid-flight.

@ProviderFor(ToastController)
final toastControllerProvider = ToastControllerProvider._();

/// Holds the toasts currently on screen and the timers that retire them.
///
/// App-global and mounted above the router (see the overlay in `app/`), so a
/// toast survives navigation the way a `ScaffoldMessenger` one cannot, and can
/// be raised from anywhere that holds a `ref` — no `BuildContext`, no
/// `context.mounted` dance after an await.
///
/// `keepAlive` because this is app-wide state with live timers: an autoDispose
/// gap would cancel a toast mid-flight.
final class ToastControllerProvider
    extends $NotifierProvider<ToastController, List<DvToast>> {
  /// Holds the toasts currently on screen and the timers that retire them.
  ///
  /// App-global and mounted above the router (see the overlay in `app/`), so a
  /// toast survives navigation the way a `ScaffoldMessenger` one cannot, and can
  /// be raised from anywhere that holds a `ref` — no `BuildContext`, no
  /// `context.mounted` dance after an await.
  ///
  /// `keepAlive` because this is app-wide state with live timers: an autoDispose
  /// gap would cancel a toast mid-flight.
  ToastControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'toastControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$toastControllerHash();

  @$internal
  @override
  ToastController create() => ToastController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<DvToast> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<DvToast>>(value),
    );
  }
}

String _$toastControllerHash() => r'a521eb8e6d6e28269dfbdad4dba998ad4a35aaa2';

/// Holds the toasts currently on screen and the timers that retire them.
///
/// App-global and mounted above the router (see the overlay in `app/`), so a
/// toast survives navigation the way a `ScaffoldMessenger` one cannot, and can
/// be raised from anywhere that holds a `ref` — no `BuildContext`, no
/// `context.mounted` dance after an await.
///
/// `keepAlive` because this is app-wide state with live timers: an autoDispose
/// gap would cancel a toast mid-flight.

abstract class _$ToastController extends $Notifier<List<DvToast>> {
  List<DvToast> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<DvToast>, List<DvToast>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<DvToast>, List<DvToast>>,
              List<DvToast>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
