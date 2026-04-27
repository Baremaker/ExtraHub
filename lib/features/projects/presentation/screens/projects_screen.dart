import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../../app/shell/app_shell.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../members/domain/member.dart';
import '../../../members/presentation/providers/members_providers.dart';
import '../../domain/project.dart';
import '../providers/projects_providers.dart';
import '../widgets/project_card.dart';
import '../widgets/project_form_dialog.dart';

/// Filtro ativo na lista de projetos.
enum _Filter { all, active, paused, completed }

extension on _Filter {
  String get label => switch (this) {
        _Filter.all       => 'Todos',
        _Filter.active    => 'Ativos',
        _Filter.paused    => 'Pausados',
        _Filter.completed => 'Finalizados',
      };

  bool match(Project p) => switch (this) {
        _Filter.all       => p.status != ProjectStatus.archived,
        _Filter.active    => p.status == ProjectStatus.active,
        _Filter.paused    => p.status == ProjectStatus.onHold,
        _Filter.completed => p.status == ProjectStatus.completed,
      };
}

class ProjectsScreen extends ConsumerStatefulWidget {
  const ProjectsScreen({super.key});

  @override
  ConsumerState<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends ConsumerState<ProjectsScreen> {
  _Filter _filter = _Filter.all;
  String _query = '';

  List<Project> _apply(List<Project> all) {
    final filtered = all.where(_filter.match);
    if (_query.isEmpty) return filtered.toList();
    final q = _query.toLowerCase();
    return filtered
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            (p.description?.toLowerCase().contains(q) ?? false) ||
            (p.category?.toLowerCase().contains(q) ?? false))
        .toList();
  }

  bool _canCreate(WidgetRef ref) {
    final m = ref.watch(currentMembershipProvider).value;
    return m?.role == MemberRole.admin;
  }

  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(projectsProvider);
    final canCreate = _canCreate(ref);

    return AppShell(
      title: 'Projetos',
      subtitle: projectsAsync.value == null
          ? null
          : '${projectsAsync.value!.where(_Filter.all.match).length} no total',
      actions: [
        if (canCreate)
          AppButton(
            label: 'Novo projeto',
            icon: Icons.add,
            onPressed: () async {
              final ok = await showProjectFormDialog(context);
              if (ok && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Projeto criado.')),
                );
              }
            },
          ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Busca + filtros
          TextField(
            onChanged: (v) => setState(() => _query = v),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search, size: 18),
              hintText: 'Buscar projeto...',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            children: _Filter.values
                .map((f) => _FilterChip(
                      label: f.label,
                      selected: _filter == f,
                      onTap: () => setState(() => _filter = f),
                    ))
                .toList(),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Grid
          projectsAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(AppSpacing.xl),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) =>
                ErrorView(message: '$e', onRetry: () => setState(() {})),
            data: (all) {
              final list = _apply(all);
              if (list.isEmpty) {
                return EmptyState(
                  icon: Icons.folder_outlined,
                  title: all.isEmpty
                      ? 'Nenhum projeto ainda'
                      : 'Nenhum projeto encontrado',
                  subtitle: all.isEmpty
                      ? 'Crie o primeiro projeto da extra.'
                      : 'Tente ajustar a busca ou os filtros.',
                  action: canCreate && all.isEmpty
                      ? AppButton(
                          label: 'Criar projeto',
                          icon: Icons.add,
                          onPressed: () =>
                              showProjectFormDialog(context),
                        )
                      : null,
                );
              }
              return _ProjectsGrid(projects: list);
            },
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.accentDim : AppColors.bgInput,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? AppColors.accent : AppColors.border,
            ),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: selected
                  ? AppColors.accentText
                  : AppColors.txtSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProjectsGrid extends StatelessWidget {
  const _ProjectsGrid({required this.projects});
  final List<Project> projects;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = AppSpacing.md;
        final width = constraints.maxWidth;
        final cols = width < 600 ? 1 : (width < 1080 ? 2 : 3);
        final cardWidth = (width - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: projects
              .map((p) => SizedBox(
                    width: cardWidth,
                    child: ProjectCard(
                      project: p,
                      onTap: () => context.pushNamed(
                        Routes.projectDetailName,
                        pathParameters: {'id': p.id},
                      ),
                    ),
                  ))
              .toList(growable: false),
        );
      },
    );
  }
}
