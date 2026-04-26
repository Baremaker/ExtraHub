// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'extra.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Extra {

 String get id; String get name; String? get description; ExtraCategory get category; String get university; String get ownerId; int get memberCount; int get projectCount;@TimestampConverter() DateTime get createdAt;@TimestampConverter() DateTime get updatedAt;
/// Create a copy of Extra
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExtraCopyWith<Extra> get copyWith => _$ExtraCopyWithImpl<Extra>(this as Extra, _$identity);

  /// Serializes this Extra to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Extra&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.university, university) || other.university == university)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&(identical(other.projectCount, projectCount) || other.projectCount == projectCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,category,university,ownerId,memberCount,projectCount,createdAt,updatedAt);

@override
String toString() {
  return 'Extra(id: $id, name: $name, description: $description, category: $category, university: $university, ownerId: $ownerId, memberCount: $memberCount, projectCount: $projectCount, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ExtraCopyWith<$Res>  {
  factory $ExtraCopyWith(Extra value, $Res Function(Extra) _then) = _$ExtraCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, ExtraCategory category, String university, String ownerId, int memberCount, int projectCount,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt
});




}
/// @nodoc
class _$ExtraCopyWithImpl<$Res>
    implements $ExtraCopyWith<$Res> {
  _$ExtraCopyWithImpl(this._self, this._then);

  final Extra _self;
  final $Res Function(Extra) _then;

/// Create a copy of Extra
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? category = null,Object? university = null,Object? ownerId = null,Object? memberCount = null,Object? projectCount = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ExtraCategory,university: null == university ? _self.university : university // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,projectCount: null == projectCount ? _self.projectCount : projectCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Extra].
extension ExtraPatterns on Extra {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Extra value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Extra() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Extra value)  $default,){
final _that = this;
switch (_that) {
case _Extra():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Extra value)?  $default,){
final _that = this;
switch (_that) {
case _Extra() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  ExtraCategory category,  String university,  String ownerId,  int memberCount,  int projectCount, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Extra() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.category,_that.university,_that.ownerId,_that.memberCount,_that.projectCount,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  ExtraCategory category,  String university,  String ownerId,  int memberCount,  int projectCount, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Extra():
return $default(_that.id,_that.name,_that.description,_that.category,_that.university,_that.ownerId,_that.memberCount,_that.projectCount,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  ExtraCategory category,  String university,  String ownerId,  int memberCount,  int projectCount, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Extra() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.category,_that.university,_that.ownerId,_that.memberCount,_that.projectCount,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Extra implements Extra {
  const _Extra({required this.id, required this.name, this.description = null, required this.category, this.university = 'USP - São Carlos', required this.ownerId, this.memberCount = 0, this.projectCount = 0, @TimestampConverter() required this.createdAt, @TimestampConverter() required this.updatedAt});
  factory _Extra.fromJson(Map<String, dynamic> json) => _$ExtraFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  String? description;
@override final  ExtraCategory category;
@override@JsonKey() final  String university;
@override final  String ownerId;
@override@JsonKey() final  int memberCount;
@override@JsonKey() final  int projectCount;
@override@TimestampConverter() final  DateTime createdAt;
@override@TimestampConverter() final  DateTime updatedAt;

/// Create a copy of Extra
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExtraCopyWith<_Extra> get copyWith => __$ExtraCopyWithImpl<_Extra>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExtraToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Extra&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.university, university) || other.university == university)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&(identical(other.projectCount, projectCount) || other.projectCount == projectCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,category,university,ownerId,memberCount,projectCount,createdAt,updatedAt);

@override
String toString() {
  return 'Extra(id: $id, name: $name, description: $description, category: $category, university: $university, ownerId: $ownerId, memberCount: $memberCount, projectCount: $projectCount, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ExtraCopyWith<$Res> implements $ExtraCopyWith<$Res> {
  factory _$ExtraCopyWith(_Extra value, $Res Function(_Extra) _then) = __$ExtraCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, ExtraCategory category, String university, String ownerId, int memberCount, int projectCount,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt
});




}
/// @nodoc
class __$ExtraCopyWithImpl<$Res>
    implements _$ExtraCopyWith<$Res> {
  __$ExtraCopyWithImpl(this._self, this._then);

  final _Extra _self;
  final $Res Function(_Extra) _then;

/// Create a copy of Extra
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? category = null,Object? university = null,Object? ownerId = null,Object? memberCount = null,Object? projectCount = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Extra(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ExtraCategory,university: null == university ? _self.university : university // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,projectCount: null == projectCount ? _self.projectCount : projectCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
