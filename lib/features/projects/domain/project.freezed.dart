// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectMemberRef {

 String get uid; String get displayName; String? get photoURL;
/// Create a copy of ProjectMemberRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectMemberRefCopyWith<ProjectMemberRef> get copyWith => _$ProjectMemberRefCopyWithImpl<ProjectMemberRef>(this as ProjectMemberRef, _$identity);

  /// Serializes this ProjectMemberRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectMemberRef&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.photoURL, photoURL) || other.photoURL == photoURL));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,displayName,photoURL);

@override
String toString() {
  return 'ProjectMemberRef(uid: $uid, displayName: $displayName, photoURL: $photoURL)';
}


}

/// @nodoc
abstract mixin class $ProjectMemberRefCopyWith<$Res>  {
  factory $ProjectMemberRefCopyWith(ProjectMemberRef value, $Res Function(ProjectMemberRef) _then) = _$ProjectMemberRefCopyWithImpl;
@useResult
$Res call({
 String uid, String displayName, String? photoURL
});




}
/// @nodoc
class _$ProjectMemberRefCopyWithImpl<$Res>
    implements $ProjectMemberRefCopyWith<$Res> {
  _$ProjectMemberRefCopyWithImpl(this._self, this._then);

  final ProjectMemberRef _self;
  final $Res Function(ProjectMemberRef) _then;

/// Create a copy of ProjectMemberRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? displayName = null,Object? photoURL = freezed,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,photoURL: freezed == photoURL ? _self.photoURL : photoURL // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectMemberRef].
extension ProjectMemberRefPatterns on ProjectMemberRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectMemberRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectMemberRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectMemberRef value)  $default,){
final _that = this;
switch (_that) {
case _ProjectMemberRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectMemberRef value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectMemberRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String displayName,  String? photoURL)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectMemberRef() when $default != null:
return $default(_that.uid,_that.displayName,_that.photoURL);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String displayName,  String? photoURL)  $default,) {final _that = this;
switch (_that) {
case _ProjectMemberRef():
return $default(_that.uid,_that.displayName,_that.photoURL);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String displayName,  String? photoURL)?  $default,) {final _that = this;
switch (_that) {
case _ProjectMemberRef() when $default != null:
return $default(_that.uid,_that.displayName,_that.photoURL);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectMemberRef implements ProjectMemberRef {
  const _ProjectMemberRef({required this.uid, required this.displayName, this.photoURL = null});
  factory _ProjectMemberRef.fromJson(Map<String, dynamic> json) => _$ProjectMemberRefFromJson(json);

@override final  String uid;
@override final  String displayName;
@override@JsonKey() final  String? photoURL;

/// Create a copy of ProjectMemberRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectMemberRefCopyWith<_ProjectMemberRef> get copyWith => __$ProjectMemberRefCopyWithImpl<_ProjectMemberRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectMemberRefToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectMemberRef&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.photoURL, photoURL) || other.photoURL == photoURL));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,displayName,photoURL);

@override
String toString() {
  return 'ProjectMemberRef(uid: $uid, displayName: $displayName, photoURL: $photoURL)';
}


}

/// @nodoc
abstract mixin class _$ProjectMemberRefCopyWith<$Res> implements $ProjectMemberRefCopyWith<$Res> {
  factory _$ProjectMemberRefCopyWith(_ProjectMemberRef value, $Res Function(_ProjectMemberRef) _then) = __$ProjectMemberRefCopyWithImpl;
@override @useResult
$Res call({
 String uid, String displayName, String? photoURL
});




}
/// @nodoc
class __$ProjectMemberRefCopyWithImpl<$Res>
    implements _$ProjectMemberRefCopyWith<$Res> {
  __$ProjectMemberRefCopyWithImpl(this._self, this._then);

  final _ProjectMemberRef _self;
  final $Res Function(_ProjectMemberRef) _then;

/// Create a copy of ProjectMemberRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? displayName = null,Object? photoURL = freezed,}) {
  return _then(_ProjectMemberRef(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,photoURL: freezed == photoURL ? _self.photoURL : photoURL // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ProjectLink {

 String get label; String get url;
/// Create a copy of ProjectLink
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectLinkCopyWith<ProjectLink> get copyWith => _$ProjectLinkCopyWithImpl<ProjectLink>(this as ProjectLink, _$identity);

  /// Serializes this ProjectLink to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectLink&&(identical(other.label, label) || other.label == label)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,url);

@override
String toString() {
  return 'ProjectLink(label: $label, url: $url)';
}


}

/// @nodoc
abstract mixin class $ProjectLinkCopyWith<$Res>  {
  factory $ProjectLinkCopyWith(ProjectLink value, $Res Function(ProjectLink) _then) = _$ProjectLinkCopyWithImpl;
@useResult
$Res call({
 String label, String url
});




}
/// @nodoc
class _$ProjectLinkCopyWithImpl<$Res>
    implements $ProjectLinkCopyWith<$Res> {
  _$ProjectLinkCopyWithImpl(this._self, this._then);

  final ProjectLink _self;
  final $Res Function(ProjectLink) _then;

/// Create a copy of ProjectLink
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? url = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectLink].
extension ProjectLinkPatterns on ProjectLink {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectLink value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectLink() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectLink value)  $default,){
final _that = this;
switch (_that) {
case _ProjectLink():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectLink value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectLink() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  String url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectLink() when $default != null:
return $default(_that.label,_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  String url)  $default,) {final _that = this;
switch (_that) {
case _ProjectLink():
return $default(_that.label,_that.url);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  String url)?  $default,) {final _that = this;
switch (_that) {
case _ProjectLink() when $default != null:
return $default(_that.label,_that.url);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectLink implements ProjectLink {
  const _ProjectLink({required this.label, required this.url});
  factory _ProjectLink.fromJson(Map<String, dynamic> json) => _$ProjectLinkFromJson(json);

@override final  String label;
@override final  String url;

/// Create a copy of ProjectLink
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectLinkCopyWith<_ProjectLink> get copyWith => __$ProjectLinkCopyWithImpl<_ProjectLink>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectLinkToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectLink&&(identical(other.label, label) || other.label == label)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,url);

@override
String toString() {
  return 'ProjectLink(label: $label, url: $url)';
}


}

/// @nodoc
abstract mixin class _$ProjectLinkCopyWith<$Res> implements $ProjectLinkCopyWith<$Res> {
  factory _$ProjectLinkCopyWith(_ProjectLink value, $Res Function(_ProjectLink) _then) = __$ProjectLinkCopyWithImpl;
@override @useResult
$Res call({
 String label, String url
});




}
/// @nodoc
class __$ProjectLinkCopyWithImpl<$Res>
    implements _$ProjectLinkCopyWith<$Res> {
  __$ProjectLinkCopyWithImpl(this._self, this._then);

  final _ProjectLink _self;
  final $Res Function(_ProjectLink) _then;

/// Create a copy of ProjectLink
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? url = null,}) {
  return _then(_ProjectLink(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Project {

 String get id; String get name; String? get description; ProjectStatus get status; String? get category; ProjectColor get color;@NullableTimestampConverter() DateTime? get startDate;@NullableTimestampConverter() DateTime? get dueDate; int get progress; String get ownerId; List<ProjectMemberRef> get members; List<ProjectLink> get links;@TimestampConverter() DateTime get createdAt;@TimestampConverter() DateTime get updatedAt; String get createdBy;
/// Create a copy of Project
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectCopyWith<Project> get copyWith => _$ProjectCopyWithImpl<Project>(this as Project, _$identity);

  /// Serializes this Project to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Project&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.category, category) || other.category == category)&&(identical(other.color, color) || other.color == color)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&const DeepCollectionEquality().equals(other.members, members)&&const DeepCollectionEquality().equals(other.links, links)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,status,category,color,startDate,dueDate,progress,ownerId,const DeepCollectionEquality().hash(members),const DeepCollectionEquality().hash(links),createdAt,updatedAt,createdBy);

@override
String toString() {
  return 'Project(id: $id, name: $name, description: $description, status: $status, category: $category, color: $color, startDate: $startDate, dueDate: $dueDate, progress: $progress, ownerId: $ownerId, members: $members, links: $links, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy)';
}


}

/// @nodoc
abstract mixin class $ProjectCopyWith<$Res>  {
  factory $ProjectCopyWith(Project value, $Res Function(Project) _then) = _$ProjectCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, ProjectStatus status, String? category, ProjectColor color,@NullableTimestampConverter() DateTime? startDate,@NullableTimestampConverter() DateTime? dueDate, int progress, String ownerId, List<ProjectMemberRef> members, List<ProjectLink> links,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt, String createdBy
});




}
/// @nodoc
class _$ProjectCopyWithImpl<$Res>
    implements $ProjectCopyWith<$Res> {
  _$ProjectCopyWithImpl(this._self, this._then);

  final Project _self;
  final $Res Function(Project) _then;

/// Create a copy of Project
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? status = null,Object? category = freezed,Object? color = null,Object? startDate = freezed,Object? dueDate = freezed,Object? progress = null,Object? ownerId = null,Object? members = null,Object? links = null,Object? createdAt = null,Object? updatedAt = null,Object? createdBy = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectStatus,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as ProjectColor,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<ProjectMemberRef>,links: null == links ? _self.links : links // ignore: cast_nullable_to_non_nullable
as List<ProjectLink>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Project].
extension ProjectPatterns on Project {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Project value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Project() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Project value)  $default,){
final _that = this;
switch (_that) {
case _Project():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Project value)?  $default,){
final _that = this;
switch (_that) {
case _Project() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  ProjectStatus status,  String? category,  ProjectColor color, @NullableTimestampConverter()  DateTime? startDate, @NullableTimestampConverter()  DateTime? dueDate,  int progress,  String ownerId,  List<ProjectMemberRef> members,  List<ProjectLink> links, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt,  String createdBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Project() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.status,_that.category,_that.color,_that.startDate,_that.dueDate,_that.progress,_that.ownerId,_that.members,_that.links,_that.createdAt,_that.updatedAt,_that.createdBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  ProjectStatus status,  String? category,  ProjectColor color, @NullableTimestampConverter()  DateTime? startDate, @NullableTimestampConverter()  DateTime? dueDate,  int progress,  String ownerId,  List<ProjectMemberRef> members,  List<ProjectLink> links, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt,  String createdBy)  $default,) {final _that = this;
switch (_that) {
case _Project():
return $default(_that.id,_that.name,_that.description,_that.status,_that.category,_that.color,_that.startDate,_that.dueDate,_that.progress,_that.ownerId,_that.members,_that.links,_that.createdAt,_that.updatedAt,_that.createdBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  ProjectStatus status,  String? category,  ProjectColor color, @NullableTimestampConverter()  DateTime? startDate, @NullableTimestampConverter()  DateTime? dueDate,  int progress,  String ownerId,  List<ProjectMemberRef> members,  List<ProjectLink> links, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt,  String createdBy)?  $default,) {final _that = this;
switch (_that) {
case _Project() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.status,_that.category,_that.color,_that.startDate,_that.dueDate,_that.progress,_that.ownerId,_that.members,_that.links,_that.createdAt,_that.updatedAt,_that.createdBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Project implements Project {
  const _Project({required this.id, required this.name, this.description = null, this.status = ProjectStatus.planning, this.category = null, this.color = ProjectColor.green, @NullableTimestampConverter() this.startDate, @NullableTimestampConverter() this.dueDate, this.progress = 0, required this.ownerId, final  List<ProjectMemberRef> members = const <ProjectMemberRef>[], final  List<ProjectLink> links = const <ProjectLink>[], @TimestampConverter() required this.createdAt, @TimestampConverter() required this.updatedAt, required this.createdBy}): _members = members,_links = links;
  factory _Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  String? description;
@override@JsonKey() final  ProjectStatus status;
@override@JsonKey() final  String? category;
@override@JsonKey() final  ProjectColor color;
@override@NullableTimestampConverter() final  DateTime? startDate;
@override@NullableTimestampConverter() final  DateTime? dueDate;
@override@JsonKey() final  int progress;
@override final  String ownerId;
 final  List<ProjectMemberRef> _members;
@override@JsonKey() List<ProjectMemberRef> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}

 final  List<ProjectLink> _links;
@override@JsonKey() List<ProjectLink> get links {
  if (_links is EqualUnmodifiableListView) return _links;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_links);
}

@override@TimestampConverter() final  DateTime createdAt;
@override@TimestampConverter() final  DateTime updatedAt;
@override final  String createdBy;

/// Create a copy of Project
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectCopyWith<_Project> get copyWith => __$ProjectCopyWithImpl<_Project>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Project&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.category, category) || other.category == category)&&(identical(other.color, color) || other.color == color)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&const DeepCollectionEquality().equals(other._members, _members)&&const DeepCollectionEquality().equals(other._links, _links)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,status,category,color,startDate,dueDate,progress,ownerId,const DeepCollectionEquality().hash(_members),const DeepCollectionEquality().hash(_links),createdAt,updatedAt,createdBy);

@override
String toString() {
  return 'Project(id: $id, name: $name, description: $description, status: $status, category: $category, color: $color, startDate: $startDate, dueDate: $dueDate, progress: $progress, ownerId: $ownerId, members: $members, links: $links, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy)';
}


}

/// @nodoc
abstract mixin class _$ProjectCopyWith<$Res> implements $ProjectCopyWith<$Res> {
  factory _$ProjectCopyWith(_Project value, $Res Function(_Project) _then) = __$ProjectCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, ProjectStatus status, String? category, ProjectColor color,@NullableTimestampConverter() DateTime? startDate,@NullableTimestampConverter() DateTime? dueDate, int progress, String ownerId, List<ProjectMemberRef> members, List<ProjectLink> links,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt, String createdBy
});




}
/// @nodoc
class __$ProjectCopyWithImpl<$Res>
    implements _$ProjectCopyWith<$Res> {
  __$ProjectCopyWithImpl(this._self, this._then);

  final _Project _self;
  final $Res Function(_Project) _then;

/// Create a copy of Project
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? status = null,Object? category = freezed,Object? color = null,Object? startDate = freezed,Object? dueDate = freezed,Object? progress = null,Object? ownerId = null,Object? members = null,Object? links = null,Object? createdAt = null,Object? updatedAt = null,Object? createdBy = null,}) {
  return _then(_Project(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectStatus,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as ProjectColor,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<ProjectMemberRef>,links: null == links ? _self._links : links // ignore: cast_nullable_to_non_nullable
as List<ProjectLink>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
