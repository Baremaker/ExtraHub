// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppEvent {

 String get id; String get title; String? get description;@TimestampConverter() DateTime get startDate;@NullableTimestampConverter() DateTime? get endDate; bool get allDay; String? get location; String? get relatedProjectId;@TimestampConverter() DateTime get createdAt; String get createdBy;
/// Create a copy of AppEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppEventCopyWith<AppEvent> get copyWith => _$AppEventCopyWithImpl<AppEvent>(this as AppEvent, _$identity);

  /// Serializes this AppEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.allDay, allDay) || other.allDay == allDay)&&(identical(other.location, location) || other.location == location)&&(identical(other.relatedProjectId, relatedProjectId) || other.relatedProjectId == relatedProjectId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,startDate,endDate,allDay,location,relatedProjectId,createdAt,createdBy);

@override
String toString() {
  return 'AppEvent(id: $id, title: $title, description: $description, startDate: $startDate, endDate: $endDate, allDay: $allDay, location: $location, relatedProjectId: $relatedProjectId, createdAt: $createdAt, createdBy: $createdBy)';
}


}

/// @nodoc
abstract mixin class $AppEventCopyWith<$Res>  {
  factory $AppEventCopyWith(AppEvent value, $Res Function(AppEvent) _then) = _$AppEventCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? description,@TimestampConverter() DateTime startDate,@NullableTimestampConverter() DateTime? endDate, bool allDay, String? location, String? relatedProjectId,@TimestampConverter() DateTime createdAt, String createdBy
});




}
/// @nodoc
class _$AppEventCopyWithImpl<$Res>
    implements $AppEventCopyWith<$Res> {
  _$AppEventCopyWithImpl(this._self, this._then);

  final AppEvent _self;
  final $Res Function(AppEvent) _then;

/// Create a copy of AppEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? startDate = null,Object? endDate = freezed,Object? allDay = null,Object? location = freezed,Object? relatedProjectId = freezed,Object? createdAt = null,Object? createdBy = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,allDay: null == allDay ? _self.allDay : allDay // ignore: cast_nullable_to_non_nullable
as bool,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,relatedProjectId: freezed == relatedProjectId ? _self.relatedProjectId : relatedProjectId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppEvent].
extension AppEventPatterns on AppEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppEvent value)  $default,){
final _that = this;
switch (_that) {
case _AppEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppEvent value)?  $default,){
final _that = this;
switch (_that) {
case _AppEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? description, @TimestampConverter()  DateTime startDate, @NullableTimestampConverter()  DateTime? endDate,  bool allDay,  String? location,  String? relatedProjectId, @TimestampConverter()  DateTime createdAt,  String createdBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppEvent() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.startDate,_that.endDate,_that.allDay,_that.location,_that.relatedProjectId,_that.createdAt,_that.createdBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? description, @TimestampConverter()  DateTime startDate, @NullableTimestampConverter()  DateTime? endDate,  bool allDay,  String? location,  String? relatedProjectId, @TimestampConverter()  DateTime createdAt,  String createdBy)  $default,) {final _that = this;
switch (_that) {
case _AppEvent():
return $default(_that.id,_that.title,_that.description,_that.startDate,_that.endDate,_that.allDay,_that.location,_that.relatedProjectId,_that.createdAt,_that.createdBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? description, @TimestampConverter()  DateTime startDate, @NullableTimestampConverter()  DateTime? endDate,  bool allDay,  String? location,  String? relatedProjectId, @TimestampConverter()  DateTime createdAt,  String createdBy)?  $default,) {final _that = this;
switch (_that) {
case _AppEvent() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.startDate,_that.endDate,_that.allDay,_that.location,_that.relatedProjectId,_that.createdAt,_that.createdBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppEvent implements AppEvent {
  const _AppEvent({required this.id, required this.title, this.description = null, @TimestampConverter() required this.startDate, @NullableTimestampConverter() this.endDate, this.allDay = false, this.location = null, this.relatedProjectId = null, @TimestampConverter() required this.createdAt, required this.createdBy});
  factory _AppEvent.fromJson(Map<String, dynamic> json) => _$AppEventFromJson(json);

@override final  String id;
@override final  String title;
@override@JsonKey() final  String? description;
@override@TimestampConverter() final  DateTime startDate;
@override@NullableTimestampConverter() final  DateTime? endDate;
@override@JsonKey() final  bool allDay;
@override@JsonKey() final  String? location;
@override@JsonKey() final  String? relatedProjectId;
@override@TimestampConverter() final  DateTime createdAt;
@override final  String createdBy;

/// Create a copy of AppEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppEventCopyWith<_AppEvent> get copyWith => __$AppEventCopyWithImpl<_AppEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.allDay, allDay) || other.allDay == allDay)&&(identical(other.location, location) || other.location == location)&&(identical(other.relatedProjectId, relatedProjectId) || other.relatedProjectId == relatedProjectId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,startDate,endDate,allDay,location,relatedProjectId,createdAt,createdBy);

@override
String toString() {
  return 'AppEvent(id: $id, title: $title, description: $description, startDate: $startDate, endDate: $endDate, allDay: $allDay, location: $location, relatedProjectId: $relatedProjectId, createdAt: $createdAt, createdBy: $createdBy)';
}


}

/// @nodoc
abstract mixin class _$AppEventCopyWith<$Res> implements $AppEventCopyWith<$Res> {
  factory _$AppEventCopyWith(_AppEvent value, $Res Function(_AppEvent) _then) = __$AppEventCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? description,@TimestampConverter() DateTime startDate,@NullableTimestampConverter() DateTime? endDate, bool allDay, String? location, String? relatedProjectId,@TimestampConverter() DateTime createdAt, String createdBy
});




}
/// @nodoc
class __$AppEventCopyWithImpl<$Res>
    implements _$AppEventCopyWith<$Res> {
  __$AppEventCopyWithImpl(this._self, this._then);

  final _AppEvent _self;
  final $Res Function(_AppEvent) _then;

/// Create a copy of AppEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? startDate = null,Object? endDate = freezed,Object? allDay = null,Object? location = freezed,Object? relatedProjectId = freezed,Object? createdAt = null,Object? createdBy = null,}) {
  return _then(_AppEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,allDay: null == allDay ? _self.allDay : allDay // ignore: cast_nullable_to_non_nullable
as bool,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,relatedProjectId: freezed == relatedProjectId ? _self.relatedProjectId : relatedProjectId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
