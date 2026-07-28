import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

/// The person behind a membership row — who a name, a phone and a face come
/// from wherever the app shows a user rather than a user id.
///
/// Everything but [id] is nullable, and that is the normal case rather than an
/// edge one: the signup trigger inserts a profile carrying only the id, so a
/// brand-new user has no name until they enter one. Screens fall back rather
/// than assume.
@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    required String id,
    @JsonKey(name: 'full_name') String? fullName,
    String? phone,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
