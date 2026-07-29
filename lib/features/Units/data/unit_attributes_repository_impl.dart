import 'package:dvir/core/config/supabase_providers.dart';
import 'package:dvir/core/error/supabase_error_guard.dart';
import 'package:dvir/features/Units/data/unit_attributes_repository.dart';
import 'package:dvir/features/Units/domain/models/unit_attribute.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

part 'unit_attributes_repository_impl.g.dart';

/// `position` is missing on purpose: it is what the rows are sorted by, not
/// something the app reads — and `unit_id` is what the caller asked with.
const String _columns = 'id,name,value';

class UnitAttributesRepositoryImpl implements UnitAttributesRepository {
  UnitAttributesRepositoryImpl(this._client);

  final sb.SupabaseClient _client;

  @override
  Future<List<UnitAttribute>> attributesOf(String unitId) =>
      guardSupabase(() async {
        // `created_at` is the tie-breaker rather than decoration: positions are
        // not unique on purpose (0008), so without it two facts added at the
        // same moment could swap places between reads.
        final rows = await _client
            .from('unit_attributes')
            .select(_columns)
            .eq('unit_id', unitId)
            .order('position', ascending: true)
            .order('created_at', ascending: true);

        return rows.map(UnitAttribute.fromJson).toList();
      });

  @override
  Future<void> addAttribute({
    required String unitId,
    required String name,
    required String value,
  }) => guardSupabase(
    () => _client.from('unit_attributes').insert({
      'unit_id': unitId,
      'name': name,
      'value': value,
    }),
  );

  @override
  Future<void> updateAttribute(UnitAttribute attribute) => guardSupabase(
    () => _client
        .from('unit_attributes')
        .update({'name': attribute.name, 'value': attribute.value})
        .eq('id', attribute.id),
  );

  @override
  Future<void> deleteAttribute(String id) => guardSupabase(
    () => _client.from('unit_attributes').delete().eq('id', id),
  );

  @override
  Future<void> reorder({required String unitId, required List<String> ids}) =>
      guardSupabase(
        () => _client.rpc<void>(
          'reorder_unit_attributes',
          params: {'p_unit_id': unitId, 'p_ids': ids},
        ),
      );
}

@Riverpod(keepAlive: true)
UnitAttributesRepository unitAttributesRepository(Ref ref) =>
    UnitAttributesRepositoryImpl(ref.watch(supabaseClientProvider));
