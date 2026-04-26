// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AnnouncementAuthor _$AnnouncementAuthorFromJson(Map<String, dynamic> json) =>
    _AnnouncementAuthor(
      uid: json['uid'] as String,
      displayName: json['displayName'] as String,
      photoURL: json['photoURL'] as String? ?? null,
    );

Map<String, dynamic> _$AnnouncementAuthorToJson(_AnnouncementAuthor instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'displayName': instance.displayName,
      'photoURL': instance.photoURL,
    };

_Announcement _$AnnouncementFromJson(Map<String, dynamic> json) =>
    _Announcement(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      pinned: json['pinned'] as bool? ?? false,
      author: AnnouncementAuthor.fromJson(
        json['author'] as Map<String, dynamic>,
      ),
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const NullableTimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$AnnouncementToJson(
  _Announcement instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'body': instance.body,
  'pinned': instance.pinned,
  'author': instance.author,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const NullableTimestampConverter().toJson(instance.updatedAt),
};
