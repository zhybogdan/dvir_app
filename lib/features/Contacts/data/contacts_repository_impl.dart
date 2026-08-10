import 'package:dvir/core/config/supabase_providers.dart';
import 'package:dvir/core/error/supabase_error_guard.dart';
import 'package:dvir/features/Contacts/data/contacts_repository.dart';
import 'package:dvir/features/Contacts/domain/models/contact.dart';
import 'package:dvir/features/Shared/domain/types/scope_ref.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

part 'contacts_repository_impl.g.dart';

/// `email` and `category` are not asked for: nothing shows them (see [Contact]),
/// and a column read into a model nobody uses is a column somebody later
/// believes is maintained.
const String _columns = 'id,name,role,phone';

class ContactsRepositoryImpl implements ContactsRepository {
  ContactsRepositoryImpl(this._client);

  final sb.SupabaseClient _client;

  @override
  Future<List<Contact>> contactsOf(ScopeRef scope) => guardSupabase(() async {
    final rows = await _client
        .from('contacts')
        .select(_columns)
        .eq(scope.column, scope.id)
        // Spelled out: PostgREST sorts descending unless told otherwise, and an
        // alphabetical list running Z→A reads as a bug rather than a choice.
        .order('name', ascending: true);

    return rows.map(Contact.fromJson).toList();
  });

  @override
  Future<void> addContact({
    required ScopeRef scope,
    required String name,
    String? role,
    String? phone,
  }) => guardSupabase(
    () => _client.from('contacts').insert({
      scope.column: scope.id,
      'name': name,
      'role': role,
      'phone': phone,
    }),
  );

  @override
  Future<void> updateContact(Contact contact) => guardSupabase(
    () => _client
        .from('contacts')
        .update({
          'name': contact.name,
          'role': contact.role,
          'phone': contact.phone,
        })
        .eq('id', contact.id),
  );

  @override
  Future<void> deleteContact(String id) =>
      guardSupabase(() => _client.from('contacts').delete().eq('id', id));
}

@Riverpod(keepAlive: true)
ContactsRepository contactsRepository(Ref ref) =>
    ContactsRepositoryImpl(ref.watch(supabaseClientProvider));
