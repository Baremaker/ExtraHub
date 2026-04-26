// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Member {

 String get uid; String get email; String get displayName; String? get photoURL; MemberRole get role; bool get isOwner; MemberStatus get status; String? get position;@TimestampConverter() DateTime get joinedAt;@NullableTimestampConverter() DateTime? get leftAt; List<String> get inProjectIds;
/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberCopyWith<Member> get copyWith => _$MemberCopyWithImpl<Member>(this as Member, _$identity);

  /// Serializes this Member to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Member&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.photoURL, photoURL) || other.photoURL == photoURL)&&(identical(other.role, role) || other.role == role)&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner)&&(identical(other.status, status) || other.status == status)&&(identical(other.position, position) || other.position == position)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.leftAt, leftAt) || other.leftAt == leftAt)&&const DeepCollectionEquality().equals(other.inProjectIds, inProjectIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,email,displayName,photoURL,role,isOwner,status,position,joinedAt,leftAt,const DeepCollectionEquality().hash(inProjectIds));

@override
String toString() {
  return 'Member(uid: $uid, email: $email, displayName: $displayName, photoURL: $photoURL, role: $role, isOwner: $isOwner, status: $status, position: $position, joinedAt: $joinedAt, leftAt: $leftAt, inProjectIds: $inProjectIds)';
}


}

/// @nodoc
abstract mixin class $MemberCopyWith<$Res>  {
  factory $MemberCopyWith(Member value, $Res Function(Member) _then) = _$MemberCopyWithImpl;
@useResult
$Res call({
 String uid, String email, String displayName, String? photoURL, MemberRole role, bool isOwner, MemberStatus status, String? position,@TimestampConverter() DateTime joinedAt,@NullableTimestampConverter() DateTime? leftAt, List<String> inProjectIds
});




}
/// @nodoc
class _$MemberCopyWithImpl<$Res>
    implements $MemberCopyWith<$Res> {
  _$MemberCopyWithImpl(this._self, this._then);

  final Member _self;
  final $Res Function(Member) _then;

/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? email = null,Object? displayName = null,Object? photoURL = freezed,Object? role = null,Object? isOwner = null,Object? status = null,Object? position = freezed,Object? joinedAt = null,Object? leftAt = freezed,Object? inProjectIds = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,photoURL: freezed == photoURL ? _self.photoURL : photoURL // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MemberRole,isOwner: null == isOwner ? _self.isOwner : isOwner // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MemberStatus,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String?,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,leftAt: freezed == leftAt ? _self.leftAt : leftAt // ignore: cast_nullable_to_non_nullable
as DateTime?,inProjectIds: null == inProjectIds ? _self.inProjectIds : inProjectIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Member].
extension MemberPatterns on Member {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Member value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Member() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Member value)  $default,){
final _that = this;
switch (_that) {
case _Member():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Member value)?  $default,){
final _that = this;
switch (_that) {
case _Member() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String email,  String displayName,  String? photoURL,  MemberRole role,  bool isOwner,  MemberStatus status,  String? position, @TimestampConverter()  DateTime joinedAt, @NullableTimestampConverter()  DateTime? leftAt,  List<String> inProjectIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Member() when $default != null:
return $default(_that.uid,_that.email,_that.displayName,_that.photoURL,_that.role,_that.isOwner,_that.status,_that.position,_that.joinedAt,_that.leftAt,_that.inProjectIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String email,  String displayName,  String? photoURL,  MemberRole role,  bool isOwner,  MemberStatus status,  String? position, @TimestampConverter()  DateTime joinedAt, @NullableTimestampConverter()  DateTime? leftAt,  List<String> inProjectIds)  $default,) {final _that = this;
switch (_that) {
case _Member():
return $default(_that.uid,_that.email,_that.displayName,_that.photoURL,_that.role,_that.isOwner,_that.status,_that.position,_that.joinedAt,_that.leftAt,_that.inProjectIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String email,  String displayName,  String? photoURL,  MemberRole role,  bool isOwner,  MemberStatus status,  String? position, @TimestampConverter()  DateTime joinedAt, @NullableTimestampConverter()  DateTime? leftAt,  List<String> inProjectIds)?  $default,) {final _that = this;
switch (_that) {
case _Member() when $default != null:
return $default(_that.uid,_that.email,_that.displayName,_that.photoURL,_that.role,_that.isOwner,_that.status,_that.position,_that.joinedAt,_that.leftAt,_that.inProjectIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Member implements Member {
  const _Member({required this.uid, required this.email, required this.displayName, this.photoURL = null, required this.role, this.isOwner = false, this.status = MemberStatus.active, this.position = null, @TimestampConverter() required this.joinedAt, @NullableTimestampConverter() this.leftAt, final  List<String> inProjectIds = const <String>[]}): _inProjectIds = inProjectIds;
  factory _Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);

@override final  String uid;
@override final  String email;
@override final  String displayName;
@override@JsonKey() final  String? photoURL;
@override final  MemberRole role;
@override@JsonKey() final  bool isOwner;
@override@JsonKey() final  MemberStatus status;
@override@JsonKey() final  String? position;
@override@TimestampConverter() final  DateTime joinedAt;
@override@NullableTimestampConverter() final  DateTime? leftAt;
 final  List<String> _inProjectIds;
@override@JsonKey() List<String> get inProjectIds {
  if (_inProjectIds is EqualUnmodifiableListView) return _inProjectIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_inProjectIds);
}


/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberCopyWith<_Member> get copyWith => __$MemberCopyWithImpl<_Member>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemberToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Member&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.photoURL, photoURL) || other.photoURL == photoURL)&&(identical(other.role, role) || other.role == role)&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner)&&(identical(other.status, status) || other.status == status)&&(identical(other.position, position) || other.position == position)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.leftAt, leftAt) || other.leftAt == leftAt)&&const DeepCollectionEquality().equals(other._inProjectIds, _inProjectIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,email,displayName,photoURL,role,isOwner,status,position,joinedAt,leftAt,const DeepCollectionEquality().hash(_inProjectIds));

