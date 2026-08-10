import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_version.g.dart';

/// The version this build was compiled as, with its build number.
///
/// Both, because they answer different questions: the version is what a person
/// recognises from the store listing, and the build number is what tells two
/// uploads of the same version apart when somebody reports a bug against one.
@Riverpod(keepAlive: true)
Future<String> appVersion(Ref ref) async {
  final info = await PackageInfo.fromPlatform();

  return '${info.version} (${info.buildNumber})';
}
