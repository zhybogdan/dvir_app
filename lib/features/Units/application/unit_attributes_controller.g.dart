// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_attributes_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The record one object keeps about itself.

@ProviderFor(unitAttributes)
final unitAttributesProvider = UnitAttributesFamily._();

/// The record one object keeps about itself.

final class UnitAttributesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UnitAttribute>>,
          List<UnitAttribute>,
          FutureOr<List<UnitAttribute>>
        >
    with
        $FutureModifier<List<UnitAttribute>>,
        $FutureProvider<List<UnitAttribute>> {
  /// The record one object keeps about itself.
  UnitAttributesProvider._({
    required UnitAttributesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'unitAttributesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$unitAttributesHash();

  @override
  String toString() {
    return r'unitAttributesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<UnitAttribute>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<UnitAttribute>> create(Ref ref) {
    final argument = this.argument as String;
    return unitAttributes(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UnitAttributesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$unitAttributesHash() => r'24bef8c868072cac3371803151a98790a7ff6583';

/// The record one object keeps about itself.

final class UnitAttributesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<UnitAttribute>>, String> {
  UnitAttributesFamily._()
    : super(
        retry: null,
        name: r'unitAttributesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The record one object keeps about itself.

  UnitAttributesProvider call(String unitId) =>
      UnitAttributesProvider._(argument: unitId, from: this);

  @override
  String toString() => r'unitAttributesProvider';
}

/// Adding, rewording and dropping the facts of one object.
///
/// Keyed by the object so a refusal on one screen cannot light up another, and
/// so the list to re-read afterwards is known without being passed in.
///
/// **A screen driving this must also listen to it** — nothing watches it for a
/// value, so without a listener it is disposed the moment it is read, and its
/// failures reach nobody.

@ProviderFor(UnitAttributeActions)
final unitAttributeActionsProvider = UnitAttributeActionsFamily._();

/// Adding, rewording and dropping the facts of one object.
///
/// Keyed by the object so a refusal on one screen cannot light up another, and
/// so the list to re-read afterwards is known without being passed in.
///
/// **A screen driving this must also listen to it** — nothing watches it for a
/// value, so without a listener it is disposed the moment it is read, and its
/// failures reach nobody.
final class UnitAttributeActionsProvider
    extends $AsyncNotifierProvider<UnitAttributeActions, void> {
  /// Adding, rewording and dropping the facts of one object.
  ///
  /// Keyed by the object so a refusal on one screen cannot light up another, and
  /// so the list to re-read afterwards is known without being passed in.
  ///
  /// **A screen driving this must also listen to it** — nothing watches it for a
  /// value, so without a listener it is disposed the moment it is read, and its
  /// failures reach nobody.
  UnitAttributeActionsProvider._({
    required UnitAttributeActionsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'unitAttributeActionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$unitAttributeActionsHash();

  @override
  String toString() {
    return r'unitAttributeActionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  UnitAttributeActions create() => UnitAttributeActions();

  @override
  bool operator ==(Object other) {
    return other is UnitAttributeActionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$unitAttributeActionsHash() =>
    r'b9ab6983cf3e3e04c5fee55f2a06af5e2ed31035';

/// Adding, rewording and dropping the facts of one object.
///
/// Keyed by the object so a refusal on one screen cannot light up another, and
/// so the list to re-read afterwards is known without being passed in.
///
/// **A screen driving this must also listen to it** — nothing watches it for a
/// value, so without a listener it is disposed the moment it is read, and its
/// failures reach nobody.

final class UnitAttributeActionsFamily extends $Family
    with
        $ClassFamilyOverride<
          UnitAttributeActions,
          AsyncValue<void>,
          void,
          FutureOr<void>,
          String
        > {
  UnitAttributeActionsFamily._()
    : super(
        retry: null,
        name: r'unitAttributeActionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Adding, rewording and dropping the facts of one object.
  ///
  /// Keyed by the object so a refusal on one screen cannot light up another, and
  /// so the list to re-read afterwards is known without being passed in.
  ///
  /// **A screen driving this must also listen to it** — nothing watches it for a
  /// value, so without a listener it is disposed the moment it is read, and its
  /// failures reach nobody.

  UnitAttributeActionsProvider call(String unitId) =>
      UnitAttributeActionsProvider._(argument: unitId, from: this);

  @override
  String toString() => r'unitAttributeActionsProvider';
}

/// Adding, rewording and dropping the facts of one object.
///
/// Keyed by the object so a refusal on one screen cannot light up another, and
/// so the list to re-read afterwards is known without being passed in.
///
/// **A screen driving this must also listen to it** — nothing watches it for a
/// value, so without a listener it is disposed the moment it is read, and its
/// failures reach nobody.

abstract class _$UnitAttributeActions extends $AsyncNotifier<void> {
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
