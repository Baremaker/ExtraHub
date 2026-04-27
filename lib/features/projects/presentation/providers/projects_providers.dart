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
