// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'created_scope.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CreatedScope {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreatedScope);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CreatedScope()';
}


}

/// @nodoc
class $CreatedScopeCopyWith<$Res>  {
$CreatedScopeCopyWith(CreatedScope _, $Res Function(CreatedScope) __);
}


/// Adds pattern-matching-related methods to [CreatedScope].
extension CreatedScopePatterns on CreatedScope {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CreatedCommunity value)?  community,TResult Function( CreatedUnit value)?  unit,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CreatedCommunity() when community != null:
return community(_that);case CreatedUnit() when unit != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CreatedCommunity value)  community,required TResult Function( CreatedUnit value)  unit,}){
final _that = this;
switch (_that) {
case CreatedCommunity():
return community(_that);case CreatedUnit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CreatedCommunity value)?  community,TResult? Function( CreatedUnit value)?  unit,}){
final _that = this;
switch (_that) {
case CreatedCommunity() when community != null:
return community(_that);case CreatedUnit() when unit != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Community community)?  community,TResult Function( Unit unit)?  unit,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CreatedCommunity() when community != null:
return community(_that.community);case CreatedUnit() when unit != null:
return unit(_that.unit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Community community)  community,required TResult Function( Unit unit)  unit,}) {final _that = this;
switch (_that) {
case CreatedCommunity():
return community(_that.community);case CreatedUnit():
return unit(_that.unit);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Community community)?  community,TResult? Function( Unit unit)?  unit,}) {final _that = this;
switch (_that) {
case CreatedCommunity() when community != null:
return community(_that.community);case CreatedUnit() when unit != null:
return unit(_that.unit);case _:
  return null;

}
}

}

/// @nodoc


class CreatedCommunity extends CreatedScope {
  const CreatedCommunity(this.community): super._();
  

 final  Community community;

/// Create a copy of CreatedScope
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreatedCommunityCopyWith<CreatedCommunity> get copyWith => _$CreatedCommunityCopyWithImpl<CreatedCommunity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreatedCommunity&&(identical(other.community, community) || other.community == community));
}


@override
int get hashCode => Object.hash(runtimeType,community);

@override
String toString() {
  return 'CreatedScope.community(community: $community)';
}


}

/// @nodoc
abstract mixin class $CreatedCommunityCopyWith<$Res> implements $CreatedScopeCopyWith<$Res> {
  factory $CreatedCommunityCopyWith(CreatedCommunity value, $Res Function(CreatedCommunity) _then) = _$CreatedCommunityCopyWithImpl;
@useResult
$Res call({
 Community community
});


$CommunityCopyWith<$Res> get community;

}
/// @nodoc
class _$CreatedCommunityCopyWithImpl<$Res>
    implements $CreatedCommunityCopyWith<$Res> {
  _$CreatedCommunityCopyWithImpl(this._self, this._then);

  final CreatedCommunity _self;
  final $Res Function(CreatedCommunity) _then;

/// Create a copy of CreatedScope
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? community = null,}) {
  return _then(CreatedCommunity(
null == community ? _self.community : community // ignore: cast_nullable_to_non_nullable
as Community,
  ));
}

/// Create a copy of CreatedScope
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommunityCopyWith<$Res> get community {
  
  return $CommunityCopyWith<$Res>(_self.community, (value) {
    return _then(_self.copyWith(community: value));
  });
}
}

/// @nodoc


class CreatedUnit extends CreatedScope {
  const CreatedUnit(this.unit): super._();
  

 final  Unit unit;

/// Create a copy of CreatedScope
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreatedUnitCopyWith<CreatedUnit> get copyWith => _$CreatedUnitCopyWithImpl<CreatedUnit>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreatedUnit&&(identical(other.unit, unit) || other.unit == unit));
}


@override
int get hashCode => Object.hash(runtimeType,unit);

@override
String toString() {
  return 'CreatedScope.unit(unit: $unit)';
}


}

/// @nodoc
abstract mixin class $CreatedUnitCopyWith<$Res> implements $CreatedScopeCopyWith<$Res> {
  factory $CreatedUnitCopyWith(CreatedUnit value, $Res Function(CreatedUnit) _then) = _$CreatedUnitCopyWithImpl;
@useResult
$Res call({
 Unit unit
});


$UnitCopyWith<$Res> get unit;

}
/// @nodoc
class _$CreatedUnitCopyWithImpl<$Res>
    implements $CreatedUnitCopyWith<$Res> {
  _$CreatedUnitCopyWithImpl(this._self, this._then);

  final CreatedUnit _self;
  final $Res Function(CreatedUnit) _then;

/// Create a copy of CreatedScope
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? unit = null,}) {
  return _then(CreatedUnit(
null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as Unit,
  ));
}

/// Create a copy of CreatedScope
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UnitCopyWith<$Res> get unit {
  
  return $UnitCopyWith<$Res>(_self.unit, (value) {
    return _then(_self.copyWith(unit: value));
  });
}
}

// dart format on
