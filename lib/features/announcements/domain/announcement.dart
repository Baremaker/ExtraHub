import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/firestore/timestamp_converter.dart';

part 'announcement.freezed.dart';
part 'announcement.g.dart';

/// Referência ao autor do aviso (denormalizado para evitar lookup do user).
@freezed
abstract class AnnouncementAuthor with _$AnnouncementAuthor {
  const factory AnnouncementAuthor({
    required String uid,
    required String displayName,
    @Default(null) String? photoURL,
  }) = _AnnouncementAuthor;

  factory AnnouncementAuthor.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementAuthorFromJson(json);
}

@freezed
abstract class Announcement with _$Announcement {
  const factory Announcement({
    required String id,
    required String title,
    required String body,
    @Default(false) bool pinned,
    required AnnouncementAuthor author,
    @TimestampConverter() required DateTime createdAt,
    @NullableTimestampConverter() DateTime? updatedAt,
  }) = _Announcement;

  factory Announcement.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementFromJson(json);

  factory Announcement.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Announcement document ${doc.id} has no data');
    }
    return Announcement.fromJson({...data, 'id': doc.id});
  }
}
