// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectMemberRef _$ProjectMemberRefFromJson(Map<String, dynamic> json) =>
    _ProjectMemberRef(
      uid: json['uid'] as String,
      displayName: json['displayName'] as String,
      photoURL: json['photoURL'] as String? ?? null,
    );

Map<String, dynamic> _$ProjectMemberRefToJson(_ProjectMemberRef instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'displayName': instance.displayName,
      'photoURL': instance.photoURL,
    };

_ProjectLink _$ProjectLinkFromJson(Map<String, dynamic> json) =>
    _ProjectLink(label: json['label'] as String, url: json['url'] as String);

Map<String, dynamic> _$ProjectLinkToJson(_ProjectLink instance) =>
    <String, dynamic>{'label': instance.label, 'url': instance.url};

_Project _$ProjectFromJson(Map<String, dynamic> json) => _Project(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String? ?? null,
  status:
      $enumDecodeNullable(_$ProjectStatusEnumMap, json['status']) ??
      ProjectStatus.planning,
  category: json['category'] as String? ?? null,
  color:
      $enumDecodeNullable(_$ProjectColorEnumMap, json['color']) ??
      ProjectColor.green,
  startDate: const NullableTimestampConverter().fromJson(json['startDate']),
  dueDate: const NullableTimestampConverter().fromJson(json['dueDate']),
  progress: (json['progress'] as num?)?.toInt() ?? 0,
  ownerId: json['ownerId'] as String,
  members:
      (json['members'] as List<dynamic>?)
          ?.map((e) => ProjectMemberRef.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ProjectMemberRef>[],
  links:
      (json['links'] as List<dynamic>?)
          ?.map((e) => ProjectLink.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ProjectLink>[],
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
  createdBy: json['createdBy'] as String,
);

Map<String, dynamic> _$ProjectToJson(_Project instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'status': _$ProjectStatusEnumMap[instance.status]!,
  'category': instance.category,
  'color': _$ProjectColorEnumMap[instance.color]!,
  'startDate': const NullableTimestampConverter().toJson(instance.startDate),
  'dueDate': const NullableTimestampConverter().toJson(instance.dueDate),
  'progress': instance.progress,
  'ownerId': instance.ownerId,
  'members': instance.members,
  'links': instance.links,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
  'createdBy': instance.createdBy,
};

const _$ProjectStatusEnumMap = {
  ProjectStatus.planning: 'planning',
  ProjectStatus.active: 'active',
  ProjectStatus.onHold: 'on_hold',
  ProjectStatus.completed: 'completed',
  ProjectStatus.archived: 'archived',
};

const _$ProjectColorEnumMap = {
  ProjectColor.green: 'green',
  ProjectColor.blue: 'blue',
  ProjectColor.amber: 'amber',
  ProjectColor.purple: 'purple',
  ProjectColor.pink: 'pink',
  ProjectColor.red: 'red',
};
