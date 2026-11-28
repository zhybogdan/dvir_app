// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_contents.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DeviceContents {

 int get units; int get documents; int get bytes;
/// Create a copy of DeviceContents
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceContentsCopyWith<DeviceContents> get copyWith => _$DeviceContentsCopyWithImpl<DeviceContents>(this as DeviceContents, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DeviceContents;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceContents&&(identical(other.units, _this.units) || other.units == _this.units)&&(identical(other.documents, _this.documents) || other.documents == _this.documents)&&(identical(other.bytes, _this.bytes) || other.bytes == _this.bytes));
}


@override
int get hashCode {
  final _this = this as DeviceContents;
  return Object.hash(runtimeType,_this.units,_this.documents,_this.bytes);
}

@override
String toString() {
  final _this = this as DeviceContents;
  return 'DeviceContents(units: ${_this.units}, documents: ${_this.documents}, bytes: ${_this.bytes})';
}


}

/// @nodoc
abstract mixin class $DeviceContentsCopyWith<$Res>  {
  factory $DeviceContentsCopyWith(DeviceContents value, $Res Function(DeviceContents) _then) = _$DeviceContentsCopyWithImpl;
@useResult
$Res call({
 int units, int documents, int bytes
});




}
/// @nodoc
class _$DeviceContentsCopyWithImpl<$Res>
    implements $DeviceContentsCopyWith<$Res> {
  _$DeviceContentsCopyWithImpl(this._self, this._then);

  final DeviceContents _self;
  final $Res Function(DeviceContents) _then;

/// Create a copy of DeviceContents
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? units = null,Object? documents = null,Object? bytes = null,}) {
  return _then(DeviceContents(
units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as int,documents: null == documents ? _self.documents : documents // ignore: cast_nullable_to_non_nullable
as int,bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DeviceContents].
extension DeviceContentsPatterns on DeviceContents {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceContents value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceContents() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceContents value)  $default,){
final _that = this;
switch (_that) {
case _DeviceContents():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceContents value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceContents() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int units,  int documents,  int bytes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceContents() when $default != null:
return $default(_that.units,_that.documents,_that.bytes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int units,  int documents,  int bytes)  $default,) {final _that = this;
switch (_that) {
case _DeviceContents():
return $default(_that.units,_that.documents,_that.bytes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int units,  int documents,  int bytes)?  $default,) {final _that = this;
switch (_that) {
case _DeviceContents() when $default != null:
return $default(_that.units,_that.documents,_that.bytes);case _:
  return null;

}
}

}

/// @nodoc


class _DeviceContents implements DeviceContents {
  const _DeviceContents({required this.units, required this.documents, required this.bytes});
  

@override final  int units;
@override final  int documents;
@override final  int bytes;

/// Create a copy of DeviceContents
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceContentsCopyWith<_DeviceContents> get copyWith => __$DeviceContentsCopyWithImpl<_DeviceContents>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceContents&&(identical(other.units, units) || other.units == units)&&(identical(other.documents, documents) || other.documents == documents)&&(identical(other.bytes, bytes) || other.bytes == bytes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,units,documents,bytes);
}

@override
String toString() {
    return 'DeviceContents(units: $units, documents: $documents, bytes: $bytes)';
}


}

/// @nodoc
abstract mixin class _$DeviceContentsCopyWith<$Res> implements $DeviceContentsCopyWith<$Res> {
  factory _$DeviceContentsCopyWith(_DeviceContents value, $Res Function(_DeviceContents) _then) = __$DeviceContentsCopyWithImpl;
@override @useResult
$Res call({
 int units, int documents, int bytes
});




}
/// @nodoc
class __$DeviceContentsCopyWithImpl<$Res>
    implements _$DeviceContentsCopyWith<$Res> {
  __$DeviceContentsCopyWithImpl(this._self, this._then);

  final _DeviceContents _self;
  final $Res Function(_DeviceContents) _then;

/// Create a copy of DeviceContents
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? units = null,Object? documents = null,Object? bytes = null,}) {
  return _then(_DeviceContents(
units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as int,documents: null == documents ? _self.documents : documents // ignore: cast_nullable_to_non_nullable
as int,bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
