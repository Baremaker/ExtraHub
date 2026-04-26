// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  uid: json['uid'] as String,
  email: json['email'] as String,
  displayName: json['displayName'] as String,
  photoURL: json['photoURL'] as String? ?? null,
  bio: json['bio'] as String? ?? null,
  skills:
      (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  extraIds:
      (json['extraIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  activeExtraId: json['activeExtraId'] as String? ?? null,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'uid': instance.uid,
  'email': instance.email,
  'displayName': instance.displayName,
  'photoURL': instance.photoURL,
  'bio': instance.bio,
  'skills': instance.skills,
  'extraIds': instance.extraIds,
  'activeExtraId': instance.activeExtraId,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
};
