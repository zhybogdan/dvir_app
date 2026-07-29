import 'package:freezed_annotation/freezed_annotation.dart';

part 'unit_attribute.freezed.dart';
part 'unit_attribute.g.dart';

/// One free-form fact about an object — "Рік побудови: 1998".
///
/// Neither `unit_id` nor `position` is here, and both are absences worth
/// stating: the list is always read for one object, so the object is what the
/// caller already has, and the order is the order of the list rather than a
/// number anything displays. Reordering, when it arrives, sends ids in their
/// new order — the positions themselves stay in the database.
@freezed
abstract class UnitAttribute with _$UnitAttribute {
  const factory UnitAttribute({
    required String id,
    required String name,
    required String value,
  }) = _UnitAttribute;

  factory UnitAttribute.fromJson(Map<String, dynamic> json) =>
      _$UnitAttributeFromJson(json);
}
