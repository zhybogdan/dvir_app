// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dv_toast.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DvToast {

 int get id; String get message; DvToastType get type; Duration get duration; String? get actionLabel; void Function()? get onAction;
/// Create a copy of DvToast
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DvToastCopyWith<DvToast> get copyWith => _$DvToastCopyWithImpl<DvToast>(this as DvToast, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DvToast&&(identical(other.id, id) || other.id == id)&&(identical(other.message, message) || other.message == message)&&(identical(other.type, type) || other.type == type)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.actionLabel, actionLabel) || other.actionLabel == actionLabel)&&(identical(other.onAction, onAction) || other.onAction == onAction));
}


@override
int get hashCode => Object.hash(runtimeType,id,message,type,duration,actionLabel,onAction);

@override
String toString() {
  return 'DvToast(id: $id, message: $message, type: $type, duration: $duration, actionLabel: $actionLabel, onAction: $onAction)';
}


}

/// @nodoc
abstract mixin class $DvToastCopyWith<$Res>  {
  factory $DvToastCopyWith(DvToast value, $Res Function(DvToast) _then) = _$DvToastCopyWithImpl;
@useResult
$Res call({
 int id, String message, DvToastType type, Duration duration, String? actionLabel, void Function()? onAction
});




}
/// @nodoc
class _$DvToastCopyWithImpl<$Res>
    implements $DvToastCopyWith<$Res> {
  _$DvToastCopyWithImpl(this._self, this._then);

  final DvToast _self;
  final $Res Function(DvToast) _then;

/// Create a copy of DvToast
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? message = null,Object? type = null,Object? duration = null,Object? actionLabel = freezed,Object? onAction = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DvToastType,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,actionLabel: freezed == actionLabel ? _self.actionLabel : actionLabel // ignore: cast_nullable_to_non_nullable
as String?,onAction: freezed == onAction ? _self.onAction : onAction // ignore: cast_nullable_to_non_nullable
as void Function()?,
  ));
}

}


/// Adds pattern-matching-related methods to [DvToast].
extension DvToastPatterns on DvToast {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DvToast value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DvToast() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DvToast value)  $default,){
final _that = this;
switch (_that) {
case _DvToast():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DvToast value)?  $default,){
final _that = this;
switch (_that) {
case _DvToast() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String message,  DvToastType type,  Duration duration,  String? actionLabel,  void Function()? onAction)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DvToast() when $default != null:
return $default(_that.id,_that.message,_that.type,_that.duration,_that.actionLabel,_that.onAction);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String message,  DvToastType type,  Duration duration,  String? actionLabel,  void Function()? onAction)  $default,) {final _that = this;
switch (_that) {
case _DvToast():
return $default(_that.id,_that.message,_that.type,_that.duration,_that.actionLabel,_that.onAction);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String message,  DvToastType type,  Duration duration,  String? actionLabel,  void Function()? onAction)?  $default,) {final _that = this;
switch (_that) {
case _DvToast() when $default != null:
return $default(_that.id,_that.message,_that.type,_that.duration,_that.actionLabel,_that.onAction);case _:
  return null;

}
}

}

/// @nodoc


class _DvToast implements DvToast {
  const _DvToast({required this.id, required this.message, this.type = DvToastType.info, this.duration = const Duration(seconds: 4), this.actionLabel, this.onAction});
  

@override final  int id;
@override final  String message;
@override@JsonKey() final  DvToastType type;
@override@JsonKey() final  Duration duration;
@override final  String? actionLabel;
@override final  void Function()? onAction;

/// Create a copy of DvToast
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DvToastCopyWith<_DvToast> get copyWith => __$DvToastCopyWithImpl<_DvToast>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DvToast&&(identical(other.id, id) || other.id == id)&&(identical(other.message, message) || other.message == message)&&(identical(other.type, type) || other.type == type)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.actionLabel, actionLabel) || other.actionLabel == actionLabel)&&(identical(other.onAction, onAction) || other.onAction == onAction));
}


@override
int get hashCode => Object.hash(runtimeType,id,message,type,duration,actionLabel,onAction);

@override
String toString() {
  return 'DvToast(id: $id, message: $message, type: $type, duration: $duration, actionLabel: $actionLabel, onAction: $onAction)';
}


}

/// @nodoc
abstract mixin class _$DvToastCopyWith<$Res> implements $DvToastCopyWith<$Res> {
  factory _$DvToastCopyWith(_DvToast value, $Res Function(_DvToast) _then) = __$DvToastCopyWithImpl;
@override @useResult
$Res call({
 int id, String message, DvToastType type, Duration duration, String? actionLabel, void Function()? onAction
});




}
/// @nodoc
class __$DvToastCopyWithImpl<$Res>
    implements _$DvToastCopyWith<$Res> {
  __$DvToastCopyWithImpl(this._self, this._then);

  final _DvToast _self;
  final $Res Function(_DvToast) _then;

/// Create a copy of DvToast
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? message = null,Object? type = null,Object? duration = null,Object? actionLabel = freezed,Object? onAction = freezed,}) {
  return _then(_DvToast(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DvToastType,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,actionLabel: freezed == actionLabel ? _self.actionLabel : actionLabel // ignore: cast_nullable_to_non_nullable
as String?,onAction: freezed == onAction ? _self.onAction : onAction // ignore: cast_nullable_to_non_nullable
as void Function()?,
  ));
}


}

// dart format on
