import 'package:dvir/features/Contacts/domain/models/contact.dart';
import 'package:dvir/features/Shared/domain/types/scope_ref.dart';

/// Contract for the telephone numbers kept against a scope (Base).
///
/// A feature of its own, and written against [ScopeRef] rather than an object:
/// an OSBB publishes a directory from the same table, so the day that half gets
/// screens it finds this already written for it.
abstract interface class ContactsRepository {
  /// One scope's contacts, in alphabetical order.
  ///
  /// By name rather than by time, unlike documents: a person opening this is
  /// looking for the plumber, not for whoever was written down last.
  Future<List<Contact>> contactsOf(ScopeRef scope);

  Future<void> addContact({
    required ScopeRef scope,
    required String name,
    String? role,
    String? phone,
  });

  /// Saves an edited contact. The id decides which row; the scope cannot be
  /// changed this way, because nothing in the app moves a contact between a
  /// house and a community.
  Future<void> updateContact(Contact contact);

  Future<void> deleteContact(String id);
}
