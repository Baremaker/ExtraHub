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

  /// Lê vários usuários em paralelo. Útil para denormalizar dados em cards
  /// de membro etc.
  Future<List<AppUser>> getMany(Iterable<String> uids) async {
    final unique = uids.toSet().toList();
    if (unique.isEmpty) return const [];
    final docs = await Future.wait(unique.map((u) => _userDoc(u).get()));
    return docs
        .where((d) => d.exists)
        .map(AppUser.fromFirestore)
        .toList(growable: false);
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
      'course': null,
      'semester': null,
      'uspNumber': null,
      'phone': null,
      'skills': <String>[],
      'interests': <String>[],
      'extraIds': <String>[],
      'activeExtraId': null,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Atualiza campos editáveis do perfil.
  ///
  /// Passe `null` para um campo que deve permanecer inalterado. Para *limpar*
  /// um campo, use [updateClearable].
  Future<void> update({
    required String uid,
    String? displayName,
    String? bio,
    String? course,
    int? semester,
    String? uspNumber,
    String? phone,
    List<String>? skills,
    List<String>? interests,
  }) async {
    final updates = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (displayName != null) updates['displayName'] = displayName;
    if (bio != null) updates['bio'] = bio;
    if (course != null) updates['course'] = course;
    if (semester != null) updates['semester'] = semester;
    if (uspNumber != null) updates['uspNumber'] = uspNumber;
    if (phone != null) updates['phone'] = phone;
    if (skills != null) updates['skills'] = skills;
    if (interests != null) updates['interests'] = interests;

    await _userDoc(uid).update(updates);
  }

  /// Aceita "explicitamente null" para limpar um campo opcional. Cada chave
  /// presente em [fields] é gravada com o valor passado (incluindo null).
  Future<void> updateClearable(
    String uid,
    Map<String, dynamic> fields,
  ) async {
    await _userDoc(uid).update({
      ...fields,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Define qual extra está atualmente "aberta" para o usuário (multi-extra).
  Future<void> setActiveExtra(String uid, String? extraId) async {
    await _userDoc(uid).update({
      'activeExtraId': extraId,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
