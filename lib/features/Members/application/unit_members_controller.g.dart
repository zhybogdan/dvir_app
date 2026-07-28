// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_members_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Everyone attached to one object, requests included.

@ProviderFor(unitMembers)
final unitMembersProvider = UnitMembersFamily._();

/// Everyone attached to one object, requests included.

final class UnitMembersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UnitMemberView>>,
          List<UnitMemberView>,
          FutureOr<List<UnitMemberView>>
        >
    with
        $FutureModifier<List<UnitMemberView>>,
        $FutureProvider<List<UnitMemberView>> {
  /// Everyone attached to one object, requests included.
  UnitMembersProvider._({
    required UnitMembersFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'unitMembersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$unitMembersHash();

  @override
  String toString() {
    return r'unitMembersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<UnitMemberView>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<UnitMemberView>> create(Ref ref) {
    final argument = this.argument as String;
    return unitMembers(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UnitMembersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$unitMembersHash() => r'60d70c3a1dc913c1a1916ded98b90bc62ed81eb8';

/// Everyone attached to one object, requests included.

final class UnitMembersFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<UnitMemberView>>, String> {
  UnitMembersFamily._()
    : super(
        retry: null,
        name: r'unitMembersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Everyone attached to one object, requests included.

  UnitMembersProvider call(String unitId) =>
      UnitMembersProvider._(argument: unitId, from: this);

  @override
  String toString() => r'unitMembersProvider';
}

/// The signed-in user's role in this object, or null when they have none.
///
/// Null is a real answer rather than an error: an admin of the owning community
/// manages an object without living in it, so they see the screen while
/// belonging to nobody's household.

@ProviderFor(myUnitRole)
final myUnitRoleProvider = MyUnitRoleFamily._();

/// The signed-in user's role in this object, or null when they have none.
///
/// Null is a real answer rather than an error: an admin of the owning community
/// manages an object without living in it, so they see the screen while
/// belonging to nobody's household.

final class MyUnitRoleProvider
    extends
        $FunctionalProvider<
          AsyncValue<UnitRole?>,
          UnitRole?,
          FutureOr<UnitRole?>
        >
    with $FutureModifier<UnitRole?>, $FutureProvider<UnitRole?> {
  /// The signed-in user's role in this object, or null when they have none.
  ///
  /// Null is a real answer rather than an error: an admin of the owning community
  /// manages an object without living in it, so they see the screen while
  /// belonging to nobody's household.
  MyUnitRoleProvider._({
    required MyUnitRoleFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'myUnitRoleProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$myUnitRoleHash();

  @override
  String toString() {
    return r'myUnitRoleProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<UnitRole?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<UnitRole?> create(Ref ref) {
    final argument = this.argument as String;
    return myUnitRole(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MyUnitRoleProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$myUnitRoleHash() => r'48c561466d9923c8b62de42247e5f5f8583ca377';

/// The signed-in user's role in this object, or null when they have none.
///
/// Null is a real answer rather than an error: an admin of the owning community
/// manages an object without living in it, so they see the screen while
/// belonging to nobody's household.

final class MyUnitRoleFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<UnitRole?>, String> {
  MyUnitRoleFamily._()
    : super(
        retry: null,
        name: r'myUnitRoleProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The signed-in user's role in this object, or null when they have none.
  ///
  /// Null is a real answer rather than an error: an admin of the owning community
  /// manages an object without living in it, so they see the screen while
  /// belonging to nobody's household.

  MyUnitRoleProvider call(String unitId) =>
      MyUnitRoleProvider._(argument: unitId, from: this);

  @override
  String toString() => r'myUnitRoleProvider';
}
