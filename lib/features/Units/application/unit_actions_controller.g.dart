// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_actions_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// What an owner can do to the object itself, as opposed to its contents.
///
/// Keyed by the object, so a failure on one screen cannot light up another and
/// the caches to clear afterwards are known without being passed in.
///
/// **A screen driving this must also listen to it.** Nothing here is watched
/// for its value — the actions are fired from callbacks — so without a listener
/// the provider is disposed the moment it is read, and the result lands on a
/// dead notifier. Listening is also the only way its failures reach the user.

@ProviderFor(UnitActions)
final unitActionsProvider = UnitActionsFamily._();

/// What an owner can do to the object itself, as opposed to its contents.
///
/// Keyed by the object, so a failure on one screen cannot light up another and
/// the caches to clear afterwards are known without being passed in.
///
/// **A screen driving this must also listen to it.** Nothing here is watched
/// for its value — the actions are fired from callbacks — so without a listener
/// the provider is disposed the moment it is read, and the result lands on a
/// dead notifier. Listening is also the only way its failures reach the user.
final class UnitActionsProvider
    extends $AsyncNotifierProvider<UnitActions, void> {
  /// What an owner can do to the object itself, as opposed to its contents.
  ///
  /// Keyed by the object, so a failure on one screen cannot light up another and
  /// the caches to clear afterwards are known without being passed in.
  ///
  /// **A screen driving this must also listen to it.** Nothing here is watched
  /// for its value — the actions are fired from callbacks — so without a listener
  /// the provider is disposed the moment it is read, and the result lands on a
  /// dead notifier. Listening is also the only way its failures reach the user.
  UnitActionsProvider._({
    required UnitActionsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'unitActionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$unitActionsHash();

  @override
  String toString() {
    return r'unitActionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  UnitActions create() => UnitActions();

  @override
  bool operator ==(Object other) {
    return other is UnitActionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$unitActionsHash() => r'267f028f4eb995ad5ae2fde5dd6013f8d60e7053';

/// What an owner can do to the object itself, as opposed to its contents.
///
/// Keyed by the object, so a failure on one screen cannot light up another and
/// the caches to clear afterwards are known without being passed in.
///
/// **A screen driving this must also listen to it.** Nothing here is watched
/// for its value — the actions are fired from callbacks — so without a listener
/// the provider is disposed the moment it is read, and the result lands on a
/// dead notifier. Listening is also the only way its failures reach the user.

final class UnitActionsFamily extends $Family
    with
        $ClassFamilyOverride<
          UnitActions,
          AsyncValue<void>,
          void,
          FutureOr<void>,
          String
        > {
  UnitActionsFamily._()
    : super(
        retry: null,
        name: r'unitActionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// What an owner can do to the object itself, as opposed to its contents.
  ///
  /// Keyed by the object, so a failure on one screen cannot light up another and
  /// the caches to clear afterwards are known without being passed in.
  ///
  /// **A screen driving this must also listen to it.** Nothing here is watched
  /// for its value — the actions are fired from callbacks — so without a listener
  /// the provider is disposed the moment it is read, and the result lands on a
  /// dead notifier. Listening is also the only way its failures reach the user.

  UnitActionsProvider call(String unitId) =>
      UnitActionsProvider._(argument: unitId, from: this);

  @override
  String toString() => r'unitActionsProvider';
}

/// What an owner can do to the object itself, as opposed to its contents.
///
/// Keyed by the object, so a failure on one screen cannot light up another and
/// the caches to clear afterwards are known without being passed in.
///
/// **A screen driving this must also listen to it.** Nothing here is watched
/// for its value — the actions are fired from callbacks — so without a listener
/// the provider is disposed the moment it is read, and the result lands on a
/// dead notifier. Listening is also the only way its failures reach the user.

abstract class _$UnitActions extends $AsyncNotifier<void> {
  late final _$args = ref.$arg as String;
  String get unitId => _$args;

  FutureOr<void> build(String unitId);
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
    return element.handleCreate(ref, () => build(_$args));
  }
}
