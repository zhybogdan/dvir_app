// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'community_member_view.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CommunityMemberView {

 CommunityMembership get membership; Profile? get profile;
/// Create a copy of CommunityMemberView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommunityMemberViewCopyWith<CommunityMemberView> get copyWith => _$CommunityMemberViewCopyWithImpl<CommunityMemberView>(this as CommunityMemberView, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommunityMemberView&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.profile, profile) || other.profile == profile));
}


@override
int get hashCode => Object.hash(runtimeType,membership,profile);

@override
String toString() {
  return 'CommunityMemberView(membership: $membership, profile: $profile)';
}


}

/// @nodoc
abstract mixin class $CommunityMemberViewCopyWith<$Res>  {
  factory $CommunityMemberViewCopyWith(CommunityMemberView value, $Res Function(CommunityMemberView) _then) = _$CommunityMemberViewCopyWithImpl;
@useResult
$Res call({
 CommunityMembership membership, Profile? profile
});


$CommunityMembershipCopyWith<$Res> get membership;$ProfileCopyWith<$Res>? get profile;

}
/// @nodoc
class _$CommunityMemberViewCopyWithImpl<$Res>
    implements $CommunityMemberViewCopyWith<$Res> {
  _$CommunityMemberViewCopyWithImpl(this._self, this._then);

  final CommunityMemberView _self;
  final $Res Function(CommunityMemberView) _then;

/// Create a copy of CommunityMemberView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? membership = null,Object? profile = freezed,}) {
  return _then(_self.copyWith(
membership: null == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as CommunityMembership,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as Profile?,
  ));
}
/// Create a copy of CommunityMemberView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommunityMembershipCopyWith<$Res> get membership {
  
  return $CommunityMembershipCopyWith<$Res>(_self.membership, (value) {
    return _then(_self.copyWith(membership: value));
  });
}/// Create a copy of CommunityMemberView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $ProfileCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// Adds pattern-matching-related methods to [CommunityMemberView].
extension CommunityMemberViewPatterns on CommunityMemberView {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommunityMemberView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommunityMemberView() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommunityMemberView value)  $default,){
final _that = this;
switch (_that) {
case _CommunityMemberView():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommunityMemberView value)?  $default,){
final _that = this;
switch (_that) {
case _CommunityMemberView() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CommunityMembership membership,  Profile? profile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommunityMemberView() when $default != null:
return $default(_that.membership,_that.profile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CommunityMembership membership,  Profile? profile)  $default,) {final _that = this;
switch (_that) {
case _CommunityMemberView():
return $default(_that.membership,_that.profile);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CommunityMembership membership,  Profile? profile)?  $default,) {final _that = this;
switch (_that) {
case _CommunityMemberView() when $default != null:
return $default(_that.membership,_that.profile);case _:
  return null;

}
}

}

/// @nodoc


class _CommunityMemberView implements CommunityMemberView {
  const _CommunityMemberView({required this.membership, this.profile});
  

@override final  CommunityMembership membership;
@override final  Profile? profile;

/// Create a copy of CommunityMemberView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommunityMemberViewCopyWith<_CommunityMemberView> get copyWith => __$CommunityMemberViewCopyWithImpl<_CommunityMemberView>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommunityMemberView&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.profile, profile) || other.profile == profile));
}


@override
int get hashCode => Object.hash(runtimeType,membership,profile);

@override
String toString() {
  return 'CommunityMemberView(membership: $membership, profile: $profile)';
}


}

/// @nodoc
abstract mixin class _$CommunityMemberViewCopyWith<$Res> implements $CommunityMemberViewCopyWith<$Res> {
  factory _$CommunityMemberViewCopyWith(_CommunityMemberView value, $Res Function(_CommunityMemberView) _then) = __$CommunityMemberViewCopyWithImpl;
@override @useResult
$Res call({
 CommunityMembership membership, Profile? profile
});


@override $CommunityMembershipCopyWith<$Res> get membership;@override $ProfileCopyWith<$Res>? get profile;

}
/// @nodoc
class __$CommunityMemberViewCopyWithImpl<$Res>
    implements _$CommunityMemberViewCopyWith<$Res> {
  __$CommunityMemberViewCopyWithImpl(this._self, this._then);

  final _CommunityMemberView _self;
  final $Res Function(_CommunityMemberView) _then;

/// Create a copy of CommunityMemberView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? membership = null,Object? profile = freezed,}) {
  return _then(_CommunityMemberView(
membership: null == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as CommunityMembership,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as Profile?,
  ));
}

/// Create a copy of CommunityMemberView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommunityMembershipCopyWith<$Res> get membership {
  
  return $CommunityMembershipCopyWith<$Res>(_self.membership, (value) {
    return _then(_self.copyWith(membership: value));
  });
}/// Create a copy of CommunityMemberView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $ProfileCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}

// dart format on
