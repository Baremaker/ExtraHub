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

  /// Stream de convites pendentes que o admin enviou para uma extra
  /// (para listar no painel administrativo no futuro).
  Stream<List<Invite>> watchPendingForExtra(String extraId) => _invites
      .where('extraId', isEqualTo: extraId)
      .where('status', isEqualTo: 'pending')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snap) => snap.docs.map(Invite.fromFirestore).toList());

  /// Cria um convite novo. Falha se já existir um convite **pendente**
  /// para o mesmo email + extra.
  ///
  /// Validade: 7 dias.
  Future<String> createInvite({
    required String extraId,
    required String extraName,
    required String email,
    required MemberRole role,
    required String inviterUid,
    required String inviterDisplayName,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();

    // Id determinístico: 1 convite por (extra, e-mail). É o que permite às
    // security rules localizarem o convite (sem id aleatório) ao autorizar o
    // aceite — ver `hasValidInvite` em firestore.rules.
    final ref = _invites.doc('${extraId}__$normalizedEmail');

    // Bloqueia reenvio se já houver convite pendente e não expirado. (Um doc
    // antigo recusado/expirado no mesmo id pode ser sobrescrito normalmente.)
    final existing = await ref.get();
    if (existing.exists) {
      final data = existing.data();
      final expiresAtTs = data?['expiresAt'];
      final notExpired = expiresAtTs is Timestamp
          ? DateTime.now().isBefore(expiresAtTs.toDate())
          : true;
      if (data?['status'] == 'pending' && notExpired) {
        throw StateError('Já existe um convite pendente para este e-mail.');
      }
    }

    final expiresAt = DateTime.now().add(const Duration(days: 7));

    await ref.set({
      'id': ref.id,
      'email': normalizedEmail,
      'extraId': extraId,
      'extraName': extraName,
      'role': role == MemberRole.admin ? 'admin' : 'member',
      'invitedBy': {
        'uid': inviterUid,
        'displayName': inviterDisplayName,
      },
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'respondedAt': null,
    });

    return ref.id;
  }

  /// Aceita o convite [inviteId] para o usuário [uid].
  ///
  /// Em uma transaction:
  ///   1. Marca o convite como `accepted`
  ///   2. Cria o doc `extras/{extraId}/members/{uid}`
  ///   3. Adiciona `extraId` em `users/{uid}.extraIds` (e seta como ativo)
  ///   4. Incrementa `extras/{extraId}.memberCount`
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
      final extraRef = _firestore.doc(FirestorePaths.extra(invite.extraId));

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

      // 4) incrementa contagem de membros
      tx.update(extraRef, {
        'memberCount': FieldValue.increment(1),
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

  /// Cancela um convite (admin que enviou pode cancelar).
  Future<void> cancelInvite(String inviteId) async {
    await _invites.doc(inviteId).delete();
  }
}
