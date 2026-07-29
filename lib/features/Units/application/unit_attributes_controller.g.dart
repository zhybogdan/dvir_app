// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_attributes_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The record one object keeps about itself.
///
/// A notifier rather than a plain future so the order can be shown before the
/// database has agreed to it — see [applyOrder].

@ProviderFor(UnitAttributes)
final unitAttributesProvider = UnitAttributesFamily._();

/// The record one object keeps about itself.
///
/// A notifier rather than a plain future so the order can be shown before the
/// database has agreed to it — see [applyOrder].
final class UnitAttributesProvider
    extends $AsyncNotifierProvider<UnitAttributes, List<UnitAttribute>> {
  /// The record one object keeps about itself.
  ///
  /// A notifier rather than a plain future so the order can be shown before the
  /// database has agreed to it — see [applyOrder].
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
  UnitAttributes create() => UnitAttributes();

  @override
  bool operator ==(Object other) {
    return other is UnitAttributesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$unitAttributesHash() => r'720907e46397e701442e0df9aace974d1ff44a5d';

/// The record one object keeps about itself.
///
/// A notifier rather than a plain future so the order can be shown before the
/// database has agreed to it — see [applyOrder].

final class UnitAttributesFamily extends $Family
    with
        $ClassFamilyOverride<
          UnitAttributes,
          AsyncValue<List<UnitAttribute>>,
          List<UnitAttribute>,
          FutureOr<List<UnitAttribute>>,
          String
        > {
  UnitAttributesFamily._()
    : super(
        retry: null,
        name: r'unitAttributesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The record one object keeps about itself.
  ///
  /// A notifier rather than a plain future so the order can be shown before the
  /// database has agreed to it — see [applyOrder].

  UnitAttributesProvider call(String unitId) =>
      UnitAttributesProvider._(argument: unitId, from: this);

  @override
  String toString() => r'unitAttributesProvider';
}

/// The record one object keeps about itself.
///
/// A notifier rather than a plain future so the order can be shown before the
/// database has agreed to it — see [applyOrder].

abstract class _$UnitAttributes extends $AsyncNotifier<List<UnitAttribute>> {
  late final _$args = ref.$arg as String;
  String get unitId => _$args;

  FutureOr<List<UnitAttribute>> build(String unitId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<UnitAttribute>>, List<UnitAttribute>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<UnitAttribute>>, List<UnitAttribute>>,
              AsyncValue<List<UnitAttribute>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// Adding, rewording, dropping and reordering the facts of one object.
///
/// Keyed by the object so a refusal on one screen cannot light up another, and
/// so the list to re-read afterwards is known without being passed in.
///
/// **A screen driving this must also listen to it** — nothing watches it for a
/// value, so without a listener it is disposed the moment it is read, and its
/// failures reach nobody.

@ProviderFor(UnitAttributeActions)
final unitAttributeActionsProvider = UnitAttributeActionsFamily._();

/// Adding, rewording, dropping and reordering the facts of one object.
///
/// Keyed by the object so a refusal on one screen cannot light up another, and
/// so the list to re-read afterwards is known without being passed in.
///
/// **A screen driving this must also listen to it** — nothing watches it for a
/// value, so without a listener it is disposed the moment it is read, and its
/// failures reach nobody.
final class UnitAttributeActionsProvider
    extends $AsyncNotifierProvider<UnitAttributeActions, void> {
  /// Adding, rewording, dropping and reordering the facts of one object.
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
    r'30f8d7fbefc0550e94489749ad030b922bf72e4e';

/// Adding, rewording, dropping and reordering the facts of one object.
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

  /// Adding, rewording, dropping and reordering the facts of one object.
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

/// Adding, rewording, dropping and reordering the facts of one object.
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
