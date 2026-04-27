import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/firestore/firestore_paths.dart';
import '../domain/project.dart';

/// Repositório da subcollection `extras/{extraId}/projects`.
///
/// Mantém `extras/{extraId}.projectCount` e `members/{uid}.inProjectIds`
/// sincronizados via transactions.
class ProjectsRepository {
  ProjectsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _projects(String extraId) =>
      _firestore.collection(FirestorePaths.projects(extraId));

  DocumentReference<Map<String, dynamic>> _projectDoc(
    String extraId,
    String projectId,
  ) =>
      _firestore.doc(FirestorePaths.project(extraId, projectId));

  /// Stream da lista de projetos da extra, ordenados por updatedAt desc.
  Stream<List<Project>> watchAll(String extraId) => _projects(extraId)
      .orderBy('updatedAt', descending: true)
      .snapshots()
      .map((s) => s.docs.map(Project.fromFirestore).toList(growable: false));

  /// Stream de um projeto específico.
  Stream<Project?> watchOne(String extraId, String projectId) =>
      _projectDoc(extraId, projectId).snapshots().map(
            (doc) => doc.exists ? Project.fromFirestore(doc) : null,
          );

  /// Cria um projeto novo.
  ///
  /// Em uma transaction:
  ///   1. Valida que todos os membros alocados existem
  ///   2. Cria o doc do projeto com id gerado
  ///   3. Adiciona o id em `inProjectIds` de cada membro alocado
  ///   4. Incrementa `extras/{extraId}.projectCount`
  Future<String> createProject({
    required String extraId,
    required String name,
    String? description,
    required ProjectStatus status,
    String? category,
    required ProjectColor color,
    DateTime? startDate,
    DateTime? dueDate,
    required int progress,
    required String ownerId,
    required List<ProjectMemberRef> members,
    required List<ProjectLink> links,
    required String createdBy,
  }) async {
    final newRef = _projects(extraId).doc();
    final extraRef = _firestore.doc(FirestorePaths.extra(extraId));
    final projectId = newRef.id;

    await _firestore.runTransaction((tx) async {
      // Lê membros antes de qualquer escrita (regra do Firestore).
      final memberDocs = await Future.wait(members.map(
        (m) => tx.get(_firestore.doc(FirestorePaths.member(extraId, m.uid))),
      ));
      for (var i = 0; i < memberDocs.length; i++) {
        if (!memberDocs[i].exists) {
          throw StateError(
              'Membro ${members[i].displayName} não encontrado.');
        }
      }

      tx.set(newRef, {
        'id': projectId,
        'name': name.trim(),
        'description': (description?.trim().isEmpty ?? true)
            ? null
            : description!.trim(),
        'status': _statusJson(status),
        'category':
            (category?.trim().isEmpty ?? true) ? null : category!.trim(),
        'color': _colorJson(color),
        'startDate':
            startDate == null ? null : Timestamp.fromDate(startDate),
        'dueDate': dueDate == null ? null : Timestamp.fromDate(dueDate),
        'progress': progress,
        'ownerId': ownerId,
        'members': members.map((m) => m.toJson()).toList(),
        'links': links.map((l) => l.toJson()).toList(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'createdBy': createdBy,
      });

      for (final m in members) {
        tx.update(
          _firestore.doc(FirestorePaths.member(extraId, m.uid)),
          {
            'inProjectIds': FieldValue.arrayUnion([projectId]),
          },
        );
      }

      tx.update(extraRef, {
        'projectCount': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });

    return projectId;
  }

  /// Atualiza um projeto. Sincroniza `inProjectIds` dos membros (adiciona
  /// nos novos, remove dos que saíram).
  Future<void> updateProject({
    required String extraId,
    required String projectId,
    required String name,
    String? description,
    required ProjectStatus status,
    String? category,
    required ProjectColor color,
    DateTime? startDate,
    DateTime? dueDate,
    required int progress,
    required String ownerId,
    required List<ProjectMemberRef> members,
    required List<ProjectLink> links,
  }) async {
    final projectRef = _projectDoc(extraId, projectId);

    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(projectRef);
      if (!snap.exists) {
        throw StateError('Projeto não encontrado.');
      }
      final current = Project.fromFirestore(snap);
      final currentUids = current.members.map((m) => m.uid).toSet();
      final newUids = members.map((m) => m.uid).toSet();
      final added = newUids.difference(currentUids);
      final removed = currentUids.difference(newUids);

      tx.update(projectRef, {
        'name': name.trim(),
        'description': (description?.trim().isEmpty ?? true)
            ? null
            : description!.trim(),
        'status': _statusJson(status),
        'category':
            (category?.trim().isEmpty ?? true) ? null : category!.trim(),
        'color': _colorJson(color),
        'startDate':
            startDate == null ? null : Timestamp.fromDate(startDate),
        'dueDate': dueDate == null ? null : Timestamp.fromDate(dueDate),
        'progress': progress,
        'ownerId': ownerId,
        'members': members.map((m) => m.toJson()).toList(),
        'links': links.map((l) => l.toJson()).toList(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      for (final uid in added) {
        tx.update(
          _firestore.doc(FirestorePaths.member(extraId, uid)),
          {
            'inProjectIds': FieldValue.arrayUnion([projectId]),
          },
        );
      }
      for (final uid in removed) {
        tx.update(
          _firestore.doc(FirestorePaths.member(extraId, uid)),
          {
            'inProjectIds': FieldValue.arrayRemove([projectId]),
          },
        );
      }
    });
  }

  /// Apaga um projeto. Remove `projectId` de `inProjectIds` de cada membro
  /// alocado e decrementa `projectCount`.
  Future<void> deleteProject({
    required String extraId,
    required String projectId,
  }) async {
    final projectRef = _projectDoc(extraId, projectId);
    final extraRef = _firestore.doc(FirestorePaths.extra(extraId));

    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(projectRef);
      if (!snap.exists) return;
      final project = Project.fromFirestore(snap);

      tx.delete(projectRef);
      for (final m in project.members) {
        tx.update(
          _firestore.doc(FirestorePaths.member(extraId, m.uid)),
          {
            'inProjectIds': FieldValue.arrayRemove([projectId]),
          },
        );
      }
      tx.update(extraRef, {
        'projectCount': FieldValue.increment(-1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  // ─── Helpers ────────────────────────────────────────────────────────────
  String _statusJson(ProjectStatus s) => switch (s) {
        ProjectStatus.planning  => 'planning',
        ProjectStatus.active    => 'active',
        ProjectStatus.onHold    => 'on_hold',
        ProjectStatus.completed => 'completed',
        ProjectStatus.archived  => 'archived',
      };

  String _colorJson(ProjectColor c) => switch (c) {
        ProjectColor.green  => 'green',
        ProjectColor.blue   => 'blue',
        ProjectColor.amber  => 'amber',
        ProjectColor.purple => 'purple',
        ProjectColor.pink   => 'pink',
        ProjectColor.red    => 'red',
      };
}
