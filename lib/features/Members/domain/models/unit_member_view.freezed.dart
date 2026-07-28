// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unit_member_view.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UnitMemberView {

 UnitMembership get membership; Profile? get profile;
/// Create a copy of UnitMemberView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnitMemberViewCopyWith<UnitMemberView> get copyWith => _$UnitMemberViewCopyWithImpl<UnitMemberView>(this as UnitMemberView, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnitMemberView&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.profile, profile) || other.profile == profile));
}


@override
int get hashCode => Object.hash(runtimeType,membership,profile);

@override
String toString() {
  return 'UnitMemberView(membership: $membership, profile: $profile)';
}


}

/// @nodoc
abstract mixin class $UnitMemberViewCopyWith<$Res>  {
  factory $UnitMemberViewCopyWith(UnitMemberView value, $Res Function(UnitMemberView) _then) = _$UnitMemberViewCopyWithImpl;
@useResult
$Res call({
 UnitMembership membership, Profile? profile
});


$UnitMembershipCopyWith<$Res> get membership;$ProfileCopyWith<$Res>? get profile;

}
/// @nodoc
class _$UnitMemberViewCopyWithImpl<$Res>
    implements $UnitMemberViewCopyWith<$Res> {
  _$UnitMemberViewCopyWithImpl(this._self, this._then);

  final UnitMemberView _self;
  final $Res Function(UnitMemberView) _then;

/// Create a copy of UnitMemberView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? membership = null,Object? profile = freezed,}) {
  return _then(_self.copyWith(
membership: null == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as UnitMembership,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as Profile?,
  ));
}
/// Create a copy of UnitMemberView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UnitMembershipCopyWith<$Res> get membership {
  
  return $UnitMembershipCopyWith<$Res>(_self.membership, (value) {
    return _then(_self.copyWith(membership: value));
  });
}/// Create a copy of UnitMemberView
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


/// Adds pattern-matching-related methods to [UnitMemberView].
extension UnitMemberViewPatterns on UnitMemberView {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UnitMemberView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnitMemberView() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UnitMemberView value)  $default,){
final _that = this;
switch (_that) {
case _UnitMemberView():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UnitMemberView value)?  $default,){
final _that = this;
switch (_that) {
case _UnitMemberView() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UnitMembership membership,  Profile? profile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnitMemberView() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UnitMembership membership,  Profile? profile)  $default,) {final _that = this;
switch (_that) {
case _UnitMemberView():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UnitMembership membership,  Profile? profile)?  $default,) {final _that = this;
switch (_that) {
case _UnitMemberView() when $default != null:
return $default(_that.membership,_that.profile);case _:
  return null;

}
}

}

/// @nodoc


class _UnitMemberView extends UnitMemberView {
  const _UnitMemberView({required this.membership, this.profile}): super._();
  

@override final  UnitMembership membership;
@override final  Profile? profile;

/// Create a copy of UnitMemberView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnitMemberViewCopyWith<_UnitMemberView> get copyWith => __$UnitMemberViewCopyWithImpl<_UnitMemberView>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnitMemberView&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.profile, profile) || other.profile == profile));
}


@override
int get hashCode => Object.hash(runtimeType,membership,profile);

@override
String toString() {
  return 'UnitMemberView(membership: $membership, profile: $profile)';
}


}

/// @nodoc
abstract mixin class _$UnitMemberViewCopyWith<$Res> implements $UnitMemberViewCopyWith<$Res> {
  factory _$UnitMemberViewCopyWith(_UnitMemberView value, $Res Function(_UnitMemberView) _then) = __$UnitMemberViewCopyWithImpl;
@override @useResult
$Res call({
 UnitMembership membership, Profile? profile
});


@override $UnitMembershipCopyWith<$Res> get membership;@override $ProfileCopyWith<$Res>? get profile;

}
/// @nodoc
class __$UnitMemberViewCopyWithImpl<$Res>
    implements _$UnitMemberViewCopyWith<$Res> {
  __$UnitMemberViewCopyWithImpl(this._self, this._then);

  final _UnitMemberView _self;
  final $Res Function(_UnitMemberView) _then;

/// Create a copy of UnitMemberView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? membership = null,Object? profile = freezed,}) {
  return _then(_UnitMemberView(
membership: null == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as UnitMembership,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as Profile?,
  ));
}

/// Create a copy of UnitMemberView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UnitMembershipCopyWith<$Res> get membership {
  
  return $UnitMembershipCopyWith<$Res>(_self.membership, (value) {
    return _then(_self.copyWith(membership: value));
  });
}/// Create a copy of UnitMemberView
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
