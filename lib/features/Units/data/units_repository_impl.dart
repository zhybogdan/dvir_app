import 'package:dvir/core/config/supabase_providers.dart';
import 'package:dvir/core/error/failures.dart';
import 'package:dvir/core/error/supabase_error_guard.dart';
import 'package:dvir/features/Units/data/units_repository.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/features/Units/domain/types/unit_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

part 'units_repository_impl.g.dart';

class UnitsRepositoryImpl implements UnitsRepository {
  UnitsRepositoryImpl(this._client);

  final sb.SupabaseClient _client;

  @override
  Future<List<Unit>> myUnits() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return const [];

    return guardSupabase(() async {
      // Filtering by `user_id` is not the hand-written tenant filter the
      // project bans: RLS lets a resident see their co-residents' rows too, so
      // without it this would collect other people's objects as well.
      final rows = await _client
          .from('unit_members')
          .select('units(*)')
          .eq('user_id', userId)
          .eq('status', 'active')
          .order('created_at', ascending: true);

      return rows
          .map((row) => Unit.fromJson(row['units'] as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<List<Unit>> topLevelUnitsOf(String communityId) =>
      guardSupabase(() async {
        // `community_id` here picks *which* community to show, it does not
        // enforce isolation — RLS already limits the rows to communities the
        // caller belongs to. A person can belong to several.
        final rows = await _client
            .from('units')
            .select()
            .eq('community_id', communityId)
            .isFilter('parent_id', null)
            .order('label', ascending: true);

        return rows.map(Unit.fromJson).toList();
      });

  @override
  Future<List<Unit>> childrenOf(String parentId) => guardSupabase(() async {
    final rows = await _client
        .from('units')
        .select()
        .eq('parent_id', parentId)
        .order('label', ascending: true);

    return rows.map(Unit.fromJson).toList();
  });

  @override
  Future<Unit> unitById(String id) => guardSupabase(() async {
    final row = await _client.from('units').select().eq('id', id).maybeSingle();

    // An object hidden by RLS comes back as no row at all, which is the same
    // answer the app should give either way: it is not there for this user.
    if (row == null) throw const NotFoundFailure();

    return Unit.fromJson(row);
  });

  @override
  Future<Unit> createUnit({
    required String label,
    required UnitType type,
    String? parentId,
    String? communityId,
    String? address,
    String? city,
    double? areaM2,
  }) => guardSupabase(() async {
    final row = await _client.rpc<Map<String, dynamic>>(
      'create_unit',
      params: {
        'p_label': label,
        'p_type': type.dbValue,
        'p_parent_id': parentId,
        'p_community_id': communityId,
        'p_address': address,
        'p_city': city,
        'p_area_m2': areaM2,
      },
    );

    return Unit.fromJson(row);
  });

  @override
  Future<Unit> updateUnit(Unit unit) => guardSupabase(() async {
    // The map is written out column by column rather than from `toJson()`: it
    // is the list of what an owner may edit, and `units_guard_structure`
    // rejects the update outright if anything else slips in.
    final row = await _client
        .from('units')
        .update({
          'label': unit.label,
          'type': unit.type.dbValue,
          'address': unit.address,
          'city': unit.city,
          'area_m2': unit.areaM2,
        })
        .eq('id', unit.id)
        .select()
        .single();

    return Unit.fromJson(row);
  });

  @override
  Future<void> deleteUnit(String id) =>
      guardSupabase(() => _client.from('units').delete().eq('id', id));

  @override
  Future<String> rotateInviteCode(String unitId) => guardSupabase(
    () => _client.rpc<String>(
      'rotate_unit_invite_code',
      params: {'p_unit_id': unitId},
    ),
  );
}

@Riverpod(keepAlive: true)
UnitsRepository unitsRepository(Ref ref) =>
    UnitsRepositoryImpl(ref.watch(supabaseClientProvider));
