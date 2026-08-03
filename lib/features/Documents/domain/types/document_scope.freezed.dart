// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_scope.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DocumentScope {

 String get id;
/// Create a copy of DocumentScope
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentScopeCopyWith<DocumentScope> get copyWith => _$DocumentScopeCopyWithImpl<DocumentScope>(this as DocumentScope, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentScope&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'DocumentScope(id: $id)';
}


}

/// @nodoc
abstract mixin class $DocumentScopeCopyWith<$Res>  {
  factory $DocumentScopeCopyWith(DocumentScope value, $Res Function(DocumentScope) _then) = _$DocumentScopeCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$DocumentScopeCopyWithImpl<$Res>
    implements $DocumentScopeCopyWith<$Res> {
  _$DocumentScopeCopyWithImpl(this._self, this._then);

  final DocumentScope _self;
  final $Res Function(DocumentScope) _then;

/// Create a copy of DocumentScope
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DocumentScope].
extension DocumentScopePatterns on DocumentScope {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( UnitDocuments value)?  unit,TResult Function( CommunityDocuments value)?  community,required TResult orElse(),}){
final _that = this;
switch (_that) {
case UnitDocuments() when unit != null:
return unit(_that);case CommunityDocuments() when community != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( UnitDocuments value)  unit,required TResult Function( CommunityDocuments value)  community,}){
final _that = this;
switch (_that) {
case UnitDocuments():
return unit(_that);case CommunityDocuments():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( UnitDocuments value)?  unit,TResult? Function( CommunityDocuments value)?  community,}){
final _that = this;
switch (_that) {
case UnitDocuments() when unit != null:
return unit(_that);case CommunityDocuments() when community != null:
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
case UnitDocuments() when unit != null:
return unit(_that.id);case CommunityDocuments() when community != null:
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
case UnitDocuments():
return unit(_that.id);case CommunityDocuments():
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
case UnitDocuments() when unit != null:
return unit(_that.id);case CommunityDocuments() when community != null:
return community(_that.id);case _:
  return null;

}
}

}

/// @nodoc


class UnitDocuments extends DocumentScope {
  const UnitDocuments(this.id): super._();
  

@override final  String id;

/// Create a copy of DocumentScope
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnitDocumentsCopyWith<UnitDocuments> get copyWith => _$UnitDocumentsCopyWithImpl<UnitDocuments>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnitDocuments&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'DocumentScope.unit(id: $id)';
}


}

/// @nodoc
abstract mixin class $UnitDocumentsCopyWith<$Res> implements $DocumentScopeCopyWith<$Res> {
  factory $UnitDocumentsCopyWith(UnitDocuments value, $Res Function(UnitDocuments) _then) = _$UnitDocumentsCopyWithImpl;
@override @useResult
$Res call({
 String id
});




}
/// @nodoc
class _$UnitDocumentsCopyWithImpl<$Res>
    implements $UnitDocumentsCopyWith<$Res> {
  _$UnitDocumentsCopyWithImpl(this._self, this._then);

  final UnitDocuments _self;
  final $Res Function(UnitDocuments) _then;

/// Create a copy of DocumentScope
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(UnitDocuments(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class CommunityDocuments extends DocumentScope {
  const CommunityDocuments(this.id): super._();
  

@override final  String id;

/// Create a copy of DocumentScope
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommunityDocumentsCopyWith<CommunityDocuments> get copyWith => _$CommunityDocumentsCopyWithImpl<CommunityDocuments>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommunityDocuments&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'DocumentScope.community(id: $id)';
}


}

/// @nodoc
abstract mixin class $CommunityDocumentsCopyWith<$Res> implements $DocumentScopeCopyWith<$Res> {
  factory $CommunityDocumentsCopyWith(CommunityDocuments value, $Res Function(CommunityDocuments) _then) = _$CommunityDocumentsCopyWithImpl;
@override @useResult
$Res call({
 String id
});




}
/// @nodoc
class _$CommunityDocumentsCopyWithImpl<$Res>
    implements $CommunityDocumentsCopyWith<$Res> {
  _$CommunityDocumentsCopyWithImpl(this._self, this._then);

  final CommunityDocuments _self;
  final $Res Function(CommunityDocuments) _then;

/// Create a copy of DocumentScope
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(CommunityDocuments(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
