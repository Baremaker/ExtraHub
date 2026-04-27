import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/avatar_stack.dart';
import '../../../../core/widgets/progress_bar.dart';
import '../../domain/project.dart';
import 'project_helpers.dart';

/// Card de projeto exibido na grid em `/projects`.
class ProjectCard extends StatelessWidget {
  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
  });

  final Project project;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (badgeVariant, badgeLabel) = ProjectVisuals.badge(project.status);
    final progressColor = ProjectVisuals.progressColor(project.color);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadius.radiusLg,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: AppRadius.radiusLg,
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Top: nome + status ─────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Text(
                      project.name,
                      style: theme.textTheme.headlineMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  AppBadge(label: badgeLabel, variant: badgeVariant),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              // ─── Descrição ───────────────────────────────────────────
              if (project.description != null)
                Text(
                  project.description!,
                  style: theme.textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: AppSpacing.md),

              // ─── Avatares + data ─────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: AvatarStack(
                      specs: project.members
                          .map((m) => AvatarSpec(
                                initials: _initialsFor(m.displayName),
                                seed: m.uid,
                              ))
                          .toList(),
                      maxVisible: 3,
                    ),
                  ),
                  if (project.startDate != null)
                    Text(
                      'Início: ${_formatDate(project.startDate!)}',
                      style: theme.textTheme.bodySmall,
                    )
                  else if (project.dueDate != null)
                    Text(
                      'Entrega: ${_formatDate(project.dueDate!)}',
                      style: theme.textTheme.bodySmall,
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // ─── Barra de progresso ──────────────────────────────────
              AppProgressBar(
                value: project.progress / 100,
                color: progressColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _initialsFor(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  static String _formatDate(DateTime d) =>
      DateFormat('MMM yyyy', 'pt_BR').format(d);
}
