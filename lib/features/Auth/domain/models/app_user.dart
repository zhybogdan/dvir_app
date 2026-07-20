import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';

/// The authenticated user, stripped down to what the app needs.
/// Keeps Supabase's `User` type out of the domain and UI.
@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({required String id, required String email}) = _AppUser;
}
