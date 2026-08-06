import 'dart:async';

import 'package:dvir/core/riverpod/guarded_actions.dart';
import 'package:dvir/features/Contacts/data/contacts_repository.dart';
import 'package:dvir/features/Contacts/data/contacts_repository_impl.dart';
import 'package:dvir/features/Contacts/domain/models/contact.dart';
import 'package:dvir/features/Shared/domain/types/scope_ref.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contacts_controller.g.dart';

/// The telephone numbers one scope keeps, alphabetically.
///
/// Kept alive like the other lists of the hub: a section scrolled out of view
/// loses its last listener, and an auto-disposing provider would re-read the
/// list every time it came back. Adding, editing and deleting all invalidate
/// it, as does the hub's pull-to-refresh.
@Riverpod(keepAlive: true)
Future<List<Contact>> contacts(Ref ref, ScopeRef scope) =>
    ref.watch(contactsRepositoryProvider).contactsOf(scope);

/// Adding, editing and dropping the contacts of one scope.
///
/// Keyed by the scope so a refusal on one screen cannot light up another, and
/// so the list to re-read afterwards is known without being passed in.
///
/// **A screen driving this must also listen to it** — nothing watches it for a
/// value, so without a listener it is disposed the moment it is read, and its
/// failures reach nobody.
@riverpod
class ContactActions extends _$ContactActions with GuardedActions {
  @override
  FutureOr<void> build(ScopeRef scope) {}

  Future<bool> add({required String name, String? role, String? phone}) => _run(
    (repository) => repository.addContact(
      scope: scope,
      name: name,
      role: role,
      phone: phone,
    ),
  );

  Future<bool> edit(Contact contact) =>
      _run((repository) => repository.updateContact(contact));

  Future<bool> remove(String id) =>
      _run((repository) => repository.deleteContact(id));

  /// Every action here changes the same list, so what to re-read afterwards is
  /// the same too.
  Future<bool> _run(Future<void> Function(ContactsRepository) call) {
    final repository = ref.read(contactsRepositoryProvider);

    return guardedVoid(
      () => call(repository),
      onSuccess: () => ref.invalidate(contactsProvider(scope)),
    );
  }
}
