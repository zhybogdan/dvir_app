import 'package:dvir/core/logging/app_logger.dart';
import 'package:url_launcher/url_launcher.dart';

/// A number as `tel:` will accept it — digits, and a leading `+` if it had one.
///
/// People write numbers to be read: `+38 (067) 123-45-67`. Some diallers cope
/// with the spaces and brackets, some open empty, and the ones that fail do it
/// silently. Stripping is the only way to know which number was dialled.
///
/// The `+` survives only in front, where it means "international", and is
/// dropped anywhere else — inside a number it is a typo, not a prefix.
/// An empty result means there was nothing to dial.
String dialableNumber(String phone) {
  final trimmed = phone.trim();
  final digits = trimmed.replaceAll(RegExp('[^0-9]'), '');

  // Three, because 101, 102, 103 and 112 are numbers a household writes down.
  // Below that the digits came from prose — "дзвонити після 18" would otherwise
  // dial 18, and the tap would look like it worked.
  if (digits.length < 3) return '';

  return trimmed.startsWith('+') ? '+$digits' : digits;
}

/// Opens the dialler with [phone], already typed in — false when there was no
/// number to dial or no app to dial it with.
///
/// The dialler is opened rather than the call placed: placing it needs the CALL
/// permission and takes the decision away from the person, who may want to see
/// the number first.
///
/// A single wrapper over url_launcher, beside `shareText` in this folder, so
/// call sites never touch the package and the `tel:` shape lives in one place.
Future<bool> dialPhone(String phone) async {
  final number = dialableNumber(phone);
  if (number.isEmpty) return false;

  try {
    // `Uri(scheme:, path:)` rather than `Uri.parse('tel:$number')`: parse would
    // read a leading `+` as part of an authority and quietly lose it.
    return await launchUrl(Uri(scheme: 'tel', path: number));
  } catch (error) {
    // A device with no dialler at all — a tablet, an emulator without the
    // phone app. Not worth a typed failure: the only answer is "not from here".
    appLogger.d('Could not open the dialler: $error');

    return false;
  }
}
