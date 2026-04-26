// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invite.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InvitedBy {

 String get uid; String get displayName;
/// Create a copy of InvitedBy
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvitedByCopyWith<InvitedBy> get copyWith => _$InvitedByCopyWithImpl<InvitedBy>(this as InvitedBy, _$identity);

  /// Serializes this InvitedBy to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvitedBy&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.displayName, displayName) || other.displayName == displayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,displayName);

@override
String toString() {
  return 'InvitedBy(uid: $uid, displayName: $displayName)';
}


}

/// @nodoc
abstract mixin class $InvitedByCopyWith<$Res>  {
  factory $InvitedByCopyWith(InvitedBy value, $Res Function(InvitedBy) _then) = _$InvitedByCopyWithImpl;
@useResult
$Res call({
 String uid, String displayName
});




}
/// @nodoc
class _$InvitedByCopyWithImpl<$Res>
    implements $InvitedByCopyWith<$Res> {
  _$InvitedByCopyWithImpl(this._self, this._then);

  final InvitedBy _self;
  final $Res Function(InvitedBy) _then;

/// Create a copy of InvitedBy
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? displayName = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [InvitedBy].
extension InvitedByPatterns on InvitedBy {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InvitedBy value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InvitedBy() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InvitedBy value)  $default,){
final _that = this;
switch (_that) {
case _InvitedBy():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InvitedBy value)?  $default,){
final _that = this;
switch (_that) {
case _InvitedBy() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String displayName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InvitedBy() when $default != null:
return $default(_that.uid,_that.displayName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String displayName)  $default,) {final _that = this;
switch (_that) {
case _InvitedBy():
return $default(_that.uid,_that.displayName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String displayName)?  $default,) {final _that = this;
switch (_that) {
case _InvitedBy() when $default != null:
return $default(_that.uid,_that.displayName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InvitedBy implements InvitedBy {
  const _InvitedBy({required this.uid, required this.displayName});
  factory _InvitedBy.fromJson(Map<String, dynamic> json) => _$InvitedByFromJson(json);

@override final  String uid;
@override final  String displayName;

/// Create a copy of InvitedBy
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvitedByCopyWith<_InvitedBy> get copyWith => __$InvitedByCopyWithImpl<_InvitedBy>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvitedByToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvitedBy&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.displayName, displayName) || other.displayName == displayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,displayName);

@override
String toString() {
  return 'InvitedBy(uid: $uid, displayName: $displayName)';
}


}

/// @nodoc
abstract mixin class _$InvitedByCopyWith<$Res> implements $InvitedByCopyWith<$Res> {
  factory _$InvitedByCopyWith(_InvitedBy value, $Res Function(_InvitedBy) _then) = __$InvitedByCopyWithImpl;
@override @useResult
$Res call({
 String uid, String displayName
});




}
/// @nodoc
class __$InvitedByCopyWithImpl<$Res>
    implements _$InvitedByCopyWith<$Res> {
  __$InvitedByCopyWithImpl(this._self, this._then);

  final _InvitedBy _self;
  final $Res Function(_InvitedBy) _then;

/// Create a copy of InvitedBy
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? displayName = null,}) {
  return _then(_InvitedBy(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Invite {

 String get id; String get email;// sempre lowercase
 String get extraId; String get extraName;// denorm
 MemberRole get role; InvitedBy get invitedBy; InviteStatus get status;@TimestampConverter() DateTime get createdAt;@TimestampConverter() DateTime get expiresAt;@NullableTimestampConverter() DateTime? get respondedAt;
/// Create a copy of Invite
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InviteCopyWith<Invite> get copyWith => _$InviteCopyWithImpl<Invite>(this as Invite, _$identity);

  /// Serializes this Invite to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Invite&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.extraId, extraId) || other.extraId == extraId)&&(identical(other.extraName, extraName) || other.extraName == extraName)&&(identical(other.role, role) || other.role == role)&&(identical(other.invitedBy, invitedBy) || other.invitedBy == invitedBy)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.respondedAt, respondedAt) || other.respondedAt == respondedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,extraId,extraName,role,invitedBy,status,createdAt,expiresAt,respondedAt);

@override
String toString() {
  return 'Invite(id: $id, email: $email, extraId: $extraId, extraName: $extraName, role: $role, invitedBy: $invitedBy, status: $status, createdAt: $createdAt, expiresAt: $expiresAt, respondedAt: $respondedAt)';
}


}

/// @nodoc
abstract mixin class $InviteCopyWith<$Res>  {
  factory $InviteCopyWith(Invite value, $Res Function(Invite) _then) = _$InviteCopyWithImpl;
@useResult
$Res call({
 String id, String email, String extraId, String extraName, MemberRole role, InvitedBy invitedBy, InviteStatus status,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime expiresAt,@NullableTimestampConverter() DateTime? respondedAt
});


$InvitedByCopyWith<$Res> get invitedBy;

}
/// @nodoc
class _$InviteCopyWithImpl<$Res>
    implements $InviteCopyWith<$Res> {
  _$InviteCopyWithImpl(this._self, this._then);

  final Invite _self;
  final $Res Function(Invite) _then;

/// Create a copy of Invite
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? extraId = null,Object? extraName = null,Object? role = null,Object? invitedBy = null,Object? status = null,Object? createdAt = null,Object? expiresAt = null,Object? respondedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,extraId: null == extraId ? _self.extraId : extraId // ignore: cast_nullable_to_non_nullable
as String,extraName: null == extraName ? _self.extraName : extraName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MemberRole,invitedBy: null == invitedBy ? _self.invitedBy : invitedBy // ignore: cast_nullable_to_non_nullable
as InvitedBy,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as InviteStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,respondedAt: freezed == respondedAt ? _self.respondedAt : respondedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Invite
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InvitedByCopyWith<$Res> get invitedBy {
  
  return $InvitedByCopyWith<$Res>(_self.invitedBy, (value) {
    return _then(_self.copyWith(invitedBy: value));
  });
}
}


/// Adds pattern-matching-related methods to [Invite].
extension InvitePatterns on Invite {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Invite value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Invite() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Invite value)  $default,){
final _that = this;
switch (_that) {
case _Invite():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Invite value)?  $default,){
final _that = this;
switch (_that) {
case _Invite() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String extraId,  String extraName,  MemberRole role,  InvitedBy invitedBy,  InviteStatus status, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime expiresAt, @NullableTimestampConverter()  DateTime? respondedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Invite() when $default != null:
return $default(_that.id,_that.email,_that.extraId,_that.extraName,_that.role,_that.invitedBy,_that.status,_that.createdAt,_that.expiresAt,_that.respondedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String extraId,  String extraName,  MemberRole role,  InvitedBy invitedBy,  InviteStatus status, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime expiresAt, @NullableTimestampConverter()  DateTime? respondedAt)  $default,) {final _that = this;
switch (_that) {
case _Invite():
return $default(_that.id,_that.email,_that.extraId,_that.extraName,_that.role,_that.invitedBy,_that.status,_that.createdAt,_that.expiresAt,_that.respondedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String extraId,  String extraName,  MemberRole role,  InvitedBy invitedBy,  InviteStatus status, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime expiresAt, @NullableTimestampConverter()  DateTime? respondedAt)?  $default,) {final _that = this;
switch (_that) {
case _Invite() when $default != null:
return $default(_that.id,_that.email,_that.extraId,_that.extraName,_that.role,_that.invitedBy,_that.status,_that.createdAt,_that.expiresAt,_that.respondedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Invite implements Invite {
  const _Invite({required this.id, required this.email, required this.extraId, required this.extraName, required this.role, required this.invitedBy, this.status = InviteStatus.pending, @TimestampConverter() required this.createdAt, @TimestampConverter() required this.expiresAt, @NullableTimestampConverter() this.respondedAt});
  factory _Invite.fromJson(Map<String, dynamic> json) => _$InviteFromJson(json);

@override final  String id;
@override final  String email;
// sempre lowercase
@override final  String extraId;
@override final  String extraName;
// denorm
@override final  MemberRole role;
@override final  InvitedBy invitedBy;
@override@JsonKey() final  InviteStatus status;
@override@TimestampConverter() final  DateTime createdAt;
@override@TimestampConverter() final  DateTime expiresAt;
@override@NullableTimestampConverter() final  DateTime? respondedAt;

/// Create a copy of Invite
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InviteCopyWith<_Invite> get copyWith => __$InviteCopyWithImpl<_Invite>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InviteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Invite&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.extraId, extraId) || other.extraId == extraId)&&(identical(other.extraName, extraName) || other.extraName == extraName)&&(identical(other.role, role) || other.role == role)&&(identical(other.invitedBy, invitedBy) || other.invitedBy == invitedBy)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.respondedAt, respondedAt) || other.respondedAt == respondedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,extraId,extraName,role,invitedBy,status,createdAt,expiresAt,respondedAt);

@override
String toString() {
  return 'Invite(id: $id, email: $email, extraId: $extraId, extraName: $extraName, role: $role, invitedBy: $invitedBy, status: $status, createdAt: $createdAt, expiresAt: $expiresAt, respondedAt: $respondedAt)';
}


}

/// @nodoc
abstract mixin class _$InviteCopyWith<$Res> implements $InviteCopyWith<$Res> {
  factory _$InviteCopyWith(_Invite value, $Res Function(_Invite) _then) = __$InviteCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String extraId, String extraName, MemberRole role, InvitedBy invitedBy, InviteStatus status,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime expiresAt,@NullableTimestampConverter() DateTime? respondedAt
});


@override $InvitedByCopyWith<$Res> get invitedBy;

}
/// @nodoc
class __$InviteCopyWithImpl<$Res>
    implements _$InviteCopyWith<$Res> {
  __$InviteCopyWithImpl(this._self, this._then);

  final _Invite _self;
  final $Res Function(_Invite) _then;

/// Create a copy of Invite
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? extraId = null,Object? extraName = null,Object? role = null,Object? invitedBy = null,Object? status = null,Object? createdAt = null,Object? expiresAt = null,Object? respondedAt = freezed,}) {
  return _then(_Invite(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,extraId: null == extraId ? _self.extraId : extraId // ignore: cast_nullable_to_non_nullable
as String,extraName: null == extraName ? _self.extraName : extraName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MemberRole,invitedBy: null == invitedBy ? _self.invitedBy : invitedBy // ignore: cast_nullable_to_non_nullable
as InvitedBy,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as InviteStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,respondedAt: freezed == respondedAt ? _self.respondedAt : respondedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Invite
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InvitedByCopyWith<$Res> get invitedBy {
  
  return $InvitedByCopyWith<$Res>(_self.invitedBy, (value) {
    return _then(_self.copyWith(invitedBy: value));
  });
}
}

// dart format on
