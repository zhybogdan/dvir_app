// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Creating and editing an object, and the loading / error state of both.
///
/// One controller for the two because they are one form: the same five fields,
/// differing only in whether there is already a row behind them. Each action
/// returns its result so the screen can decide where to go next, and null when
/// the call failed, with the reason left in `state` for the toast.

@ProviderFor(UnitFormController)
final unitFormControllerProvider = UnitFormControllerProvider._();

/// Creating and editing an object, and the loading / error state of both.
///
/// One controller for the two because they are one form: the same five fields,
/// differing only in whether there is already a row behind them. Each action
/// returns its result so the screen can decide where to go next, and null when
/// the call failed, with the reason left in `state` for the toast.
final class UnitFormControllerProvider
    extends $AsyncNotifierProvider<UnitFormController, void> {
  /// Creating and editing an object, and the loading / error state of both.
  ///
  /// One controller for the two because they are one form: the same five fields,
  /// differing only in whether there is already a row behind them. Each action
  /// returns its result so the screen can decide where to go next, and null when
  /// the call failed, with the reason left in `state` for the toast.
  UnitFormControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unitFormControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unitFormControllerHash();

  @$internal
  @override
  UnitFormController create() => UnitFormController();
}

String _$unitFormControllerHash() =>
    r'46094bddb8abd69abbb151b7ad5b7dc74931b616';

/// Creating and editing an object, and the loading / error state of both.
///
/// One controller for the two because they are one form: the same five fields,
/// differing only in whether there is already a row behind them. Each action
/// returns its result so the screen can decide where to go next, and null when
/// the call failed, with the reason left in `state` for the toast.

abstract class _$UnitFormController extends $AsyncNotifier<void> {
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
