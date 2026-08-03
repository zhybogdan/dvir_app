import 'package:dvir/core/error/failures.dart';

/// Storage's HTTP status → domain reasons.
///
/// Unlike the scope RPCs, Storage has no custom codes to raise: it answers with
/// a status and an English sentence. The status is what is matched on, because
/// it is the part that does not change when a message is reworded.
///
/// `400` is the exception, and the reason this takes the message at all: the
/// bucket's size limit and its mime whitelist both come back as a plain bad
/// request, and the sentence is the only thing telling them apart. It is
/// matched loosely and falls back to [StorageFailureReason.unknown], so a
/// rewording upstream costs a vaguer message and nothing more.
StorageFailureReason storageFailureReasonFrom(
  String? statusCode,
  String message,
) => switch (statusCode) {
  '413' => StorageFailureReason.tooLarge,
  '415' => StorageFailureReason.typeNotAllowed,
  '404' => StorageFailureReason.missing,
  '401' || '403' => StorageFailureReason.notAllowed,
  '400' => _fromMessage(message),
  _ => StorageFailureReason.unknown,
};

StorageFailureReason _fromMessage(String message) {
  final text = message.toLowerCase();

  if (text.contains('maximum allowed size') || text.contains('too large')) {
    return StorageFailureReason.tooLarge;
  }
  if (text.contains('mime type')) return StorageFailureReason.typeNotAllowed;

  return StorageFailureReason.unknown;
}
