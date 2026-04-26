// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extra.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Extra _$ExtraFromJson(Map<String, dynamic> json) => _Extra(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String? ?? null,
  category: $enumDecode(_$ExtraCategoryEnumMap, json['category']),
  university: json['university'] as String? ?? 'USP - São Carlos',
  ownerId: json['ownerId'] as String,
  memberCount: (json['memberCount'] as num?)?.toInt() ?? 0,
  projectCount: (json['projectCount'] as num?)?.toInt() ?? 0,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$ExtraToJson(_Extra instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'category': _$ExtraCategoryEnumMap[instance.category]!,
  'university': instance.university,
  'ownerId': instance.ownerId,
  'memberCount': instance.memberCount,
  'projectCount': instance.projectCount,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
};

const _$ExtraCategoryEnumMap = {
  ExtraCategory.juniorEnterprise: 'junior_enterprise',
  ExtraCategory.athletic: 'athletic',
  ExtraCategory.petGroup: 'pet_group',
  ExtraCategory.competitionTeam: 'competition_team',
  ExtraCategory.league: 'league',
  ExtraCategory.studyGroup: 'study_group',
  ExtraCategory.other: 'other',
};
