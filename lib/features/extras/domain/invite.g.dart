// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InvitedBy _$InvitedByFromJson(Map<String, dynamic> json) => _InvitedBy(
  uid: json['uid'] as String,
  displayName: json['displayName'] as String,
);

Map<String, dynamic> _$InvitedByToJson(_InvitedBy instance) =>
    <String, dynamic>{'uid': instance.uid, 'displayName': instance.displayName};

_Invite _$InviteFromJson(Map<String, dynamic> json) => _Invite(
  id: json['id'] as String,
  email: json['email'] as String,
  extraId: json['extraId'] as String,
  extraName: json['extraName'] as String,
  role: $enumDecode(_$MemberRoleEnumMap, json['role']),
  invitedBy: InvitedBy.fromJson(json['invitedBy'] as Map<String, dynamic>),
  status:
      $enumDecodeNullable(_$InviteStatusEnumMap, json['status']) ??
      InviteStatus.pending,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  expiresAt: const TimestampConverter().fromJson(json['expiresAt']),
  respondedAt: const NullableTimestampConverter().fromJson(json['respondedAt']),
);

Map<String, dynamic> _$InviteToJson(_Invite instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'extraId': instance.extraId,
  'extraName': instance.extraName,
  'role': _$MemberRoleEnumMap[instance.role]!,
  'invitedBy': instance.invitedBy,
  'status': _$InviteStatusEnumMap[instance.status]!,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'expiresAt': const TimestampConverter().toJson(instance.expiresAt),
  'respondedAt': const NullableTimestampConverter().toJson(
    instance.respondedAt,
  ),
};

const _$MemberRoleEnumMap = {
  MemberRole.admin: 'admin',
  MemberRole.member: 'member',
};

const _$InviteStatusEnumMap = {
  InviteStatus.pending: 'pending',
  InviteStatus.accepted: 'accepted',
  InviteStatus.declined: 'declined',
  InviteStatus.expired: 'expired',
};
