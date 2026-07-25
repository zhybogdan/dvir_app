import 'package:dvir/features/Onboarding/domain/models/created_scope.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'created_scope_controller.g.dart';

/// Carries a freshly created scope to the success screen.
///
/// Deliberately not `GoRouterState.extra`: go_router serialises extra into the
/// navigation state, and every router refresh — membership reloading, for one —
/// hands it back JSON-decoded as a plain `Map`. The typed model is gone by then,
/// so the screen's `is Unit` check fails and the invite code is lost.
@Riverpod(keepAlive: true)
class CreatedScopeController extends _$CreatedScopeController {
  @override
  CreatedScope? build() => null;

  void remember(CreatedScope scope) => state = scope;
}
