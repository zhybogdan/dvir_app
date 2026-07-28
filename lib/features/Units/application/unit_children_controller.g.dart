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

@ProviderFor(unitChildren)
final unitChildrenProvider = UnitChildrenFamily._();

/// The objects that sit inside one object — the flats in a house, the boxes in
/// a row.
///
/// Read from the database rather than filtered out of the user's scope list:
/// this is everything the object contains, including what its owner created and
/// then handed to someone else.

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
  UnitChildrenProvider._({
    required UnitChildrenFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'unitChildrenProvider',
         isAutoDispose: true,
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

String _$unitChildrenHash() => r'35aed20e4273d6a12a627e26fea92848d45bbd8b';

/// The objects that sit inside one object — the flats in a house, the boxes in
/// a row.
///
/// Read from the database rather than filtered out of the user's scope list:
/// this is everything the object contains, including what its owner created and
/// then handed to someone else.

final class UnitChildrenFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Unit>>, String> {
  UnitChildrenFamily._()
    : super(
        retry: null,
        name: r'unitChildrenProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The objects that sit inside one object — the flats in a house, the boxes in
  /// a row.
  ///
  /// Read from the database rather than filtered out of the user's scope list:
  /// this is everything the object contains, including what its owner created and
  /// then handed to someone else.

  UnitChildrenProvider call(String unitId) =>
      UnitChildrenProvider._(argument: unitId, from: this);

  @override
  String toString() => r'unitChildrenProvider';
}
