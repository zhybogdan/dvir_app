import 'package:share_plus/share_plus.dart';

/// Opens the platform share sheet with plain [text].
///
/// Single wrapper over share_plus so call sites never touch the package API
/// directly and it can be swapped or extended (subject, files) in one place.
Future<void> shareText(String text) =>
    SharePlus.instance.share(ShareParams(text: text));

/// Hands the file at [path] to whatever the person shares with.
///
/// True unless the sheet was closed without choosing anything. Where the
/// platform cannot tell, that is true as well: a copy that might have been
/// saved is not one to nag about.
///
/// The only way out of the app for a backup, and deliberately the only one:
/// writing it to a folder of the person's choosing would mean asking Android
/// for storage permission, while the share sheet already lets them put it in
/// Drive, in a chat, or on the device itself — and asks for nothing.
Future<bool> shareFile(String path) async {
  final result = await SharePlus.instance.share(
    ShareParams(files: [XFile(path)]),
  );

  return result.status != ShareResultStatus.dismissed;
}
