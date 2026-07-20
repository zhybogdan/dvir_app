import 'package:dvir/features/Auth/application/auth_controller.dart';
import 'package:dvir/features/Onboarding/data/onboarding_repository_impl.dart';
import 'package:dvir/features/Onboarding/domain/models/scope_membership.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'membership_controller.g.dart';

/// Where the current user belongs (null while they belong nowhere).
///
/// The router watches this to choose between onboarding, the waiting screen and
/// the app itself.
///
/// Rebuilt on every auth change on purpose: a membership belongs to whoever is
/// signed in, and signing out must not leave the previous user's scope on
/// screen for the next one.
@Riverpod(keepAlive: true)
Stream<ScopeMembership?> myMembership(Ref ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value(null);

  return ref.watch(onboardingRepositoryProvider).watchMyMembership();
}
