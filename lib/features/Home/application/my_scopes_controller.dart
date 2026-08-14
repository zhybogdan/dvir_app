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

/// Re-reads the list and **waits for it**, so the router never decides on the
/// answer from before whatever just changed.
///
/// Invalidating alone hands control straight back while the fetch is still in
/// flight, and `resolveRedirect` then reads the value underneath — which is the
/// list as it was. Both directions hurt: someone who has just created their
/// first object is ruled to belong nowhere and sent back to onboarding, and
/// someone who has just deleted their last one lands on a home screen still
/// showing a card for it.
///
/// Belongs to an action that changes where a person belongs, passed as
/// `GuardedActions`' `onSuccess` — which awaits it, and is exactly what the
/// caller must not outrun. `ref.mounted` is checked because this awaits: the
/// notifier that started it may be gone by the time the list lands.
Future<void> refreshMyScopes(Ref ref) async {
  if (!ref.mounted) return;

  // Invalidate then read, rather than `refresh`: the first marks the list
  // stale, the second is what waits for the replacement to land.
  ref.invalidate(myScopesProvider);
  await ref.read(myScopesProvider.future);
}
