// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'join_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JoinResult {

 Object get membership;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JoinResult&&const DeepCollectionEquality().equals(other.membership, membership));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(membership));

@override
String toString() {
  return 'JoinResult(membership: $membership)';
}


}

/// @nodoc
class $JoinResultCopyWith<$Res>  {
$JoinResultCopyWith(JoinResult _, $Res Function(JoinResult) __);
}


/// Adds pattern-matching-related methods to [JoinResult].
extension JoinResultPatterns on JoinResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( JoinedCommunity value)?  community,TResult Function( JoinedUnit value)?  unit,required TResult orElse(),}){
final _that = this;
switch (_that) {
case JoinedCommunity() when community != null:
return community(_that);case JoinedUnit() when unit != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( JoinedCommunity value)  community,required TResult Function( JoinedUnit value)  unit,}){
final _that = this;
switch (_that) {
case JoinedCommunity():
return community(_that);case JoinedUnit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( JoinedCommunity value)?  community,TResult? Function( JoinedUnit value)?  unit,}){
final _that = this;
switch (_that) {
case JoinedCommunity() when community != null:
return community(_that);case JoinedUnit() when unit != null:
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
case JoinedCommunity() when community != null:
return community(_that.membership);case JoinedUnit() when unit != null:
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
case JoinedCommunity():
return community(_that.membership);case JoinedUnit():
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
case JoinedCommunity() when community != null:
return community(_that.membership);case JoinedUnit() when unit != null:
return unit(_that.membership);case _:
  return null;

}
}

}

/// @nodoc


class JoinedCommunity implements JoinResult {
  const JoinedCommunity(this.membership);
  

@override final  CommunityMembership membership;

/// Create a copy of JoinResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JoinedCommunityCopyWith<JoinedCommunity> get copyWith => _$JoinedCommunityCopyWithImpl<JoinedCommunity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JoinedCommunity&&(identical(other.membership, membership) || other.membership == membership));
}


@override
int get hashCode => Object.hash(runtimeType,membership);

@override
String toString() {
  return 'JoinResult.community(membership: $membership)';
}


}

/// @nodoc
abstract mixin class $JoinedCommunityCopyWith<$Res> implements $JoinResultCopyWith<$Res> {
  factory $JoinedCommunityCopyWith(JoinedCommunity value, $Res Function(JoinedCommunity) _then) = _$JoinedCommunityCopyWithImpl;
@useResult
$Res call({
 CommunityMembership membership
});


$CommunityMembershipCopyWith<$Res> get membership;

}
/// @nodoc
class _$JoinedCommunityCopyWithImpl<$Res>
    implements $JoinedCommunityCopyWith<$Res> {
  _$JoinedCommunityCopyWithImpl(this._self, this._then);

  final JoinedCommunity _self;
  final $Res Function(JoinedCommunity) _then;

/// Create a copy of JoinResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? membership = null,}) {
  return _then(JoinedCommunity(
null == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as CommunityMembership,
  ));
}

/// Create a copy of JoinResult
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


class JoinedUnit implements JoinResult {
  const JoinedUnit(this.membership);
  

@override final  UnitMembership membership;

/// Create a copy of JoinResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JoinedUnitCopyWith<JoinedUnit> get copyWith => _$JoinedUnitCopyWithImpl<JoinedUnit>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JoinedUnit&&(identical(other.membership, membership) || other.membership == membership));
}


@override
int get hashCode => Object.hash(runtimeType,membership);

@override
String toString() {
  return 'JoinResult.unit(membership: $membership)';
}


}

/// @nodoc
abstract mixin class $JoinedUnitCopyWith<$Res> implements $JoinResultCopyWith<$Res> {
  factory $JoinedUnitCopyWith(JoinedUnit value, $Res Function(JoinedUnit) _then) = _$JoinedUnitCopyWithImpl;
@useResult
$Res call({
 UnitMembership membership
});


$UnitMembershipCopyWith<$Res> get membership;

}
/// @nodoc
class _$JoinedUnitCopyWithImpl<$Res>
    implements $JoinedUnitCopyWith<$Res> {
  _$JoinedUnitCopyWithImpl(this._self, this._then);

  final JoinedUnit _self;
  final $Res Function(JoinedUnit) _then;

/// Create a copy of JoinResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? membership = null,}) {
  return _then(JoinedUnit(
null == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as UnitMembership,
  ));
}

/// Create a copy of JoinResult
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
