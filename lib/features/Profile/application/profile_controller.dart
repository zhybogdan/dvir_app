import 'dart:async';

import 'package:dvir/features/Members/application/unit_members_controller.dart';
import 'package:dvir/features/Profile/data/profile_repository_impl.dart';
import 'package:dvir/features/Shared/domain/models/profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_controller.g.dart';

/// The signed-in user's own profile.
@riverpod
Future<Profile> myProfile(Ref ref) =>
    ref.watch(profileRepositoryProvider).myProfile();

/// Saving it, and the loading / error state of that.
@riverpod
class ProfileController extends _$ProfileController {
  @override
  FutureOr<void> build() {}

  Future<Profile?> save({String? fullName, String? phone}) async {
    final repository = ref.read(profileRepositoryProvider);

    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => repository.save(fullName: fullName, phone: phone),
    );

    // Checked before the assignment: writing `state` after the screen watching
    // this has gone throws rather than being ignored.
    if (!ref.mounted) return null;
    state = result;

    if (result.hasError) return null;

    ref
      ..invalidate(myProfileProvider)
      // Every residents list carries a copy of this profile, fetched with the
      // membership row. Invalidating the whole family is what makes the new
      // name appear where it matters — the lists it is read from.
      ..invalidate(unitMembersProvider);

    return result.value;
  }
}
