import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/firestore/firestore_paths.dart';
import '../domain/app_user.dart';

/// Repositório do documento `users/{uid}` no Firestore.
class AppUserRepository {
  AppUserRepository(this._firestore);

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _firestore.doc(FirestorePaths.user(uid));

  /// Stream do perfil de [uid]. Emite `null` quando o doc ainda não existe.
  Stream<AppUser?> watch(String uid) => _userDoc(uid).snapshots().map(
        (doc) => doc.exists ? AppUser.fromFirestore(doc) : null,
      );

  /// Lê uma vez (uso pontual; prefira [watch] na UI).
  Future<AppUser?> get(String uid) async {
    final doc = await _userDoc(uid).get();
    return doc.exists ? AppUser.fromFirestore(doc) : null;
  }

  /// Cria o doc `users/{uid}` na primeira entrada da pessoa no app.
  ///
  /// Idempotente: se já existir, não faz nada.
  Future<void> createIfMissing({
    required String uid,
    required String email,
    required String displayName,
  }) async {
    final ref = _userDoc(uid);
    final snap = await ref.get();
    if (snap.exists) return;

    await ref.set({
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': null,
      'bio': null,
      'skills': <String>[],
      'extraIds': <String>[],
      'activeExtraId': null,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Atualiza campos editáveis do perfil.
  Future<void> update({
    required String uid,
    String? displayName,
    String? bio,
    List<String>? skills,
  }) async {
    final updates = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (displayName != null) updates['displayName'] = displayName;
    if (bio != null) updates['bio'] = bio;
    if (skills != null) updates['skills'] = skills;

    await _userDoc(uid).update(updates);
  }

  /// Define qual extra está atualmente "aberta" para o usuário (multi-extra).
  Future<void> setActiveExtra(String uid, String? extraId) async {
    await _userDoc(uid).update({
      'activeExtraId': extraId,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
