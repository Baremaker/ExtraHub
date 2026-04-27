import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/firestore/firestore_paths.dart';
import '../domain/app_event.dart';

/// Repositório da subcollection `extras/{extraId}/events`.
class EventsRepository {
  EventsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _coll(String extraId) =>
      _firestore.collection(FirestorePaths.events(extraId));

  DocumentReference<Map<String, dynamic>> _doc(
    String extraId,
    String eid,
  ) =>
      _firestore.doc(FirestorePaths.event(extraId, eid));

  /// Stream de todos os eventos da extra. Ordem: startDate ascendente.
  Stream<List<AppEvent>> watchAll(String extraId) => _coll(extraId)
      .orderBy('startDate')
      .snapshots()
      .map((s) => s.docs.map(AppEvent.fromFirestore).toList());

  Future<String> create({
    required String extraId,
    required String title,
    String? description,
    required DateTime startDate,
    DateTime? endDate,
    bool allDay = false,
    String? location,
    String? relatedProjectId,
    required String createdBy,
  }) async {
    final ref = _coll(extraId).doc();
    await ref.set({
      'id': ref.id,
      'title': title.trim(),
      'description':
          (description?.trim().isEmpty ?? true) ? null : description!.trim(),
      'startDate': Timestamp.fromDate(startDate),
      'endDate': endDate == null ? null : Timestamp.fromDate(endDate),
      'allDay': allDay,
      'location':
          (location?.trim().isEmpty ?? true) ? null : location!.trim(),
      'relatedProjectId': relatedProjectId,
      'createdAt': FieldValue.serverTimestamp(),
      'createdBy': createdBy,
    });
    return ref.id;
  }

  Future<void> update({
    required String extraId,
    required String eventId,
    required String title,
    String? description,
    required DateTime startDate,
    DateTime? endDate,
    bool allDay = false,
    String? location,
    String? relatedProjectId,
  }) async {
    await _doc(extraId, eventId).update({
      'title': title.trim(),
      'description':
          (description?.trim().isEmpty ?? true) ? null : description!.trim(),
      'startDate': Timestamp.fromDate(startDate),
      'endDate': endDate == null ? null : Timestamp.fromDate(endDate),
      'allDay': allDay,
      'location':
          (location?.trim().isEmpty ?? true) ? null : location!.trim(),
      'relatedProjectId': relatedProjectId,
    });
  }

  Future<void> delete({
    required String extraId,
    required String eventId,
  }) async {
    await _doc(extraId, eventId).delete();
  }
}
