import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/firestore/timestamp_converter.dart';
import '../../members/domain/member.dart' show MemberRole;

part 'invite.freezed.dart';
part 'invite.g.dart';

/// Status do convite.
@JsonEnum(alwaysCreate: true)
enum InviteStatus {
  @JsonValue('pending')  pending,
  @JsonValue('accepted') accepted,
  @JsonValue('declined') declined,
  @JsonValue('expired')  expired;

  String get label => switch (this) {
        pending  => 'Pendente',
        accepted => 'Aceito',
        declined => 'Recusado',
        expired  => 'Expirado',
      };
}

/// Quem convidou (denormalizado para a UI mostrar "X te convidou para Y").
@freezed
abstract class InvitedBy with _$InvitedBy {
  const factory InvitedBy({
    required String uid,
    required String displayName,
  }) = _InvitedBy;

  factory InvitedBy.fromJson(Map<String, dynamic> json) =>
      _$InvitedByFromJson(json);
}

@freezed
abstract class Invite with _$Invite {
  const factory Invite({
    required String id,
    required String email,                  // sempre lowercase
    required String extraId,
    required String extraName,              // denorm
    required MemberRole role,
    required InvitedBy invitedBy,
    @Default(InviteStatus.pending) InviteStatus status,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime expiresAt,
    @NullableTimestampConverter() DateTime? respondedAt,
  }) = _Invite;

  factory Invite.fromJson(Map<String, dynamic> json) => _$InviteFromJson(json);

  factory Invite.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Invite document ${doc.id} has no data');
    }
    return Invite.fromJson({...data, 'id': doc.id});
  }
}

extension InviteExpiryX on Invite {
  bool get isExpired =>
      status == InviteStatus.expired || DateTime.now().isAfter(expiresAt);
}
