import 'package:dvir/features/Home/domain/models/scope_summary.dart';

/// Contract for the list the app opens on (Base).
abstract interface class ScopesRepository {
  /// Every scope the signed-in user has a row in, whatever its status —
  /// communities first, then objects.
  ///
  /// Rows still waiting for approval are included on purpose: a person who
  /// asked to join somewhere should see that the request exists, and the router
  /// needs it to tell "belongs nowhere" from "belongs somewhere, not let in
  /// yet".
  Future<List<ScopeSummary>> myScopes();
}
