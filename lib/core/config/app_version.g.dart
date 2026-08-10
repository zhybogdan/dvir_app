// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_version.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The version this build was compiled as, with its build number.
///
/// Both, because they answer different questions: the version is what a person
/// recognises from the store listing, and the build number is what tells two
/// uploads of the same version apart when somebody reports a bug against one.

@ProviderFor(appVersion)
final appVersionProvider = AppVersionProvider._();

/// The version this build was compiled as, with its build number.
///
/// Both, because they answer different questions: the version is what a person
/// recognises from the store listing, and the build number is what tells two
/// uploads of the same version apart when somebody reports a bug against one.

final class AppVersionProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// The version this build was compiled as, with its build number.
  ///
  /// Both, because they answer different questions: the version is what a person
  /// recognises from the store listing, and the build number is what tells two
  /// uploads of the same version apart when somebody reports a bug against one.
  AppVersionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appVersionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appVersionHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return appVersion(ref);
  }
}

String _$appVersionHash() => r'ff1eb5d2af994c051622516f93f238f401bb6abc';
