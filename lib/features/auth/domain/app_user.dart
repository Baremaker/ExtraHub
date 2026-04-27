import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/firestore/timestamp_converter.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

/// Perfil de usuário no ExtraHub.
///
/// Não chamamos de `User` para evitar conflito com `firebase_auth.User`.
///
/// Um usuário pode pertencer a várias extras (ver [extraIds]) e a [activeExtraId]
/// é a última que ele estava visualizando — usada para abrir direto no dashboard
/// dela quando volta ao app.
///
/// Campos acadêmicos ([course], [semester], [uspNumber]) e de contato ([phone])
/// são opcionais. [skills] e [interests] são listas de tags livres.
@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String uid,
    required String email,
    required String displayName,
    @Default(null) String? photoURL,
    @Default(null) String? bio,
    @Default(null) String? course,
    @Default(null) int? semester,
    @Default(null) String? uspNumber,
    @Default(null) String? phone,
    @Default(<String>[]) List<String> skills,
    @Default(<String>[]) List<String> interests,
    @Default(<String>[]) List<String> extraIds,
    @Default(null) String? activeExtraId,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  /// Cria um [AppUser] a partir de um snapshot do Firestore.
  factory AppUser.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw StateError('User document ${doc.id} has no data');
    }
    return AppUser.fromJson({...data, 'uid': doc.id});
  }
}

/// Iniciais para o avatar (ex: "Felipe Maia" → "FM").
extension AppUserAvatarX on AppUser {
  String get initials {
    final parts = displayName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  /// Linha curta de descrição: "Eng. Computação · 5º período" se tiver dados,
  /// senão `null`.
  String? get academicLine {
    if (course == null && semester == null) return null;
    final parts = <String>[
      ?course,
      if (semester != null) '$semesterº período',
    ];
    return parts.join(' · ');
  }
}
