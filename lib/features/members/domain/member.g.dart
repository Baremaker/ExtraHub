// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Member _$MemberFromJson(Map<String, dynamic> json) => _Member(
  uid: json['uid'] as String,
  email: json['email'] as String,
  displayName: json['displayName'] as String,
  photoURL: json['photoURL'] as String? ?? null,
  role: $enumDecode(_$MemberRoleEnumMap, json['role']),
  isOwner: json['isOwner'] as bool? ?? false,
  status:
      $enumDecodeNullable(_$MemberStatusEnumMap, json['status']) ??
      MemberStatus.active,
  position: json['position'] as String? ?? null,
  joinedAt: const TimestampConverter().fromJson(json['joinedAt']),
  leftAt: const NullableTimestampConverter().fromJson(json['leftAt']),
  inProjectIds:
      (json['inProjectIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
);

Map<String, dynamic> _$MemberToJson(_Member instance) => <String, dynamic>{
  'uid': instance.uid,
  'email': instance.email,
  'displayName': instance.displayName,
  'photoURL': instance.photoURL,
  'role': _$MemberRoleEnumMap[instance.role]!,
  'isOwner': instance.isOwner,
  'status': _$MemberStatusEnumMap[instance.status]!,
  'position': instance.position,
  'joinedAt': const TimestampConverter().toJson(instance.joinedAt),
  'leftAt': const NullableTimestampConverter().toJson(instance.leftAt),
  'inProjectIds': instance.inProjectIds,
};

const _$MemberRoleEnumMap = {
  MemberRole.admin: 'admin',
  MemberRole.member: 'member',
};

const _$MemberStatusEnumMap = {
  MemberStatus.active: 'active',
  MemberStatus.inactive: 'inactive',
};
