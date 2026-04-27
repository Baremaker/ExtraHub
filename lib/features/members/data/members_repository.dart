import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/firestore/firestore_paths.dart';
import '../domain/member.dart';

/// Repositório da subcollection `extras/{extraId}/members`.
class MembersRepository {
  MembersRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _members(String extraId) =>
      _firestore.collection(FirestorePaths.members(extraId));

  DocumentReference<Map<String, dynamic>> _memberDoc(
    String extraId,
    String uid,
  ) =>
      _firestore.doc(FirestorePaths.member(extraId, uid));

  /// Stream da lista de membros [activos] de uma extra, ordenados por nome.
  Stream<List<Member>> watchActive(String extraId) => _members(extraId)
      .where('status', isEqualTo: 'active')
      .orderBy('displayName')
      .snapshots()
      .map((s) => s.docs.map(Member.fromFirestore).toList(growable: false));

  /// Stream da lista de **ex-membros** (status='inactive') — atende HU-08.
  Stream<List<Member>> watchInactive(String extraId) => _members(extraId)
      .where('status', isEqualTo: 'inactive')
      .orderBy('displayName')
      .snapshots()
      .map((s) => s.docs.map(Member.fromFirestore).toList(growable: false));

  /// Stream de um membro específico.
  Stream<Member?> watchOne(String extraId, String uid) =>
      _memberDoc(extraId, uid).snapshots().map(
            (doc) => doc.exists ? Member.fromFirestore(doc) : null,
          );

  Future<Member?> get(String extraId, String uid) async {
    final doc = await _memberDoc(extraId, uid).get();
    return doc.exists ? Member.fromFirestore(doc) : null;
  }

  /// Promove um membro para admin.
  Future<void> promoteToAdmin(String extraId, String uid) async {
    await _memberDoc(extraId, uid).update({'role': 'admin'});
  }

  /// Rebaixa um admin para membro comum. Falha (regra do Firestore) se
  /// o alvo for o owner.
  Future<void> demoteToMember(String extraId, String uid) async {
    await _memberDoc(extraId, uid).update({'role': 'member'});
  }

  /// Marca como ex-membro (HU-08). Preserva histórico no doc.
  ///
  /// Atualiza também `extras/{extraId}.memberCount` decrementando 1.
  Future<void> markAsInactive(String extraId, String uid) async {
    final extraRef = _firestore.doc(FirestorePaths.extra(extraId));
    final memberRef = _memberDoc(extraId, uid);

    await _firestore.runTransaction((tx) async {
      final memberSnap = await tx.get(memberRef);
      if (!memberSnap.exists) {
        throw StateError('Membro não encontrado.');
      }
      final wasActive = memberSnap.data()?['status'] == 'active';

      tx.update(memberRef, {
        'status': 'inactive',
        'leftAt': FieldValue.serverTimestamp(),
      });

      if (wasActive) {
        tx.update(extraRef, {
          'memberCount': FieldValue.increment(-1),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    });
  }

  /// Reativa um ex-membro.
  Future<void> reactivate(String extraId, String uid) async {
    final extraRef = _firestore.doc(FirestorePaths.extra(extraId));
    final memberRef = _memberDoc(extraId, uid);

    await _firestore.runTransaction((tx) async {
      final memberSnap = await tx.get(memberRef);
      if (!memberSnap.exists) {
        throw StateError('Membro não encontrado.');
      }
      final wasInactive = memberSnap.data()?['status'] == 'inactive';

      tx.update(memberRef, {
        'status': 'active',
        'leftAt': null,
      });

      if (wasInactive) {
        tx.update(extraRef, {
          'memberCount': FieldValue.increment(1),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    });
  }

  /// Remove o vínculo do membro **definitivamente** (apaga o doc).
  ///
  /// Regra de negócio: prefira [markAsInactive] para preservar histórico.
  /// Use este método apenas se o admin realmente quer apagar.
  ///
  /// Falha se o alvo for o owner (regra do Firestore).
  Future<void> removeMember(String extraId, String uid) async {
    final extraRef = _firestore.doc(FirestorePaths.extra(extraId));
    final memberRef = _memberDoc(extraId, uid);
    final userRef = _firestore.doc(FirestorePaths.user(uid));

    await _firestore.runTransaction((tx) async {
      final memberSnap = await tx.get(memberRef);
      if (!memberSnap.exists) return;

      final wasActive = memberSnap.data()?['status'] == 'active';

      tx.delete(memberRef);
      tx.update(userRef, {
        'extraIds': FieldValue.arrayRemove([extraId]),
      });
      if (wasActive) {
        tx.update(extraRef, {
          'memberCount': FieldValue.increment(-1),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    });
  }

  /// Atualiza o cargo (`position`) do membro.
  Future<void> updatePosition(
    String extraId,
    String uid,
    String? position,
  ) async {
    await _memberDoc(extraId, uid).update({
      'position': (position == null || position.trim().isEmpty)
          ? null
          : position.trim(),
    });
  }
}
