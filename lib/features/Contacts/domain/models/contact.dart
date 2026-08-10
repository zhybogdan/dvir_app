import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact.freezed.dart';
part 'contact.g.dart';

/// One telephone number the scope keeps — "Serhii, the electrician", the gas
/// service's emergency line.
///
/// The scope id is missing for the reason it is missing from `Document`: a list
/// is always read for one scope, so the scope is what the caller already holds.
///
/// `email` and `category` exist as columns and are deliberately not here. A
/// household's list is telephone numbers — the value is tapping one and having
/// it ring — and a field nothing reads is dead weight in a model.
///
/// [role] and [phone] are nullable because the columns are: `0001` wrote them
/// for a community's directory, where a published address may be all there is.
/// The form asks for a number, but a row without one still has to be readable.
@freezed
abstract class Contact with _$Contact {
  const factory Contact({
    required String id,
    required String name,
    String? role,
    String? phone,
  }) = _Contact;

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
}
