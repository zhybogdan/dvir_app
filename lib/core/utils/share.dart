import 'package:share_plus/share_plus.dart';

/// Opens the platform share sheet with plain [text].
///
/// Single wrapper over share_plus so call sites never touch the package API
/// directly and it can be swapped or extended (subject, files) in one place.
Future<void> shareText(String text) =>
    SharePlus.instance.share(ShareParams(text: text));
