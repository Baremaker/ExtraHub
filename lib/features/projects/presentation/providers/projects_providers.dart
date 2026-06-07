import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/projects_repository.dart';
import '../../domain/project.dart';

// ─── REPOSITÓRIO ──────────────────────────────────────────────────────────
final projectsRepositoryProvider = Provider<ProjectsRepository>(
  (ref) => ProjectsRepository(ref.watch(firestoreProvider)),
);

// ─── LISTAS ───────────────────────────────────────────────────────────────

/// Stream de todos os projetos da extra ativa.
final projectsProvider = StreamProvider<List<Project>>((ref) {
  final extraId =
      ref.watch(currentAppUserProvider).value?.activeExtraId;
  if (extraId == null) return Stream<List<Project>>.value(const []);
  return ref.watch(projectsRepositoryProvider).watchAll(extraId);
});

/// Projetos da extra ativa em que [uid] está (ou esteve) alocado na equipe.
///
/// Derivado de [projectsProvider]. Serve tanto para "Meus projetos" no
/// dashboard quanto para o histórico de projetos no perfil de um membro ou
/// ex-membro (HU-07/HU-08) — como `markAsInactive` não remove a pessoa de
/// `project.members`, o histórico de projetos é preservado.
final projectsForMemberProvider =
    Provider.family<List<Project>, String>((ref, uid) {
  final all = ref.watch(projectsProvider).value ?? const <Project>[];
  return all
      .where((p) => p.members.any((m) => m.uid == uid))
      .toList(growable: false);
});

// ─── SINGLE PROJECT ───────────────────────────────────────────────────────

/// Stream de um projeto específico na extra ativa.
final projectByIdProvider =
    StreamProvider.family<Project?, String>((ref, projectId) {
  final extraId =
      ref.watch(currentAppUserProvider).value?.activeExtraId;
  if (extraId == null) return Stream<Project?>.value(null);
  return ref
      .watch(projectsRepositoryProvider)
      .watchOne(extraId, projectId);
});
