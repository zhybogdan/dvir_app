// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scope_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScopeSummary {

 Object get membership;



@override
bool operator ==(Object other) {
  final _this = this as ScopeSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScopeSummary&&const DeepCollectionEquality().equals(other.membership, _this.membership));
}


@override
int get hashCode {
  final _this = this as ScopeSummary;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.membership));
}

@override
String toString() {
  final _this = this as ScopeSummary;
  return 'ScopeSummary(membership: ${_this.membership})';
}


}

/// @nodoc
class $ScopeSummaryCopyWith<$Res>  {
$ScopeSummaryCopyWith(ScopeSummary _, $Res Function(ScopeSummary) __);
}


/// Adds pattern-matching-related methods to [ScopeSummary].
extension ScopeSummaryPatterns on ScopeSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CommunitySummary value)?  community,TResult Function( UnitSummary value)?  unit,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CommunitySummary() when community != null:
return community(_that);case UnitSummary() when unit != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CommunitySummary value)  community,required TResult Function( UnitSummary value)  unit,}){
final _that = this;
switch (_that) {
case CommunitySummary():
return community(_that);case UnitSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CommunitySummary value)?  community,TResult? Function( UnitSummary value)?  unit,}){
final _that = this;
switch (_that) {
case CommunitySummary() when community != null:
return community(_that);case UnitSummary() when unit != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( CommunityMembership membership,  Community? community)?  community,TResult Function( UnitMembership membership,  Unit? unit,  ScopeCounts? counts)?  unit,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CommunitySummary() when community != null:
return community(_that.membership,_that.community);case UnitSummary() when unit != null:
return unit(_that.membership,_that.unit,_that.counts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( CommunityMembership membership,  Community? community)  community,required TResult Function( UnitMembership membership,  Unit? unit,  ScopeCounts? counts)  unit,}) {final _that = this;
switch (_that) {
case CommunitySummary():
return community(_that.membership,_that.community);case UnitSummary():
return unit(_that.membership,_that.unit,_that.counts);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( CommunityMembership membership,  Community? community)?  community,TResult? Function( UnitMembership membership,  Unit? unit,  ScopeCounts? counts)?  unit,}) {final _that = this;
switch (_that) {
case CommunitySummary() when community != null:
return community(_that.membership,_that.community);case UnitSummary() when unit != null:
return unit(_that.membership,_that.unit,_that.counts);case _:
  return null;

}
}

}

/// @nodoc


class CommunitySummary extends ScopeSummary {
  const CommunitySummary({required this.membership, this.community}): super._();
  

@override final  CommunityMembership membership;
 final  Community? community;

/// Create a copy of ScopeSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommunitySummaryCopyWith<CommunitySummary> get copyWith => _$CommunitySummaryCopyWithImpl<CommunitySummary>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CommunitySummary&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.community, community) || other.community == community));
}


@override
int get hashCode {
    return Object.hash(runtimeType,membership,community);
}

@override
String toString() {
    return 'ScopeSummary.community(membership: $membership, community: $community)';
}


}

/// @nodoc
abstract mixin class $CommunitySummaryCopyWith<$Res> implements $ScopeSummaryCopyWith<$Res> {
  factory $CommunitySummaryCopyWith(CommunitySummary value, $Res Function(CommunitySummary) _then) = _$CommunitySummaryCopyWithImpl;
@useResult
$Res call({
 CommunityMembership membership, Community? community
});


$CommunityMembershipCopyWith<$Res> get membership;$CommunityCopyWith<$Res>? get community;

}
/// @nodoc
class _$CommunitySummaryCopyWithImpl<$Res>
    implements $CommunitySummaryCopyWith<$Res> {
  _$CommunitySummaryCopyWithImpl(this._self, this._then);

  final CommunitySummary _self;
  final $Res Function(CommunitySummary) _then;

/// Create a copy of ScopeSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? membership = null,Object? community = freezed,}) {
  return _then(CommunitySummary(
membership: null == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as CommunityMembership,community: freezed == community ? _self.community : community // ignore: cast_nullable_to_non_nullable
as Community?,
  ));
}

/// Create a copy of ScopeSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommunityMembershipCopyWith<$Res> get membership {
  
  return $CommunityMembershipCopyWith<$Res>(_self.membership, (value) {
    return _then(_self.copyWith(membership: value));
  });
}/// Create a copy of ScopeSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommunityCopyWith<$Res>? get community {
    if (_self.community == null) {
    return null;
  }

  return $CommunityCopyWith<$Res>(_self.community!, (value) {
    return _then(_self.copyWith(community: value));
  });
}
}

/// @nodoc


class UnitSummary extends ScopeSummary {
  const UnitSummary({required this.membership, this.unit, this.counts}): super._();
  

@override final  UnitMembership membership;
 final  Unit? unit;
 final  ScopeCounts? counts;

/// Create a copy of ScopeSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnitSummaryCopyWith<UnitSummary> get copyWith => _$UnitSummaryCopyWithImpl<UnitSummary>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is UnitSummary&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.counts, counts) || other.counts == counts));
}


@override
int get hashCode {
    return Object.hash(runtimeType,membership,unit,counts);
}

@override
String toString() {
    return 'ScopeSummary.unit(membership: $membership, unit: $unit, counts: $counts)';
}


}

/// @nodoc
abstract mixin class $UnitSummaryCopyWith<$Res> implements $ScopeSummaryCopyWith<$Res> {
  factory $UnitSummaryCopyWith(UnitSummary value, $Res Function(UnitSummary) _then) = _$UnitSummaryCopyWithImpl;
@useResult
$Res call({
 UnitMembership membership, Unit? unit, ScopeCounts? counts
});


$UnitMembershipCopyWith<$Res> get membership;$UnitCopyWith<$Res>? get unit;

}
/// @nodoc
class _$UnitSummaryCopyWithImpl<$Res>
    implements $UnitSummaryCopyWith<$Res> {
  _$UnitSummaryCopyWithImpl(this._self, this._then);

  final UnitSummary _self;
  final $Res Function(UnitSummary) _then;

/// Create a copy of ScopeSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? membership = null,Object? unit = freezed,Object? counts = freezed,}) {
  return _then(UnitSummary(
membership: null == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as UnitMembership,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as Unit?,counts: freezed == counts ? _self.counts : counts // ignore: cast_nullable_to_non_nullable
as ScopeCounts?,
  ));
}

/// Create a copy of ScopeSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UnitMembershipCopyWith<$Res> get membership {
  
  return $UnitMembershipCopyWith<$Res>(_self.membership, (value) {
    return _then(_self.copyWith(membership: value));
  });
}/// Create a copy of ScopeSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UnitCopyWith<$Res>? get unit {
    if (_self.unit == null) {
    return null;
  }

  return $UnitCopyWith<$Res>(_self.unit!, (value) {
    return _then(_self.copyWith(unit: value));
  });
}
}

// dart format on
