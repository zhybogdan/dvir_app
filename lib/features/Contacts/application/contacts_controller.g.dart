// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacts_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The telephone numbers one scope keeps, alphabetically.
///
/// Kept alive like the other lists of the hub: a section scrolled out of view
/// loses its last listener, and an auto-disposing provider would re-read the
/// list every time it came back. Adding, editing and deleting all invalidate
/// it, as does the hub's pull-to-refresh.

@ProviderFor(contacts)
final contactsProvider = ContactsFamily._();

/// The telephone numbers one scope keeps, alphabetically.
///
/// Kept alive like the other lists of the hub: a section scrolled out of view
/// loses its last listener, and an auto-disposing provider would re-read the
/// list every time it came back. Adding, editing and deleting all invalidate
/// it, as does the hub's pull-to-refresh.

final class ContactsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Contact>>,
          List<Contact>,
          FutureOr<List<Contact>>
        >
    with $FutureModifier<List<Contact>>, $FutureProvider<List<Contact>> {
  /// The telephone numbers one scope keeps, alphabetically.
  ///
  /// Kept alive like the other lists of the hub: a section scrolled out of view
  /// loses its last listener, and an auto-disposing provider would re-read the
  /// list every time it came back. Adding, editing and deleting all invalidate
  /// it, as does the hub's pull-to-refresh.
  ContactsProvider._({
    required ContactsFamily super.from,
    required ScopeRef super.argument,
  }) : super(
         retry: null,
         name: r'contactsProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$contactsHash();

  @override
  String toString() {
    return r'contactsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Contact>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Contact>> create(Ref ref) {
    final argument = this.argument as ScopeRef;
    return contacts(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ContactsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$contactsHash() => r'b89bf4dcefe1e226dff9f31adfd1cba01814f6d9';

/// The telephone numbers one scope keeps, alphabetically.
///
/// Kept alive like the other lists of the hub: a section scrolled out of view
/// loses its last listener, and an auto-disposing provider would re-read the
/// list every time it came back. Adding, editing and deleting all invalidate
/// it, as does the hub's pull-to-refresh.

final class ContactsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Contact>>, ScopeRef> {
  ContactsFamily._()
    : super(
        retry: null,
        name: r'contactsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// The telephone numbers one scope keeps, alphabetically.
  ///
  /// Kept alive like the other lists of the hub: a section scrolled out of view
  /// loses its last listener, and an auto-disposing provider would re-read the
  /// list every time it came back. Adding, editing and deleting all invalidate
  /// it, as does the hub's pull-to-refresh.

  ContactsProvider call(ScopeRef scope) =>
      ContactsProvider._(argument: scope, from: this);

  @override
  String toString() => r'contactsProvider';
}

/// Adding, editing and dropping the contacts of one scope.
///
/// Keyed by the scope so a refusal on one screen cannot light up another, and
/// so the list to re-read afterwards is known without being passed in.
///
/// **A screen driving this must also listen to it** — nothing watches it for a
/// value, so without a listener it is disposed the moment it is read, and its
/// failures reach nobody.

@ProviderFor(ContactActions)
final contactActionsProvider = ContactActionsFamily._();

/// Adding, editing and dropping the contacts of one scope.
///
/// Keyed by the scope so a refusal on one screen cannot light up another, and
/// so the list to re-read afterwards is known without being passed in.
///
/// **A screen driving this must also listen to it** — nothing watches it for a
/// value, so without a listener it is disposed the moment it is read, and its
/// failures reach nobody.
final class ContactActionsProvider
    extends $AsyncNotifierProvider<ContactActions, void> {
  /// Adding, editing and dropping the contacts of one scope.
  ///
  /// Keyed by the scope so a refusal on one screen cannot light up another, and
  /// so the list to re-read afterwards is known without being passed in.
  ///
  /// **A screen driving this must also listen to it** — nothing watches it for a
  /// value, so without a listener it is disposed the moment it is read, and its
  /// failures reach nobody.
  ContactActionsProvider._({
    required ContactActionsFamily super.from,
    required ScopeRef super.argument,
  }) : super(
         retry: null,
         name: r'contactActionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$contactActionsHash();

  @override
  String toString() {
    return r'contactActionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ContactActions create() => ContactActions();

  @override
  bool operator ==(Object other) {
    return other is ContactActionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$contactActionsHash() => r'b456f8cae36574fa47d6306978c1b631f3dc28e4';

/// Adding, editing and dropping the contacts of one scope.
///
/// Keyed by the scope so a refusal on one screen cannot light up another, and
/// so the list to re-read afterwards is known without being passed in.
///
/// **A screen driving this must also listen to it** — nothing watches it for a
/// value, so without a listener it is disposed the moment it is read, and its
/// failures reach nobody.

final class ContactActionsFamily extends $Family
    with
        $ClassFamilyOverride<
          ContactActions,
          AsyncValue<void>,
          void,
          FutureOr<void>,
          ScopeRef
        > {
  ContactActionsFamily._()
    : super(
        retry: null,
        name: r'contactActionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Adding, editing and dropping the contacts of one scope.
  ///
  /// Keyed by the scope so a refusal on one screen cannot light up another, and
  /// so the list to re-read afterwards is known without being passed in.
  ///
  /// **A screen driving this must also listen to it** — nothing watches it for a
  /// value, so without a listener it is disposed the moment it is read, and its
  /// failures reach nobody.

  ContactActionsProvider call(ScopeRef scope) =>
      ContactActionsProvider._(argument: scope, from: this);

  @override
  String toString() => r'contactActionsProvider';
}

/// Adding, editing and dropping the contacts of one scope.
///
/// Keyed by the scope so a refusal on one screen cannot light up another, and
/// so the list to re-read afterwards is known without being passed in.
///
/// **A screen driving this must also listen to it** — nothing watches it for a
/// value, so without a listener it is disposed the moment it is read, and its
/// failures reach nobody.

abstract class _$ContactActions extends $AsyncNotifier<void> {
  late final _$args = ref.$arg as ScopeRef;
  ScopeRef get scope => _$args;

  FutureOr<void> build(ScopeRef scope);
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
