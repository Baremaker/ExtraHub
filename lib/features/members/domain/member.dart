import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/firestore/timestamp_converter.dart';

part 'member.freezed.dart';
part 'member.g.dart';

/// Papel de um membro dentro de uma extra.
@JsonEnum(alwaysCreate: true)
enum MemberRole {
  @JsonValue('admin')  admin,
  @JsonValue('member') member;

  String get label => switch (this) {
        admin  => 'Administrador',
        member => 'Membro',
      };
}

/// Status de um vínculo. `inactive` = ex-membro (HU-08).
@JsonEnum(alwaysCreate: true)
enum MemberStatus {
  @JsonValue('active')   active,
  @JsonValue('inactive') inactive;

  String get label => switch (this) {
        active   => 'Ativo',
        inactive => 'Ex-membro',
      };
}

/// Vínculo de um usuário com uma extra (subcollection `extras/{id}/members`).
///
/// O `uid` é o id do documento, garantindo unicidade. Vários campos são
/// denormalizados a partir de [AppUser] para evitar lookups na listagem
/// (`displayName`, `email`, `photoURL`).
@freezed
abstract class Member with _$Member {
  const factory Member({
    required String uid,
    required String email,
    required String displayName,
    @Default(null) String? photoURL,
    required MemberRole role,
    @Default(false) bool isOwner,
    @Default(MemberStatus.active) MemberStatus status,
    @Default(null) String? position,
    @TimestampConverter() required DateTime joinedAt,
    @NullableTimestampConverter() DateTime? leftAt,
    @Default(<String>[]) List<String> inProjectIds,
  }) = _Member;

  factory Member.fromJson(Map<String, dynamic> json) =>
      _$MemberFromJson(json);

  factory Member.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Member document ${doc.id} has no data');
    }
    return Member.fromJson({...data, 'uid': doc.id});
  }
}

extension MemberAvatarX on Member {
  String get initials {
    final parts = displayName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}
