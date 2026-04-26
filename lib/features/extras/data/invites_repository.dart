import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/firestore/firestore_paths.dart';
import '../../members/domain/member.dart';
import '../domain/invite.dart';

class InvitesRepository {
  InvitesRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _invites =>
      _firestore.collection(FirestorePaths.invites);

  /// Stream de convites pendentes para o e-mail [email].
  Stream<List<Invite>> watchPendingFor(String email) {
    final normalized = email.trim().toLowerCase();
    return _invites
        .where('email', isEqualTo: normalized)
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(Invite.fromFirestore).toList());
  }

  /// Aceita o convite [inviteId] para o usuário [uid].
  ///
  /// Em uma transaction:
  ///   1. Marca o convite como `accepted`
  ///   2. Cria o doc `extras/{extraId}/members/{uid}`
  ///   3. Adiciona `extraId` em `users/{uid}.extraIds` (e seta como ativo)
  Future<void> acceptInvite({
    required String inviteId,
    required String uid,
    required String userEmail,
    required String userDisplayName,
  }) async {
    final inviteRef = _invites.doc(inviteId);
    final userRef = _firestore.doc(FirestorePaths.user(uid));

    await _firestore.runTransaction((tx) async {
      final inviteSnap = await tx.get(inviteRef);
      if (!inviteSnap.exists) {
        throw StateError('Convite não encontrado.');
      }
      final invite = Invite.fromFirestore(inviteSnap);
      if (invite.status != InviteStatus.pending) {
        throw StateError('Este convite não está mais pendente.');
      }
      if (invite.email.toLowerCase() != userEmail.toLowerCase()) {
        throw StateError('Este convite não é para você.');
      }
      if (DateTime.now().isAfter(invite.expiresAt)) {
        tx.update(inviteRef, {'status': 'expired'});
        throw StateError('Este convite expirou.');
      }

      final memberRef = _firestore.doc(
        FirestorePaths.member(invite.extraId, uid),
      );

      // 1) marca convite como aceito
      tx.update(inviteRef, {
        'status': 'accepted',
        'respondedAt': FieldValue.serverTimestamp(),
      });

      // 2) cria membership
      tx.set(memberRef, {
        'uid': uid,
        'email': userEmail,
        'displayName': userDisplayName,
        'photoURL': null,
        'role': invite.role == MemberRole.admin ? 'admin' : 'member',
        'isOwner': false,
        'status': 'active',
        'position': null,
        'joinedAt': FieldValue.serverTimestamp(),
        'leftAt': null,
        'inProjectIds': <String>[],
      });

      // 3) adiciona extraId no user
      tx.update(userRef, {
        'extraIds': FieldValue.arrayUnion([invite.extraId]),
        'activeExtraId': invite.extraId,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  /// Recusa o convite (não cria membership).
  Future<void> declineInvite(String inviteId) async {
    await _invites.doc(inviteId).update({
      'status': 'declined',
      'respondedAt': FieldValue.serverTimestamp(),
    });
  }
}
