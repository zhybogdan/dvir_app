// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unit_attribute.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UnitAttribute {

 String get id; String get name; String get value;
/// Create a copy of UnitAttribute
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnitAttributeCopyWith<UnitAttribute> get copyWith => _$UnitAttributeCopyWithImpl<UnitAttribute>(this as UnitAttribute, _$identity);

  /// Serializes this UnitAttribute to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnitAttribute&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,value);

@override
String toString() {
  return 'UnitAttribute(id: $id, name: $name, value: $value)';
}


}

/// @nodoc
abstract mixin class $UnitAttributeCopyWith<$Res>  {
  factory $UnitAttributeCopyWith(UnitAttribute value, $Res Function(UnitAttribute) _then) = _$UnitAttributeCopyWithImpl;
@useResult
$Res call({
 String id, String name, String value
});




}
/// @nodoc
class _$UnitAttributeCopyWithImpl<$Res>
    implements $UnitAttributeCopyWith<$Res> {
  _$UnitAttributeCopyWithImpl(this._self, this._then);

  final UnitAttribute _self;
  final $Res Function(UnitAttribute) _then;

/// Create a copy of UnitAttribute
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? value = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UnitAttribute].
extension UnitAttributePatterns on UnitAttribute {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UnitAttribute value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnitAttribute() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UnitAttribute value)  $default,){
final _that = this;
switch (_that) {
case _UnitAttribute():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UnitAttribute value)?  $default,){
final _that = this;
switch (_that) {
case _UnitAttribute() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnitAttribute() when $default != null:
return $default(_that.id,_that.name,_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String value)  $default,) {final _that = this;
switch (_that) {
case _UnitAttribute():
return $default(_that.id,_that.name,_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String value)?  $default,) {final _that = this;
switch (_that) {
case _UnitAttribute() when $default != null:
return $default(_that.id,_that.name,_that.value);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UnitAttribute implements UnitAttribute {
  const _UnitAttribute({required this.id, required this.name, required this.value});
  factory _UnitAttribute.fromJson(Map<String, dynamic> json) => _$UnitAttributeFromJson(json);

@override final  String id;
@override final  String name;
@override final  String value;

/// Create a copy of UnitAttribute
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnitAttributeCopyWith<_UnitAttribute> get copyWith => __$UnitAttributeCopyWithImpl<_UnitAttribute>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UnitAttributeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnitAttribute&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,value);

@override
String toString() {
  return 'UnitAttribute(id: $id, name: $name, value: $value)';
}


}

/// @nodoc
abstract mixin class _$UnitAttributeCopyWith<$Res> implements $UnitAttributeCopyWith<$Res> {
  factory _$UnitAttributeCopyWith(_UnitAttribute value, $Res Function(_UnitAttribute) _then) = __$UnitAttributeCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String value
});




}
/// @nodoc
class __$UnitAttributeCopyWithImpl<$Res>
    implements _$UnitAttributeCopyWith<$Res> {
  __$UnitAttributeCopyWithImpl(this._self, this._then);

  final _UnitAttribute _self;
  final $Res Function(_UnitAttribute) _then;

/// Create a copy of UnitAttribute
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? value = null,}) {
  return _then(_UnitAttribute(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
