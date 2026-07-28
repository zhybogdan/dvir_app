import 'package:dvir/features/Shared/domain/models/profile.dart';

/// Contract for the signed-in user's own profile (Base).
///
/// Only their own: other people's profiles arrive embedded in the member lists,
/// where RLS decides who is allowed to see whom.
abstract interface class ProfileRepository {
  Future<Profile> myProfile();

  /// Writes the fields a person fills in about themselves. Null clears one,
  /// which is what an emptied input means.
  Future<Profile> save({String? fullName, String? phone});
}
