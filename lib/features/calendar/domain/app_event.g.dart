// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppEvent _$AppEventFromJson(Map<String, dynamic> json) => _AppEvent(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String? ?? null,
  startDate: const TimestampConverter().fromJson(json['startDate']),
  endDate: const NullableTimestampConverter().fromJson(json['endDate']),
  allDay: json['allDay'] as bool? ?? false,
  location: json['location'] as String? ?? null,
  relatedProjectId: json['relatedProjectId'] as String? ?? null,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  createdBy: json['createdBy'] as String,
);

Map<String, dynamic> _$AppEventToJson(_AppEvent instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'startDate': const TimestampConverter().toJson(instance.startDate),
  'endDate': const NullableTimestampConverter().toJson(instance.endDate),
  'allDay': instance.allDay,
  'location': instance.location,
  'relatedProjectId': instance.relatedProjectId,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'createdBy': instance.createdBy,
};
