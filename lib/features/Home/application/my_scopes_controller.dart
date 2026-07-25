import 'package:dvir/features/Auth/application/auth_controller.dart';
import 'package:dvir/features/Home/data/scopes_repository_impl.dart';
import 'package:dvir/features/Home/domain/models/scope_summary.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_scopes_controller.g.dart';

/// The scope list together with whose it is.
///
/// The owner's id travels with the data because the router has to tell two
/// loading states apart. Riverpod hands back the previous value while a new one
/// is fetched, so "my list is refreshing" and "this list belongs to whoever was
/// signed in before" look identical from the outside — and treating both as
/// unknown would throw the user back to the splash on every refresh.
typedef MyScopes = ({String userId, List<ScopeSummary> scopes});

/// Every scope the current user belongs to, approved or not.
///
/// Rebuilt on every auth change on purpose: a membership belongs to whoever is
/// signed in, and signing out must not leave the previous user's scopes on
/// screen for the next one.
@Riverpod(keepAlive: true)
Future<MyScopes?> myScopes(Ref ref) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return null;

  final scopes = await ref.watch(scopesRepositoryProvider).myScopes();

  return (userId: user.id, scopes: scopes);
}
