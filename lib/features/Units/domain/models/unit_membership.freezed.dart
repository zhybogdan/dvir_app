// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unit_membership.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UnitMembership {

 String get id;@JsonKey(name: 'unit_id') String get unitId;@JsonKey(name: 'user_id') String get userId; UnitRole get role; MemberStatus get status;
/// Create a copy of UnitMembership
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnitMembershipCopyWith<UnitMembership> get copyWith => _$UnitMembershipCopyWithImpl<UnitMembership>(this as UnitMembership, _$identity);

  /// Serializes this UnitMembership to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnitMembership&&(identical(other.id, id) || other.id == id)&&(identical(other.unitId, unitId) || other.unitId == unitId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,unitId,userId,role,status);

@override
String toString() {
  return 'UnitMembership(id: $id, unitId: $unitId, userId: $userId, role: $role, status: $status)';
}


}

/// @nodoc
abstract mixin class $UnitMembershipCopyWith<$Res>  {
  factory $UnitMembershipCopyWith(UnitMembership value, $Res Function(UnitMembership) _then) = _$UnitMembershipCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'unit_id') String unitId,@JsonKey(name: 'user_id') String userId, UnitRole role, MemberStatus status
});




}
/// @nodoc
class _$UnitMembershipCopyWithImpl<$Res>
    implements $UnitMembershipCopyWith<$Res> {
  _$UnitMembershipCopyWithImpl(this._self, this._then);

  final UnitMembership _self;
  final $Res Function(UnitMembership) _then;

/// Create a copy of UnitMembership
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? unitId = null,Object? userId = null,Object? role = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,unitId: null == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UnitRole,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MemberStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [UnitMembership].
extension UnitMembershipPatterns on UnitMembership {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UnitMembership value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnitMembership() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UnitMembership value)  $default,){
final _that = this;
switch (_that) {
case _UnitMembership():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UnitMembership value)?  $default,){
final _that = this;
switch (_that) {
case _UnitMembership() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'unit_id')  String unitId, @JsonKey(name: 'user_id')  String userId,  UnitRole role,  MemberStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnitMembership() when $default != null:
return $default(_that.id,_that.unitId,_that.userId,_that.role,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'unit_id')  String unitId, @JsonKey(name: 'user_id')  String userId,  UnitRole role,  MemberStatus status)  $default,) {final _that = this;
switch (_that) {
case _UnitMembership():
return $default(_that.id,_that.unitId,_that.userId,_that.role,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'unit_id')  String unitId, @JsonKey(name: 'user_id')  String userId,  UnitRole role,  MemberStatus status)?  $default,) {final _that = this;
switch (_that) {
case _UnitMembership() when $default != null:
return $default(_that.id,_that.unitId,_that.userId,_that.role,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UnitMembership implements UnitMembership {
  const _UnitMembership({required this.id, @JsonKey(name: 'unit_id') required this.unitId, @JsonKey(name: 'user_id') required this.userId, required this.role, required this.status});
  factory _UnitMembership.fromJson(Map<String, dynamic> json) => _$UnitMembershipFromJson(json);

@override final  String id;
@override@JsonKey(name: 'unit_id') final  String unitId;
@override@JsonKey(name: 'user_id') final  String userId;
@override final  UnitRole role;
@override final  MemberStatus status;

/// Create a copy of UnitMembership
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnitMembershipCopyWith<_UnitMembership> get copyWith => __$UnitMembershipCopyWithImpl<_UnitMembership>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UnitMembershipToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnitMembership&&(identical(other.id, id) || other.id == id)&&(identical(other.unitId, unitId) || other.unitId == unitId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,unitId,userId,role,status);

@override
String toString() {
  return 'UnitMembership(id: $id, unitId: $unitId, userId: $userId, role: $role, status: $status)';
}


}

/// @nodoc
abstract mixin class _$UnitMembershipCopyWith<$Res> implements $UnitMembershipCopyWith<$Res> {
  factory _$UnitMembershipCopyWith(_UnitMembership value, $Res Function(_UnitMembership) _then) = __$UnitMembershipCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'unit_id') String unitId,@JsonKey(name: 'user_id') String userId, UnitRole role, MemberStatus status
});




}
/// @nodoc
class __$UnitMembershipCopyWithImpl<$Res>
    implements _$UnitMembershipCopyWith<$Res> {
  __$UnitMembershipCopyWithImpl(this._self, this._then);

  final _UnitMembership _self;
  final $Res Function(_UnitMembership) _then;

/// Create a copy of UnitMembership
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? unitId = null,Object? userId = null,Object? role = null,Object? status = null,}) {
  return _then(_UnitMembership(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,unitId: null == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UnitRole,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MemberStatus,
  ));
}


}

// dart format on
