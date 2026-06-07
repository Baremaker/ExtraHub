import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/progress_bar.dart';
import '../../domain/project.dart';
import '../providers/projects_providers.dart';
import 'project_helpers.dart';

/// Card "Projetos" para o perfil de um membro/ex-membro (HU-07/HU-08).
///
/// Lista os projetos da extra ativa em que [uid] está (ou esteve) alocado,
/// com status e progresso, navegando para o detalhe ao tocar.
class MemberProjectsCard extends ConsumerWidget {
  const MemberProjectsCard({
    super.key,
    required this.uid,
    this.emptyLabel = 'Nenhum projeto alocado.',
  });

  final String uid;
  final String emptyLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectsForMemberProvider(uid));

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.radiusLg,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Projetos',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(width: AppSpacing.sm),
              if (projects.isNotEmpty)
                Text(
                  '${projects.length}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (projects.isEmpty)
            Text(emptyLabel, style: Theme.of(context).textTheme.bodySmall)
          else
            for (final p in projects) _ProjectRow(project: p),
        ],
      ),
    );
  }
}

class _ProjectRow extends StatelessWidget {
  const _ProjectRow({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final (variant, label) = ProjectVisuals.badge(project.status);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadius.radiusMd,
        onTap: () => context.pushNamed(
          Routes.projectDetailName,
          pathParameters: {'id': project.id},
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      project.name,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  AppBadge(label: label, variant: variant),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              AppProgressBar(
                value: project.progress / 100,
                color: ProjectVisuals.progressColor(project.color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
