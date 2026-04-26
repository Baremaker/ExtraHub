import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/firestore/firestore_paths.dart';
import '../domain/extra.dart';
import '../domain/extra_category.dart';

/// Repositório de extracurriculares.
class ExtrasRepository {
  ExtrasRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _extras =>
      _firestore.collection(FirestorePaths.extras);

  Stream<Extra?> watch(String id) =>
      _extras.doc(id).snapshots().map(
            (doc) => doc.exists ? Extra.fromFirestore(doc) : null,
          );

  Future<Extra?> get(String id) async {
    final doc = await _extras.doc(id).get();
    return doc.exists ? Extra.fromFirestore(doc) : null;
  }

  /// Lista as extras de [extraIds]. Faz reads em paralelo.
  Future<List<Extra>> getMany(List<String> extraIds) async {
    if (extraIds.isEmpty) return const [];
    final futures = extraIds.map((id) => _extras.doc(id).get());
    final docs = await Future.wait(futures);
    return docs
        .where((d) => d.exists)
        .map(Extra.fromFirestore)
        .toList(growable: false);
  }

  /// Cria uma nova extra **e** o vínculo do owner como admin/isOwner=true,
  /// **e** adiciona o id da extra em `users/{ownerUid}.extraIds`. Tudo em
  /// uma única transaction para garantir consistência.
  ///
  /// Retorna o id gerado da extra.
  Future<String> createExtra({
    required String ownerUid,
    required String ownerEmail,
    required String ownerDisplayName,
    required String name,
    String? description,
    required ExtraCategory category,
  }) async {
    final newExtraRef = _extras.doc(); // gera id
    final extraId = newExtraRef.id;

    final memberRef = _firestore.doc(
      FirestorePaths.member(extraId, ownerUid),
    );
    final userRef = _firestore.doc(FirestorePaths.user(ownerUid));

    await _firestore.runTransaction((tx) async {
      // É preciso ler o user antes de qualquer escrita (regra do Firestore).
      final userSnap = await tx.get(userRef);
      if (!userSnap.exists) {
        throw StateError('User doc not found for owner.');
      }

      // 1) Cria a extra
      tx.set(newExtraRef, {
        'id': extraId,
        'name': name.trim(),
        'description': description?.trim().isEmpty ?? true
            ? null
            : description!.trim(),
        'category': _categoryJson(category),
        'university': 'USP - São Carlos',
        'ownerId': ownerUid,
        'memberCount': 1,
        'projectCount': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // 2) Cria o membership do owner
      tx.set(memberRef, {
        'uid': ownerUid,
        'email': ownerEmail,
        'displayName': ownerDisplayName,
        'photoURL': null,
        'role': 'admin',
        'isOwner': true,
        'status': 'active',
        'position': null,
        'joinedAt': FieldValue.serverTimestamp(),
        'leftAt': null,
        'inProjectIds': <String>[],
      });

      // 3) Adiciona o id da extra ao user.extraIds (e marca como activeExtraId)
      tx.update(userRef, {
        'extraIds': FieldValue.arrayUnion([extraId]),
        'activeExtraId': extraId,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });

    return extraId;
  }

  // Helper para converter o enum no formato esperado pelo Firestore
  // (o `@JsonValue` da geração nem sempre está disponível em runtime aqui).
  String _categoryJson(ExtraCategory c) => switch (c) {
        ExtraCategory.juniorEnterprise => 'junior_enterprise',
        ExtraCategory.athletic         => 'athletic',
        ExtraCategory.petGroup         => 'pet_group',
        ExtraCategory.competitionTeam  => 'competition_team',
        ExtraCategory.league           => 'league',
        ExtraCategory.studyGroup       => 'study_group',
        ExtraCategory.other            => 'other',
      };
}
