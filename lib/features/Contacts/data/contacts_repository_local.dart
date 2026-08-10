import 'package:drift/drift.dart';
import 'package:dvir/core/database/app_database.dart';
import 'package:dvir/core/database/local_scope.dart';
import 'package:dvir/features/Contacts/data/contacts_repository.dart';
import 'package:dvir/features/Contacts/domain/models/contact.dart';
import 'package:dvir/features/Shared/domain/types/scope_ref.dart';
import 'package:uuid/uuid.dart';

/// The telephone numbers an object keeps, on the device (Impl).
class LocalContactsRepository implements ContactsRepository {
  LocalContactsRepository(this._database);

  final AppDatabase _database;

  /// Sorted in Dart rather than by the database, which is the one place this
  /// cannot simply copy the cloud query.
  ///
  /// SQLite compares text byte by byte, and in UTF-8 every capital Cyrillic
  /// letter sorts before every lowercase one. A list holding "Сергій" and
  /// "мама" would put every lowercase name after every capitalised one — which
  /// is not alphabetical to anyone reading it, and not what Postgres answers
  /// with a linguistic collation. Comparing the lowercased names gives the
  /// order a person expects, and the lists here are short enough that where the
  /// sorting happens costs nothing.
  @override
  Future<List<Contact>> contactsOf(ScopeRef scope) async {
    final rows = await (_database.select(
      _database.contacts,
    )..where((row) => row.unitId.equals(scope.unitId))).get();

    final contacts = rows.map(_toContact).toList()
      ..sort(
        (one, other) =>
            one.name.toLowerCase().compareTo(other.name.toLowerCase()),
      );

    return contacts;
  }

  @override
  Future<void> addContact({
    required ScopeRef scope,
    required String name,
    String? role,
    String? phone,
  }) => _database
      .into(_database.contacts)
      .insert(
        ContactsCompanion.insert(
          id: const Uuid().v4(),
          unitId: scope.unitId,
          name: name,
          role: Value(role),
          phone: Value(phone),
        ),
      );

  /// The scope is not among the columns written: nothing in the app moves a
  /// contact from one object to another.
  @override
  Future<void> updateContact(Contact contact) =>
      (_database.update(
        _database.contacts,
      )..where((row) => row.id.equals(contact.id))).write(
        ContactsCompanion(
          name: Value(contact.name),
          role: Value(contact.role),
          phone: Value(contact.phone),
        ),
      );

  @override
  Future<void> deleteContact(String id) => (_database.delete(
    _database.contacts,
  )..where((row) => row.id.equals(id))).go();

  Contact _toContact(ContactRow row) =>
      Contact(id: row.id, name: row.name, role: row.role, phone: row.phone);
}