@override
String toString() {
  return 'Member(uid: $uid, email: $email, displayName: $displayName, photoURL: $photoURL, role: $role, isOwner: $isOwner, status: $status, position: $position, joinedAt: $joinedAt, leftAt: $leftAt, inProjectIds: $inProjectIds)';
}


}

/// @nodoc
abstract mixin class _$MemberCopyWith<$Res> implements $MemberCopyWith<$Res> {
  factory _$MemberCopyWith(_Member value, $Res Function(_Member) _then) = __$MemberCopyWithImpl;
@override @useResult
$Res call({
 String uid, String email, String displayName, String? photoURL, MemberRole role, bool isOwner, MemberStatus status, String? position,@TimestampConverter() DateTime joinedAt,@NullableTimestampConverter() DateTime? leftAt, List<String> inProjectIds
});




}
/// @nodoc
class __$MemberCopyWithImpl<$Res>
    implements _$MemberCopyWith<$Res> {
  __$MemberCopyWithImpl(this._self, this._then);

  final _Member _self;
  final $Res Function(_Member) _then;

/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? email = null,Object? displayName = null,Object? photoURL = freezed,Object? role = null,Object? isOwner = null,Object? status = null,Object? position = freezed,Object? joinedAt = null,Object? leftAt = freezed,Object? inProjectIds = null,}) {
  return _then(_Member(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,photoURL: freezed == photoURL ? _self.photoURL : photoURL // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MemberRole,isOwner: null == isOwner ? _self.isOwner : isOwner // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MemberStatus,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String?,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,leftAt: freezed == leftAt ? _self.leftAt : leftAt // ignore: cast_nullable_to_non_nullable
as DateTime?,inProjectIds: null == inProjectIds ? _self._inProjectIds : inProjectIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
