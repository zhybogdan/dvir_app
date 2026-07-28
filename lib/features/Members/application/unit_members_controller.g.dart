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

/// Whether the signed-in user runs this object.
///
/// Derived here rather than compared at each call site: the hub asks three
/// times over — for the app-bar actions, the invite code and the residents
/// list — and three copies of the same comparison are three places for it to
/// drift. Loading counts as "no": what an owner is offered appears once the
/// role is known, rather than flashing and being taken away.

@ProviderFor(isUnitOwner)
final isUnitOwnerProvider = IsUnitOwnerFamily._();

/// Whether the signed-in user runs this object.
///
/// Derived here rather than compared at each call site: the hub asks three
/// times over — for the app-bar actions, the invite code and the residents
/// list — and three copies of the same comparison are three places for it to
/// drift. Loading counts as "no": what an owner is offered appears once the
/// role is known, rather than flashing and being taken away.

final class IsUnitOwnerProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether the signed-in user runs this object.
  ///
  /// Derived here rather than compared at each call site: the hub asks three
  /// times over — for the app-bar actions, the invite code and the residents
  /// list — and three copies of the same comparison are three places for it to
  /// drift. Loading counts as "no": what an owner is offered appears once the
  /// role is known, rather than flashing and being taken away.
  IsUnitOwnerProvider._({
    required IsUnitOwnerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'isUnitOwnerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isUnitOwnerHash();

  @override
  String toString() {
    return r'isUnitOwnerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as String;
    return isUnitOwner(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is IsUnitOwnerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isUnitOwnerHash() => r'f9f8301e56e46b6a872a8164e2b63cdcc5cd5844';

/// Whether the signed-in user runs this object.
///
/// Derived here rather than compared at each call site: the hub asks three
/// times over — for the app-bar actions, the invite code and the residents
/// list — and three copies of the same comparison are three places for it to
/// drift. Loading counts as "no": what an owner is offered appears once the
/// role is known, rather than flashing and being taken away.

final class IsUnitOwnerFamily extends $Family
    with $FunctionalFamilyOverride<bool, String> {
  IsUnitOwnerFamily._()
    : super(
        retry: null,
        name: r'isUnitOwnerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Whether the signed-in user runs this object.
  ///
  /// Derived here rather than compared at each call site: the hub asks three
  /// times over — for the app-bar actions, the invite code and the residents
  /// list — and three copies of the same comparison are three places for it to
  /// drift. Loading counts as "no": what an owner is offered appears once the
  /// role is known, rather than flashing and being taken away.

  IsUnitOwnerProvider call(String unitId) =>
      IsUnitOwnerProvider._(argument: unitId, from: this);

  @override
  String toString() => r'isUnitOwnerProvider';
}

/// Deciding on the people of one object, and the loading / error state of it.
///
/// Keyed by the object so a refusal on one screen cannot light up another, and
/// so the list to re-read afterwards is known without being passed in.
///
/// The rules are not repeated here — the database owns them and answers DV004
/// and DV005, which the failure mapper turns into a sentence. This only asks.

@ProviderFor(UnitMemberModeration)
final unitMemberModerationProvider = UnitMemberModerationFamily._();

/// Deciding on the people of one object, and the loading / error state of it.
///
/// Keyed by the object so a refusal on one screen cannot light up another, and
/// so the list to re-read afterwards is known without being passed in.
///
/// The rules are not repeated here — the database owns them and answers DV004
/// and DV005, which the failure mapper turns into a sentence. This only asks.
final class UnitMemberModerationProvider
    extends $AsyncNotifierProvider<UnitMemberModeration, void> {
  /// Deciding on the people of one object, and the loading / error state of it.
  ///
  /// Keyed by the object so a refusal on one screen cannot light up another, and
  /// so the list to re-read afterwards is known without being passed in.
  ///
  /// The rules are not repeated here — the database owns them and answers DV004
  /// and DV005, which the failure mapper turns into a sentence. This only asks.
  UnitMemberModerationProvider._({
    required UnitMemberModerationFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'unitMemberModerationProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$unitMemberModerationHash();

  @override
  String toString() {
    return r'unitMemberModerationProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  UnitMemberModeration create() => UnitMemberModeration();

  @override
  bool operator ==(Object other) {
    return other is UnitMemberModerationProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$unitMemberModerationHash() =>
    r'7bd94a6161b456c0fb8a12a110ffc4f2db0a874f';

/// Deciding on the people of one object, and the loading / error state of it.
///
/// Keyed by the object so a refusal on one screen cannot light up another, and
/// so the list to re-read afterwards is known without being passed in.
///
/// The rules are not repeated here — the database owns them and answers DV004
/// and DV005, which the failure mapper turns into a sentence. This only asks.

final class UnitMemberModerationFamily extends $Family
    with
        $ClassFamilyOverride<
          UnitMemberModeration,
          AsyncValue<void>,
          void,
          FutureOr<void>,
          String
        > {
  UnitMemberModerationFamily._()
    : super(
        retry: null,
        name: r'unitMemberModerationProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Deciding on the people of one object, and the loading / error state of it.
  ///
  /// Keyed by the object so a refusal on one screen cannot light up another, and
  /// so the list to re-read afterwards is known without being passed in.
  ///
  /// The rules are not repeated here — the database owns them and answers DV004
  /// and DV005, which the failure mapper turns into a sentence. This only asks.

  UnitMemberModerationProvider call(String unitId) =>
      UnitMemberModerationProvider._(argument: unitId, from: this);

  @override
  String toString() => r'unitMemberModerationProvider';
}

/// Deciding on the people of one object, and the loading / error state of it.
///
/// Keyed by the object so a refusal on one screen cannot light up another, and
/// so the list to re-read afterwards is known without being passed in.
///
/// The rules are not repeated here — the database owns them and answers DV004
/// and DV005, which the failure mapper turns into a sentence. This only asks.

abstract class _$UnitMemberModeration extends $AsyncNotifier<void> {
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
