// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Where the current user belongs (null while they belong nowhere).
///
/// The router watches this to choose between onboarding, the waiting screen and
/// the app itself.
///
/// Rebuilt on every auth change on purpose: a membership belongs to whoever is
/// signed in, and signing out must not leave the previous user's scope on
/// screen for the next one.

@ProviderFor(myMembership)
final myMembershipProvider = MyMembershipProvider._();

/// Where the current user belongs (null while they belong nowhere).
///
/// The router watches this to choose between onboarding, the waiting screen and
/// the app itself.
///
/// Rebuilt on every auth change on purpose: a membership belongs to whoever is
/// signed in, and signing out must not leave the previous user's scope on
/// screen for the next one.

final class MyMembershipProvider
    extends
        $FunctionalProvider<
          AsyncValue<ScopeMembership?>,
          ScopeMembership?,
          Stream<ScopeMembership?>
        >
    with $FutureModifier<ScopeMembership?>, $StreamProvider<ScopeMembership?> {
  /// Where the current user belongs (null while they belong nowhere).
  ///
  /// The router watches this to choose between onboarding, the waiting screen and
  /// the app itself.
  ///
  /// Rebuilt on every auth change on purpose: a membership belongs to whoever is
  /// signed in, and signing out must not leave the previous user's scope on
  /// screen for the next one.
  MyMembershipProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myMembershipProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myMembershipHash();

  @$internal
  @override
  $StreamProviderElement<ScopeMembership?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<ScopeMembership?> create(Ref ref) {
    return myMembership(ref);
  }
}

String _$myMembershipHash() => r'33c6130d4c62ea7e6be43975a134d0bf05c49c4f';
