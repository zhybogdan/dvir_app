// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scope_membership.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScopeMembership {

 Object get membership;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScopeMembership&&const DeepCollectionEquality().equals(other.membership, membership));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(membership));

@override
String toString() {
  return 'ScopeMembership(membership: $membership)';
}


}

/// @nodoc
class $ScopeMembershipCopyWith<$Res>  {
$ScopeMembershipCopyWith(ScopeMembership _, $Res Function(ScopeMembership) __);
}


/// Adds pattern-matching-related methods to [ScopeMembership].
extension ScopeMembershipPatterns on ScopeMembership {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CommunityScope value)?  community,TResult Function( UnitScope value)?  unit,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CommunityScope() when community != null:
return community(_that);case UnitScope() when unit != null:
return unit(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CommunityScope value)  community,required TResult Function( UnitScope value)  unit,}){
final _that = this;
switch (_that) {
case CommunityScope():
return community(_that);case UnitScope():
return unit(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CommunityScope value)?  community,TResult? Function( UnitScope value)?  unit,}){
final _that = this;
switch (_that) {
case CommunityScope() when community != null:
return community(_that);case UnitScope() when unit != null:
return unit(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( CommunityMembership membership)?  community,TResult Function( UnitMembership membership)?  unit,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CommunityScope() when community != null:
return community(_that.membership);case UnitScope() when unit != null:
return unit(_that.membership);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( CommunityMembership membership)  community,required TResult Function( UnitMembership membership)  unit,}) {final _that = this;
switch (_that) {
case CommunityScope():
return community(_that.membership);case UnitScope():
return unit(_that.membership);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( CommunityMembership membership)?  community,TResult? Function( UnitMembership membership)?  unit,}) {final _that = this;
switch (_that) {
case CommunityScope() when community != null:
return community(_that.membership);case UnitScope() when unit != null:
return unit(_that.membership);case _:
  return null;

}
}

}

/// @nodoc


class CommunityScope extends ScopeMembership {
  const CommunityScope(this.membership): super._();
  

@override final  CommunityMembership membership;

/// Create a copy of ScopeMembership
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommunityScopeCopyWith<CommunityScope> get copyWith => _$CommunityScopeCopyWithImpl<CommunityScope>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommunityScope&&(identical(other.membership, membership) || other.membership == membership));
}


@override
int get hashCode => Object.hash(runtimeType,membership);

@override
String toString() {
  return 'ScopeMembership.community(membership: $membership)';
}


}

/// @nodoc
abstract mixin class $CommunityScopeCopyWith<$Res> implements $ScopeMembershipCopyWith<$Res> {
  factory $CommunityScopeCopyWith(CommunityScope value, $Res Function(CommunityScope) _then) = _$CommunityScopeCopyWithImpl;
@useResult
$Res call({
 CommunityMembership membership
});


$CommunityMembershipCopyWith<$Res> get membership;

}
/// @nodoc
class _$CommunityScopeCopyWithImpl<$Res>
    implements $CommunityScopeCopyWith<$Res> {
  _$CommunityScopeCopyWithImpl(this._self, this._then);

  final CommunityScope _self;
  final $Res Function(CommunityScope) _then;

/// Create a copy of ScopeMembership
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? membership = null,}) {
  return _then(CommunityScope(
null == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as CommunityMembership,
  ));
}

/// Create a copy of ScopeMembership
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommunityMembershipCopyWith<$Res> get membership {
  
  return $CommunityMembershipCopyWith<$Res>(_self.membership, (value) {
    return _then(_self.copyWith(membership: value));
  });
}
}

/// @nodoc


class UnitScope extends ScopeMembership {
  const UnitScope(this.membership): super._();
  

@override final  UnitMembership membership;

/// Create a copy of ScopeMembership
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnitScopeCopyWith<UnitScope> get copyWith => _$UnitScopeCopyWithImpl<UnitScope>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnitScope&&(identical(other.membership, membership) || other.membership == membership));
}


@override
int get hashCode => Object.hash(runtimeType,membership);

@override
String toString() {
  return 'ScopeMembership.unit(membership: $membership)';
}


}

/// @nodoc
abstract mixin class $UnitScopeCopyWith<$Res> implements $ScopeMembershipCopyWith<$Res> {
  factory $UnitScopeCopyWith(UnitScope value, $Res Function(UnitScope) _then) = _$UnitScopeCopyWithImpl;
@useResult
$Res call({
 UnitMembership membership
});


$UnitMembershipCopyWith<$Res> get membership;

}
/// @nodoc
class _$UnitScopeCopyWithImpl<$Res>
    implements $UnitScopeCopyWith<$Res> {
  _$UnitScopeCopyWithImpl(this._self, this._then);

  final UnitScope _self;
  final $Res Function(UnitScope) _then;

/// Create a copy of ScopeMembership
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? membership = null,}) {
  return _then(UnitScope(
null == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as UnitMembership,
  ));
}

/// Create a copy of ScopeMembership
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UnitMembershipCopyWith<$Res> get membership {
  
  return $UnitMembershipCopyWith<$Res>(_self.membership, (value) {
    return _then(_self.copyWith(membership: value));
  });
}
}

// dart format on
