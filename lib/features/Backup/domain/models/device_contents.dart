import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_contents.freezed.dart';

/// How much this phone holds, as the settings screen says it before a copy is
/// made.
///
/// [bytes] is the records and the files together — roughly what a copy made
/// now would weigh, which is the number a person deciding where to keep one
/// actually needs.
@freezed
abstract class DeviceContents with _$DeviceContents {
  const factory DeviceContents({
    required int units,
    required int documents,
    required int bytes,
  }) = _DeviceContents;
}
