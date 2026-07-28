// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Unit {

 String get id; String get label; UnitType get type;@JsonKey(name: 'invite_code') String? get inviteCode;@JsonKey(name: 'community_id') String? get communityId;@JsonKey(name: 'parent_id') String? get parentId; String? get address; String? get city;@JsonKey(name: 'area_m2') double? get areaM2;
/// Create a copy of Unit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnitCopyWith<Unit> get copyWith => _$UnitCopyWithImpl<Unit>(this as Unit, _$identity);

  /// Serializes this Unit to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Unit&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode)&&(identical(other.communityId, communityId) || other.communityId == communityId)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.areaM2, areaM2) || other.areaM2 == areaM2));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,type,inviteCode,communityId,parentId,address,city,areaM2);

@override
String toString() {
  return 'Unit(id: $id, label: $label, type: $type, inviteCode: $inviteCode, communityId: $communityId, parentId: $parentId, address: $address, city: $city, areaM2: $areaM2)';
}


}

/// @nodoc
abstract mixin class $UnitCopyWith<$Res>  {
  factory $UnitCopyWith(Unit value, $Res Function(Unit) _then) = _$UnitCopyWithImpl;
@useResult
$Res call({
 String id, String label, UnitType type,@JsonKey(name: 'invite_code') String? inviteCode,@JsonKey(name: 'community_id') String? communityId,@JsonKey(name: 'parent_id') String? parentId, String? address, String? city,@JsonKey(name: 'area_m2') double? areaM2
});




}
/// @nodoc
class _$UnitCopyWithImpl<$Res>
    implements $UnitCopyWith<$Res> {
  _$UnitCopyWithImpl(this._self, this._then);

  final Unit _self;
  final $Res Function(Unit) _then;

/// Create a copy of Unit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? type = null,Object? inviteCode = freezed,Object? communityId = freezed,Object? parentId = freezed,Object? address = freezed,Object? city = freezed,Object? areaM2 = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as UnitType,inviteCode: freezed == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String?,communityId: freezed == communityId ? _self.communityId : communityId // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,areaM2: freezed == areaM2 ? _self.areaM2 : areaM2 // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [Unit].
extension UnitPatterns on Unit {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Unit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Unit() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Unit value)  $default,){
final _that = this;
switch (_that) {
case _Unit():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Unit value)?  $default,){
final _that = this;
switch (_that) {
case _Unit() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String label,  UnitType type, @JsonKey(name: 'invite_code')  String? inviteCode, @JsonKey(name: 'community_id')  String? communityId, @JsonKey(name: 'parent_id')  String? parentId,  String? address,  String? city, @JsonKey(name: 'area_m2')  double? areaM2)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Unit() when $default != null:
return $default(_that.id,_that.label,_that.type,_that.inviteCode,_that.communityId,_that.parentId,_that.address,_that.city,_that.areaM2);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String label,  UnitType type, @JsonKey(name: 'invite_code')  String? inviteCode, @JsonKey(name: 'community_id')  String? communityId, @JsonKey(name: 'parent_id')  String? parentId,  String? address,  String? city, @JsonKey(name: 'area_m2')  double? areaM2)  $default,) {final _that = this;
switch (_that) {
case _Unit():
return $default(_that.id,_that.label,_that.type,_that.inviteCode,_that.communityId,_that.parentId,_that.address,_that.city,_that.areaM2);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String label,  UnitType type, @JsonKey(name: 'invite_code')  String? inviteCode, @JsonKey(name: 'community_id')  String? communityId, @JsonKey(name: 'parent_id')  String? parentId,  String? address,  String? city, @JsonKey(name: 'area_m2')  double? areaM2)?  $default,) {final _that = this;
switch (_that) {
case _Unit() when $default != null:
return $default(_that.id,_that.label,_that.type,_that.inviteCode,_that.communityId,_that.parentId,_that.address,_that.city,_that.areaM2);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Unit implements Unit {
  const _Unit({required this.id, required this.label, required this.type, @JsonKey(name: 'invite_code') this.inviteCode, @JsonKey(name: 'community_id') this.communityId, @JsonKey(name: 'parent_id') this.parentId, this.address, this.city, @JsonKey(name: 'area_m2') this.areaM2});
  factory _Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);

@override final  String id;
@override final  String label;
@override final  UnitType type;
@override@JsonKey(name: 'invite_code') final  String? inviteCode;
@override@JsonKey(name: 'community_id') final  String? communityId;
@override@JsonKey(name: 'parent_id') final  String? parentId;
@override final  String? address;
@override final  String? city;
@override@JsonKey(name: 'area_m2') final  double? areaM2;

/// Create a copy of Unit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnitCopyWith<_Unit> get copyWith => __$UnitCopyWithImpl<_Unit>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UnitToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Unit&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode)&&(identical(other.communityId, communityId) || other.communityId == communityId)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.areaM2, areaM2) || other.areaM2 == areaM2));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,type,inviteCode,communityId,parentId,address,city,areaM2);

@override
String toString() {
  return 'Unit(id: $id, label: $label, type: $type, inviteCode: $inviteCode, communityId: $communityId, parentId: $parentId, address: $address, city: $city, areaM2: $areaM2)';
}


}

/// @nodoc
abstract mixin class _$UnitCopyWith<$Res> implements $UnitCopyWith<$Res> {
  factory _$UnitCopyWith(_Unit value, $Res Function(_Unit) _then) = __$UnitCopyWithImpl;
@override @useResult
$Res call({
 String id, String label, UnitType type,@JsonKey(name: 'invite_code') String? inviteCode,@JsonKey(name: 'community_id') String? communityId,@JsonKey(name: 'parent_id') String? parentId, String? address, String? city,@JsonKey(name: 'area_m2') double? areaM2
});




}
/// @nodoc
class __$UnitCopyWithImpl<$Res>
    implements _$UnitCopyWith<$Res> {
  __$UnitCopyWithImpl(this._self, this._then);

  final _Unit _self;
  final $Res Function(_Unit) _then;

/// Create a copy of Unit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? type = null,Object? inviteCode = freezed,Object? communityId = freezed,Object? parentId = freezed,Object? address = freezed,Object? city = freezed,Object? areaM2 = freezed,}) {
  return _then(_Unit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as UnitType,inviteCode: freezed == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String?,communityId: freezed == communityId ? _self.communityId : communityId // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,areaM2: freezed == areaM2 ? _self.areaM2 : areaM2 // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
