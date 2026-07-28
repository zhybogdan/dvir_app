import 'package:dvir/features/Units/data/units_repository_impl.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'unit_controller.g.dart';

/// One object, by id.
///
/// Fetched rather than picked out of the scope list: an object nested inside
/// another — a flat inside a house — is visible to its owner without being one
/// of *their* scopes, so it never appears in that list.
@riverpod
Future<Unit> unit(Ref ref, String unitId) =>
    ref.watch(unitsRepositoryProvider).unitById(unitId);

/// The object's invite code, which the database hands to owners only.
///
/// A separate provider rather than a field on [Unit] because it is a separate
/// call — `0005` took the column out of an ordinary read. Watch it only once
/// the caller is known to be an owner; anyone else gets a refusal, not a null.
@riverpod
Future<String> unitInviteCode(Ref ref, String unitId) =>
    ref.watch(unitsRepositoryProvider).inviteCode(unitId);
