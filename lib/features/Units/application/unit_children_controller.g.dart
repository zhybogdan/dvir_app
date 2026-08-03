// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_children_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The objects that sit inside one object — the flats in a house, the boxes in
/// a row.
///
/// Read from the database rather than filtered out of the user's scope list:
/// this is everything the object contains, including what its owner created and
/// then handed to someone else.
///
/// Kept alive because the section sits at the bottom of the hub's scroll. A
/// `ListView` destroys a child that leaves the viewport, which takes the last
/// listener with it, which disposes an auto-disposing provider — so every
/// scroll down was a fresh query for a list that had not changed. Everything
/// that changes it already invalidates it: creating an object, deleting one,
/// and the hub's pull-to-refresh.

@ProviderFor(unitChildren)
final unitChildrenProvider = UnitChildrenFamily._();

/// The objects that sit inside one object — the flats in a house, the boxes in
/// a row.
///
/// Read from the database rather than filtered out of the user's scope list:
/// this is everything the object contains, including what its owner created and
/// then handed to someone else.
///
/// Kept alive because the section sits at the bottom of the hub's scroll. A
/// `ListView` destroys a child that leaves the viewport, which takes the last
/// listener with it, which disposes an auto-disposing provider — so every
/// scroll down was a fresh query for a list that had not changed. Everything
/// that changes it already invalidates it: creating an object, deleting one,
/// and the hub's pull-to-refresh.

final class UnitChildrenProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Unit>>,
          List<Unit>,
          FutureOr<List<Unit>>
        >
    with $FutureModifier<List<Unit>>, $FutureProvider<List<Unit>> {
  /// The objects that sit inside one object — the flats in a house, the boxes in
  /// a row.
  ///
  /// Read from the database rather than filtered out of the user's scope list:
  /// this is everything the object contains, including what its owner created and
  /// then handed to someone else.
  ///
  /// Kept alive because the section sits at the bottom of the hub's scroll. A
  /// `ListView` destroys a child that leaves the viewport, which takes the last
  /// listener with it, which disposes an auto-disposing provider — so every
  /// scroll down was a fresh query for a list that had not changed. Everything
  /// that changes it already invalidates it: creating an object, deleting one,
  /// and the hub's pull-to-refresh.
  UnitChildrenProvider._({
    required UnitChildrenFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'unitChildrenProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$unitChildrenHash();

  @override
  String toString() {
    return r'unitChildrenProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Unit>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Unit>> create(Ref ref) {
    final argument = this.argument as String;
    return unitChildren(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UnitChildrenProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$unitChildrenHash() => r'd5fb6edf292f90b2527cc43cb9291e1aa1053354';

/// The objects that sit inside one object — the flats in a house, the boxes in
/// a row.
///
/// Read from the database rather than filtered out of the user's scope list:
/// this is everything the object contains, including what its owner created and
/// then handed to someone else.
///
/// Kept alive because the section sits at the bottom of the hub's scroll. A
/// `ListView` destroys a child that leaves the viewport, which takes the last
/// listener with it, which disposes an auto-disposing provider — so every
/// scroll down was a fresh query for a list that had not changed. Everything
/// that changes it already invalidates it: creating an object, deleting one,
/// and the hub's pull-to-refresh.

final class UnitChildrenFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Unit>>, String> {
  UnitChildrenFamily._()
    : super(
        retry: null,
        name: r'unitChildrenProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// The objects that sit inside one object — the flats in a house, the boxes in
  /// a row.
  ///
  /// Read from the database rather than filtered out of the user's scope list:
  /// this is everything the object contains, including what its owner created and
  /// then handed to someone else.
  ///
  /// Kept alive because the section sits at the bottom of the hub's scroll. A
  /// `ListView` destroys a child that leaves the viewport, which takes the last
  /// listener with it, which disposes an auto-disposing provider — so every
  /// scroll down was a fresh query for a list that had not changed. Everything
  /// that changes it already invalidates it: creating an object, deleting one,
  /// and the hub's pull-to-refresh.

  UnitChildrenProvider call(String unitId) =>
      UnitChildrenProvider._(argument: unitId, from: this);

  @override
  String toString() => r'unitChildrenProvider';
}
