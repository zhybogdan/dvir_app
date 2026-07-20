// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'community_membership.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CommunityMembership {

 String get id;@JsonKey(name: 'community_id') String get communityId;@JsonKey(name: 'user_id') String get userId; MemberRole get role; MemberStatus get status;
/// Create a copy of CommunityMembership
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommunityMembershipCopyWith<CommunityMembership> get copyWith => _$CommunityMembershipCopyWithImpl<CommunityMembership>(this as CommunityMembership, _$identity);

  /// Serializes this CommunityMembership to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommunityMembership&&(identical(other.id, id) || other.id == id)&&(identical(other.communityId, communityId) || other.communityId == communityId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,communityId,userId,role,status);

@override
String toString() {
  return 'CommunityMembership(id: $id, communityId: $communityId, userId: $userId, role: $role, status: $status)';
}


}

/// @nodoc
abstract mixin class $CommunityMembershipCopyWith<$Res>  {
  factory $CommunityMembershipCopyWith(CommunityMembership value, $Res Function(CommunityMembership) _then) = _$CommunityMembershipCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'community_id') String communityId,@JsonKey(name: 'user_id') String userId, MemberRole role, MemberStatus status
});




}
/// @nodoc
class _$CommunityMembershipCopyWithImpl<$Res>
    implements $CommunityMembershipCopyWith<$Res> {
  _$CommunityMembershipCopyWithImpl(this._self, this._then);

  final CommunityMembership _self;
  final $Res Function(CommunityMembership) _then;

/// Create a copy of CommunityMembership
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? communityId = null,Object? userId = null,Object? role = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,communityId: null == communityId ? _self.communityId : communityId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MemberRole,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MemberStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [CommunityMembership].
extension CommunityMembershipPatterns on CommunityMembership {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommunityMembership value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommunityMembership() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommunityMembership value)  $default,){
final _that = this;
switch (_that) {
case _CommunityMembership():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommunityMembership value)?  $default,){
final _that = this;
switch (_that) {
case _CommunityMembership() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'community_id')  String communityId, @JsonKey(name: 'user_id')  String userId,  MemberRole role,  MemberStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommunityMembership() when $default != null:
return $default(_that.id,_that.communityId,_that.userId,_that.role,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'community_id')  String communityId, @JsonKey(name: 'user_id')  String userId,  MemberRole role,  MemberStatus status)  $default,) {final _that = this;
switch (_that) {
case _CommunityMembership():
return $default(_that.id,_that.communityId,_that.userId,_that.role,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'community_id')  String communityId, @JsonKey(name: 'user_id')  String userId,  MemberRole role,  MemberStatus status)?  $default,) {final _that = this;
switch (_that) {
case _CommunityMembership() when $default != null:
return $default(_that.id,_that.communityId,_that.userId,_that.role,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommunityMembership implements CommunityMembership {
  const _CommunityMembership({required this.id, @JsonKey(name: 'community_id') required this.communityId, @JsonKey(name: 'user_id') required this.userId, required this.role, required this.status});
  factory _CommunityMembership.fromJson(Map<String, dynamic> json) => _$CommunityMembershipFromJson(json);

@override final  String id;
@override@JsonKey(name: 'community_id') final  String communityId;
@override@JsonKey(name: 'user_id') final  String userId;
@override final  MemberRole role;
@override final  MemberStatus status;

/// Create a copy of CommunityMembership
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommunityMembershipCopyWith<_CommunityMembership> get copyWith => __$CommunityMembershipCopyWithImpl<_CommunityMembership>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommunityMembershipToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommunityMembership&&(identical(other.id, id) || other.id == id)&&(identical(other.communityId, communityId) || other.communityId == communityId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,communityId,userId,role,status);

@override
String toString() {
  return 'CommunityMembership(id: $id, communityId: $communityId, userId: $userId, role: $role, status: $status)';
}


}

/// @nodoc
abstract mixin class _$CommunityMembershipCopyWith<$Res> implements $CommunityMembershipCopyWith<$Res> {
  factory _$CommunityMembershipCopyWith(_CommunityMembership value, $Res Function(_CommunityMembership) _then) = __$CommunityMembershipCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'community_id') String communityId,@JsonKey(name: 'user_id') String userId, MemberRole role, MemberStatus status
});




}
/// @nodoc
class __$CommunityMembershipCopyWithImpl<$Res>
    implements _$CommunityMembershipCopyWith<$Res> {
  __$CommunityMembershipCopyWithImpl(this._self, this._then);

  final _CommunityMembership _self;
  final $Res Function(_CommunityMembership) _then;

/// Create a copy of CommunityMembership
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? communityId = null,Object? userId = null,Object? role = null,Object? status = null,}) {
  return _then(_CommunityMembership(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,communityId: null == communityId ? _self.communityId : communityId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MemberRole,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MemberStatus,
  ));
}


}

// dart format on
