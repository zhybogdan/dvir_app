// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Document {

 String get id; String get title;@JsonKey(name: 'storage_path') String get storagePath;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'mime_type') String? get mimeType;@JsonKey(name: 'size_bytes') int? get sizeBytes;@JsonKey(name: 'original_name') String? get originalName;
/// Create a copy of Document
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentCopyWith<Document> get copyWith => _$DocumentCopyWithImpl<Document>(this as Document, _$identity);

  /// Serializes this Document to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Document&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.storagePath, storagePath) || other.storagePath == storagePath)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.originalName, originalName) || other.originalName == originalName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,storagePath,createdAt,mimeType,sizeBytes,originalName);

@override
String toString() {
  return 'Document(id: $id, title: $title, storagePath: $storagePath, createdAt: $createdAt, mimeType: $mimeType, sizeBytes: $sizeBytes, originalName: $originalName)';
}


}

/// @nodoc
abstract mixin class $DocumentCopyWith<$Res>  {
  factory $DocumentCopyWith(Document value, $Res Function(Document) _then) = _$DocumentCopyWithImpl;
@useResult
$Res call({
 String id, String title,@JsonKey(name: 'storage_path') String storagePath,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'mime_type') String? mimeType,@JsonKey(name: 'size_bytes') int? sizeBytes,@JsonKey(name: 'original_name') String? originalName
});




}
/// @nodoc
class _$DocumentCopyWithImpl<$Res>
    implements $DocumentCopyWith<$Res> {
  _$DocumentCopyWithImpl(this._self, this._then);

  final Document _self;
  final $Res Function(Document) _then;

/// Create a copy of Document
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? storagePath = null,Object? createdAt = null,Object? mimeType = freezed,Object? sizeBytes = freezed,Object? originalName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,storagePath: null == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,sizeBytes: freezed == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int?,originalName: freezed == originalName ? _self.originalName : originalName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Document].
extension DocumentPatterns on Document {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Document value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Document() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Document value)  $default,){
final _that = this;
switch (_that) {
case _Document():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Document value)?  $default,){
final _that = this;
switch (_that) {
case _Document() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title, @JsonKey(name: 'storage_path')  String storagePath, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'mime_type')  String? mimeType, @JsonKey(name: 'size_bytes')  int? sizeBytes, @JsonKey(name: 'original_name')  String? originalName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Document() when $default != null:
return $default(_that.id,_that.title,_that.storagePath,_that.createdAt,_that.mimeType,_that.sizeBytes,_that.originalName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title, @JsonKey(name: 'storage_path')  String storagePath, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'mime_type')  String? mimeType, @JsonKey(name: 'size_bytes')  int? sizeBytes, @JsonKey(name: 'original_name')  String? originalName)  $default,) {final _that = this;
switch (_that) {
case _Document():
return $default(_that.id,_that.title,_that.storagePath,_that.createdAt,_that.mimeType,_that.sizeBytes,_that.originalName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title, @JsonKey(name: 'storage_path')  String storagePath, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'mime_type')  String? mimeType, @JsonKey(name: 'size_bytes')  int? sizeBytes, @JsonKey(name: 'original_name')  String? originalName)?  $default,) {final _that = this;
switch (_that) {
case _Document() when $default != null:
return $default(_that.id,_that.title,_that.storagePath,_that.createdAt,_that.mimeType,_that.sizeBytes,_that.originalName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Document implements Document {
  const _Document({required this.id, required this.title, @JsonKey(name: 'storage_path') required this.storagePath, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'mime_type') this.mimeType, @JsonKey(name: 'size_bytes') this.sizeBytes, @JsonKey(name: 'original_name') this.originalName});
  factory _Document.fromJson(Map<String, dynamic> json) => _$DocumentFromJson(json);

@override final  String id;
@override final  String title;
@override@JsonKey(name: 'storage_path') final  String storagePath;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'mime_type') final  String? mimeType;
@override@JsonKey(name: 'size_bytes') final  int? sizeBytes;
@override@JsonKey(name: 'original_name') final  String? originalName;

/// Create a copy of Document
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocumentCopyWith<_Document> get copyWith => __$DocumentCopyWithImpl<_Document>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DocumentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Document&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.storagePath, storagePath) || other.storagePath == storagePath)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.originalName, originalName) || other.originalName == originalName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,storagePath,createdAt,mimeType,sizeBytes,originalName);

@override
String toString() {
  return 'Document(id: $id, title: $title, storagePath: $storagePath, createdAt: $createdAt, mimeType: $mimeType, sizeBytes: $sizeBytes, originalName: $originalName)';
}


}

/// @nodoc
abstract mixin class _$DocumentCopyWith<$Res> implements $DocumentCopyWith<$Res> {
  factory _$DocumentCopyWith(_Document value, $Res Function(_Document) _then) = __$DocumentCopyWithImpl;
@override @useResult
$Res call({
 String id, String title,@JsonKey(name: 'storage_path') String storagePath,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'mime_type') String? mimeType,@JsonKey(name: 'size_bytes') int? sizeBytes,@JsonKey(name: 'original_name') String? originalName
});




}
/// @nodoc
class __$DocumentCopyWithImpl<$Res>
    implements _$DocumentCopyWith<$Res> {
  __$DocumentCopyWithImpl(this._self, this._then);

  final _Document _self;
  final $Res Function(_Document) _then;

/// Create a copy of Document
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? storagePath = null,Object? createdAt = null,Object? mimeType = freezed,Object? sizeBytes = freezed,Object? originalName = freezed,}) {
  return _then(_Document(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,storagePath: null == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,sizeBytes: freezed == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int?,originalName: freezed == originalName ? _self.originalName : originalName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
