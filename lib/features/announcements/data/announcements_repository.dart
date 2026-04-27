import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/firestore/firestore_paths.dart';
import '../domain/announcement.dart';

/// Repositório da subcollection `extras/{extraId}/announcements`.
class AnnouncementsRepository {
  AnnouncementsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _coll(String extraId) =>
      _firestore.collection(FirestorePaths.announcements(extraId));

  DocumentReference<Map<String, dynamic>> _doc(
    String extraId,
    String aid,
  ) =>
      _firestore.doc(FirestorePaths.announcement(extraId, aid));

  /// Stream de todos os avisos. Ordem: pinned desc, depois createdAt desc.
  ///
  /// Esta ordem é exatamente o índice composto que registramos em
  /// `firestore.indexes.json`.
  Stream<List<Announcement>> watchAll(String extraId) => _coll(extraId)
      .orderBy('pinned', descending: true)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((s) => s.docs.map(Announcement.fromFirestore).toList());

  /// Cria um aviso.
  Future<String> create({
    required String extraId,
    required String title,
    required String body,
    required bool pinned,
    required AnnouncementAuthor author,
  }) async {
    final ref = _coll(extraId).doc();
    await ref.set({
      'id': ref.id,
      'title': title.trim(),
      'body': body.trim(),
      'pinned': pinned,
      'author': author.toJson(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': null,
    });
    return ref.id;
  }

  /// Atualiza um aviso. `author` e `createdAt` são imutáveis (rules).
  Future<void> update({
    required String extraId,
    required String announcementId,
    required String title,
    required String body,
    required bool pinned,
  }) async {
    await _doc(extraId, announcementId).update({
      'title': title.trim(),
      'body': body.trim(),
      'pinned': pinned,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> delete({
    required String extraId,
    required String announcementId,
  }) async {
    await _doc(extraId, announcementId).delete();
  }

  /// Toggle pinned (atalho da tela de detalhe).
  Future<void> togglePinned({
    required String extraId,
    required String announcementId,
    required bool pinned,
  }) async {
    await _doc(extraId, announcementId).update({
      'pinned': pinned,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
