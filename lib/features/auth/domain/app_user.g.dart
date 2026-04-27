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
  course: json['course'] as String? ?? null,
  semester: (json['semester'] as num?)?.toInt() ?? null,
  uspNumber: json['uspNumber'] as String? ?? null,
  phone: json['phone'] as String? ?? null,
  skills:
      (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  interests:
      (json['interests'] as List<dynamic>?)?.map((e) => e as String).toList() ??
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
  'course': instance.course,
  'semester': instance.semester,
  'uspNumber': instance.uspNumber,
  'phone': instance.phone,
  'skills': instance.skills,
  'interests': instance.interests,
  'extraIds': instance.extraIds,
  'activeExtraId': instance.activeExtraId,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
};
