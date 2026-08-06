// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scope_ref.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScopeRef {

 String get id;
/// Create a copy of ScopeRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScopeRefCopyWith<ScopeRef> get copyWith => _$ScopeRefCopyWithImpl<ScopeRef>(this as ScopeRef, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScopeRef&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'ScopeRef(id: $id)';
}


}

/// @nodoc
abstract mixin class $ScopeRefCopyWith<$Res>  {
  factory $ScopeRefCopyWith(ScopeRef value, $Res Function(ScopeRef) _then) = _$ScopeRefCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$ScopeRefCopyWithImpl<$Res>
    implements $ScopeRefCopyWith<$Res> {
  _$ScopeRefCopyWithImpl(this._self, this._then);

  final ScopeRef _self;
  final $Res Function(ScopeRef) _then;

/// Create a copy of ScopeRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ScopeRef].
extension ScopeRefPatterns on ScopeRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( UnitScope value)?  unit,TResult Function( CommunityScope value)?  community,required TResult orElse(),}){
final _that = this;
switch (_that) {
case UnitScope() when unit != null:
return unit(_that);case CommunityScope() when community != null:
return community(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( UnitScope value)  unit,required TResult Function( CommunityScope value)  community,}){
final _that = this;
switch (_that) {
case UnitScope():
return unit(_that);case CommunityScope():
return community(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( UnitScope value)?  unit,TResult? Function( CommunityScope value)?  community,}){
final _that = this;
switch (_that) {
case UnitScope() when unit != null:
return unit(_that);case CommunityScope() when community != null:
return community(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String id)?  unit,TResult Function( String id)?  community,required TResult orElse(),}) {final _that = this;
switch (_that) {
case UnitScope() when unit != null:
return unit(_that.id);case CommunityScope() when community != null:
return community(_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String id)  unit,required TResult Function( String id)  community,}) {final _that = this;
switch (_that) {
case UnitScope():
return unit(_that.id);case CommunityScope():
return community(_that.id);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String id)?  unit,TResult? Function( String id)?  community,}) {final _that = this;
switch (_that) {
case UnitScope() when unit != null:
return unit(_that.id);case CommunityScope() when community != null:
return community(_that.id);case _:
  return null;

}
}

}

/// @nodoc


class UnitScope extends ScopeRef {
  const UnitScope(this.id): super._();
  

@override final  String id;

/// Create a copy of ScopeRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnitScopeCopyWith<UnitScope> get copyWith => _$UnitScopeCopyWithImpl<UnitScope>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnitScope&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'ScopeRef.unit(id: $id)';
}


}

/// @nodoc
abstract mixin class $UnitScopeCopyWith<$Res> implements $ScopeRefCopyWith<$Res> {
  factory $UnitScopeCopyWith(UnitScope value, $Res Function(UnitScope) _then) = _$UnitScopeCopyWithImpl;
@override @useResult
$Res call({
 String id
});




}
/// @nodoc
class _$UnitScopeCopyWithImpl<$Res>
    implements $UnitScopeCopyWith<$Res> {
  _$UnitScopeCopyWithImpl(this._self, this._then);

  final UnitScope _self;
  final $Res Function(UnitScope) _then;

/// Create a copy of ScopeRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(UnitScope(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class CommunityScope extends ScopeRef {
  const CommunityScope(this.id): super._();
  

@override final  String id;

/// Create a copy of ScopeRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommunityScopeCopyWith<CommunityScope> get copyWith => _$CommunityScopeCopyWithImpl<CommunityScope>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommunityScope&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'ScopeRef.community(id: $id)';
}


}

/// @nodoc
abstract mixin class $CommunityScopeCopyWith<$Res> implements $ScopeRefCopyWith<$Res> {
  factory $CommunityScopeCopyWith(CommunityScope value, $Res Function(CommunityScope) _then) = _$CommunityScopeCopyWithImpl;
@override @useResult
$Res call({
 String id
});




}
/// @nodoc
class _$CommunityScopeCopyWithImpl<$Res>
    implements $CommunityScopeCopyWith<$Res> {
  _$CommunityScopeCopyWithImpl(this._self, this._then);

  final CommunityScope _self;
  final $Res Function(CommunityScope) _then;

/// Create a copy of ScopeRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(CommunityScope(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
