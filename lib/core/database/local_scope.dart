import 'package:dvir/features/Shared/domain/types/scope_ref.dart';

/// The object a row hangs off, in a build where objects are all there is.
///
/// Every table serving both scopes carries `community_id` and `unit_id` with
/// exactly one set, and locally it is always the second. Refusing the other
/// rather than returning nothing keeps a screen that cannot exist in this
/// flavour from rendering as merely empty.
extension LocalScope on ScopeRef {
  String get unitId => switch (this) {
    UnitScope(:final id) => id,
    CommunityScope() => throw UnsupportedError(
      'This build has no communities.',
    ),
  };
}
