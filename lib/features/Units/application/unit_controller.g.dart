// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// One object, by id.
///
/// Fetched rather than picked out of the scope list: an object nested inside
/// another — a flat inside a house — is visible to its owner without being one
/// of *their* scopes, so it never appears in that list.

@ProviderFor(unit)
final unitProvider = UnitFamily._();

/// One object, by id.
///
/// Fetched rather than picked out of the scope list: an object nested inside
/// another — a flat inside a house — is visible to its owner without being one
/// of *their* scopes, so it never appears in that list.

final class UnitProvider
    extends $FunctionalProvider<AsyncValue<Unit>, Unit, FutureOr<Unit>>
    with $FutureModifier<Unit>, $FutureProvider<Unit> {
  /// One object, by id.
  ///
  /// Fetched rather than picked out of the scope list: an object nested inside
  /// another — a flat inside a house — is visible to its owner without being one
  /// of *their* scopes, so it never appears in that list.
  UnitProvider._({
    required UnitFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'unitProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$unitHash();

  @override
  String toString() {
    return r'unitProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Unit> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Unit> create(Ref ref) {
    final argument = this.argument as String;
    return unit(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UnitProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$unitHash() => r'4c9b8efa1af8cf5a463a5015c5e685310959b4bc';

/// One object, by id.
///
/// Fetched rather than picked out of the scope list: an object nested inside
/// another — a flat inside a house — is visible to its owner without being one
/// of *their* scopes, so it never appears in that list.

final class UnitFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Unit>, String> {
  UnitFamily._()
    : super(
        retry: null,
        name: r'unitProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One object, by id.
  ///
  /// Fetched rather than picked out of the scope list: an object nested inside
  /// another — a flat inside a house — is visible to its owner without being one
  /// of *their* scopes, so it never appears in that list.

  UnitProvider call(String unitId) =>
      UnitProvider._(argument: unitId, from: this);

  @override
  String toString() => r'unitProvider';
}

/// The object's invite code, which the database hands to owners only.
///
/// A separate provider rather than a field on [Unit] because it is a separate
/// call — `0005` took the column out of an ordinary read. Watch it only once
/// the caller is known to be an owner; anyone else gets a refusal, not a null.

@ProviderFor(unitInviteCode)
final unitInviteCodeProvider = UnitInviteCodeFamily._();

/// The object's invite code, which the database hands to owners only.
///
/// A separate provider rather than a field on [Unit] because it is a separate
/// call — `0005` took the column out of an ordinary read. Watch it only once
/// the caller is known to be an owner; anyone else gets a refusal, not a null.

final class UnitInviteCodeProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// The object's invite code, which the database hands to owners only.
  ///
  /// A separate provider rather than a field on [Unit] because it is a separate
  /// call — `0005` took the column out of an ordinary read. Watch it only once
  /// the caller is known to be an owner; anyone else gets a refusal, not a null.
  UnitInviteCodeProvider._({
    required UnitInviteCodeFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'unitInviteCodeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$unitInviteCodeHash();

  @override
  String toString() {
    return r'unitInviteCodeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    final argument = this.argument as String;
    return unitInviteCode(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UnitInviteCodeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$unitInviteCodeHash() => r'2ba370baea93f57b099ffa8a0cc7229e8263a588';

/// The object's invite code, which the database hands to owners only.
///
/// A separate provider rather than a field on [Unit] because it is a separate
/// call — `0005` took the column out of an ordinary read. Watch it only once
/// the caller is known to be an owner; anyone else gets a refusal, not a null.

final class UnitInviteCodeFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String>, String> {
  UnitInviteCodeFamily._()
    : super(
        retry: null,
        name: r'unitInviteCodeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The object's invite code, which the database hands to owners only.
  ///
  /// A separate provider rather than a field on [Unit] because it is a separate
  /// call — `0005` took the column out of an ordinary read. Watch it only once
  /// the caller is known to be an owner; anyone else gets a refusal, not a null.

  UnitInviteCodeProvider call(String unitId) =>
      UnitInviteCodeProvider._(argument: unitId, from: this);

  @override
  String toString() => r'unitInviteCodeProvider';
}
