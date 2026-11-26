// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup_manifest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BackupManifest {

@JsonKey(name: 'format_version') int get formatVersion;@JsonKey(name: 'schema_version') int get schemaVersion;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'app_version') String get appVersion; int get units; int get attributes; int get documents; int get contacts;
/// Create a copy of BackupManifest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupManifestCopyWith<BackupManifest> get copyWith => _$BackupManifestCopyWithImpl<BackupManifest>(this as BackupManifest, _$identity);

  /// Serializes this BackupManifest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BackupManifest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupManifest&&(identical(other.formatVersion, _this.formatVersion) || other.formatVersion == _this.formatVersion)&&(identical(other.schemaVersion, _this.schemaVersion) || other.schemaVersion == _this.schemaVersion)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.appVersion, _this.appVersion) || other.appVersion == _this.appVersion)&&(identical(other.units, _this.units) || other.units == _this.units)&&(identical(other.attributes, _this.attributes) || other.attributes == _this.attributes)&&(identical(other.documents, _this.documents) || other.documents == _this.documents)&&(identical(other.contacts, _this.contacts) || other.contacts == _this.contacts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BackupManifest;
  return Object.hash(runtimeType,_this.formatVersion,_this.schemaVersion,_this.createdAt,_this.appVersion,_this.units,_this.attributes,_this.documents,_this.contacts);
}

@override
String toString() {
  final _this = this as BackupManifest;
  return 'BackupManifest(formatVersion: ${_this.formatVersion}, schemaVersion: ${_this.schemaVersion}, createdAt: ${_this.createdAt}, appVersion: ${_this.appVersion}, units: ${_this.units}, attributes: ${_this.attributes}, documents: ${_this.documents}, contacts: ${_this.contacts})';
}


}

/// @nodoc
abstract mixin class $BackupManifestCopyWith<$Res>  {
  factory $BackupManifestCopyWith(BackupManifest value, $Res Function(BackupManifest) _then) = _$BackupManifestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'format_version') int formatVersion,@JsonKey(name: 'schema_version') int schemaVersion,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'app_version') String appVersion, int units, int attributes, int documents, int contacts
});




}
/// @nodoc
class _$BackupManifestCopyWithImpl<$Res>
    implements $BackupManifestCopyWith<$Res> {
  _$BackupManifestCopyWithImpl(this._self, this._then);

  final BackupManifest _self;
  final $Res Function(BackupManifest) _then;

/// Create a copy of BackupManifest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? formatVersion = null,Object? schemaVersion = null,Object? createdAt = null,Object? appVersion = null,Object? units = null,Object? attributes = null,Object? documents = null,Object? contacts = null,}) {
  return _then(BackupManifest(
formatVersion: null == formatVersion ? _self.formatVersion : formatVersion // ignore: cast_nullable_to_non_nullable
as int,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as int,attributes: null == attributes ? _self.attributes : attributes // ignore: cast_nullable_to_non_nullable
as int,documents: null == documents ? _self.documents : documents // ignore: cast_nullable_to_non_nullable
as int,contacts: null == contacts ? _self.contacts : contacts // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BackupManifest].
extension BackupManifestPatterns on BackupManifest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackupManifest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackupManifest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackupManifest value)  $default,){
final _that = this;
switch (_that) {
case _BackupManifest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackupManifest value)?  $default,){
final _that = this;
switch (_that) {
case _BackupManifest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'format_version')  int formatVersion, @JsonKey(name: 'schema_version')  int schemaVersion, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'app_version')  String appVersion,  int units,  int attributes,  int documents,  int contacts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackupManifest() when $default != null:
return $default(_that.formatVersion,_that.schemaVersion,_that.createdAt,_that.appVersion,_that.units,_that.attributes,_that.documents,_that.contacts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'format_version')  int formatVersion, @JsonKey(name: 'schema_version')  int schemaVersion, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'app_version')  String appVersion,  int units,  int attributes,  int documents,  int contacts)  $default,) {final _that = this;
switch (_that) {
case _BackupManifest():
return $default(_that.formatVersion,_that.schemaVersion,_that.createdAt,_that.appVersion,_that.units,_that.attributes,_that.documents,_that.contacts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'format_version')  int formatVersion, @JsonKey(name: 'schema_version')  int schemaVersion, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'app_version')  String appVersion,  int units,  int attributes,  int documents,  int contacts)?  $default,) {final _that = this;
switch (_that) {
case _BackupManifest() when $default != null:
return $default(_that.formatVersion,_that.schemaVersion,_that.createdAt,_that.appVersion,_that.units,_that.attributes,_that.documents,_that.contacts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BackupManifest implements BackupManifest {
  const _BackupManifest({@JsonKey(name: 'format_version') required this.formatVersion, @JsonKey(name: 'schema_version') required this.schemaVersion, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'app_version') required this.appVersion, required this.units, required this.attributes, required this.documents, required this.contacts});
  factory _BackupManifest.fromJson(Map<String, dynamic> json) => _$BackupManifestFromJson(json);

@override@JsonKey(name: 'format_version') final  int formatVersion;
@override@JsonKey(name: 'schema_version') final  int schemaVersion;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'app_version') final  String appVersion;
@override final  int units;
@override final  int attributes;
@override final  int documents;
@override final  int contacts;

/// Create a copy of BackupManifest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupManifestCopyWith<_BackupManifest> get copyWith => __$BackupManifestCopyWithImpl<_BackupManifest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BackupManifestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackupManifest&&(identical(other.formatVersion, formatVersion) || other.formatVersion == formatVersion)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.units, units) || other.units == units)&&(identical(other.attributes, attributes) || other.attributes == attributes)&&(identical(other.documents, documents) || other.documents == documents)&&(identical(other.contacts, contacts) || other.contacts == contacts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,formatVersion,schemaVersion,createdAt,appVersion,units,attributes,documents,contacts);
}

@override
String toString() {
    return 'BackupManifest(formatVersion: $formatVersion, schemaVersion: $schemaVersion, createdAt: $createdAt, appVersion: $appVersion, units: $units, attributes: $attributes, documents: $documents, contacts: $contacts)';
}


}

/// @nodoc
abstract mixin class _$BackupManifestCopyWith<$Res> implements $BackupManifestCopyWith<$Res> {
  factory _$BackupManifestCopyWith(_BackupManifest value, $Res Function(_BackupManifest) _then) = __$BackupManifestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'format_version') int formatVersion,@JsonKey(name: 'schema_version') int schemaVersion,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'app_version') String appVersion, int units, int attributes, int documents, int contacts
});




}
/// @nodoc
class __$BackupManifestCopyWithImpl<$Res>
    implements _$BackupManifestCopyWith<$Res> {
  __$BackupManifestCopyWithImpl(this._self, this._then);

  final _BackupManifest _self;
  final $Res Function(_BackupManifest) _then;

/// Create a copy of BackupManifest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? formatVersion = null,Object? schemaVersion = null,Object? createdAt = null,Object? appVersion = null,Object? units = null,Object? attributes = null,Object? documents = null,Object? contacts = null,}) {
  return _then(_BackupManifest(
formatVersion: null == formatVersion ? _self.formatVersion : formatVersion // ignore: cast_nullable_to_non_nullable
as int,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as int,attributes: null == attributes ? _self.attributes : attributes // ignore: cast_nullable_to_non_nullable
as int,documents: null == documents ? _self.documents : documents // ignore: cast_nullable_to_non_nullable
as int,contacts: null == contacts ? _self.contacts : contacts // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
