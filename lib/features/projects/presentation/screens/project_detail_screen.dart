import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/routes.dart';
import '../../../../app/shell/app_shell.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/progress_bar.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../extras/presentation/providers/extras_providers.dart';
import '../../../members/domain/member.dart';
import '../../../members/presentation/providers/members_providers.dart';
import '../../domain/project.dart';
import '../providers/projects_providers.dart';
import '../widgets/project_form_dialog.dart';
import '../widgets/project_helpers.dart';

/// Tela de detalhe de um projeto.
///
/// Mostra hero (nome, status, descrição, datas, líder, progresso geral) +
/// dois cards lado a lado: equipe alocada e links externos.
///
/// Usuários com permissão (admin ou líder) veem botões "Editar" e "Excluir".
class ProjectDetailScreen extends ConsumerWidget {
  const ProjectDetailScreen({super.key, required this.id});
  final String id;

  bool _canEdit({
    required Project project,
    required String? currentUid,
    required Member? membership,
  }) {
    if (currentUid == null || membership == null) return false;
    return membership.role == MemberRole.admin ||
        project.ownerId == currentUid;
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    Project p,
  ) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Excluir projeto',
      message: 'Esta ação remove o projeto "${p.name}" definitivamente. '
          'O histórico não pode ser recuperado.',
      confirmLabel: 'Excluir',
      danger: true,
    );
    if (!ok) return;

    final extra = ref.read(activeExtraProvider).value;
    if (extra == null) return;

    try {
      await ref.read(projectsRepositoryProvider).deleteProject(
            extraId: extra.id,
            projectId: p.id,
          );
      if (context.mounted) context.goNamed(Routes.projectsName);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectAsync = ref.watch(projectByIdProvider(id));
    final firebaseUid = ref.watch(currentFirebaseUserProvider)?.uid;
    final membership = ref.watch(currentMembershipProvider).value;

    return projectAsync.when(
      loading: () => const AppShell(
        title: 'Projeto',
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => AppShell(
        title: 'Projeto',
        child: ErrorView(message: '$e'),
      ),
      data: (project) {
        if (project == null) {
          return const AppShell(
            title: 'Projeto',
            child: Center(child: Text('Projeto não encontrado.')),
          );
        }
        final canEdit = _canEdit(
          project: project,
          currentUid: firebaseUid,
          membership: membership,
        );

        return AppShell(
          title: project.name,
          subtitle: 'Projeto da extra',
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Voltar',
              onPressed: () => context.pop(),
            ),
            if (canEdit) ...[
              AppButton(
                label: 'Editar',
                icon: Icons.edit_outlined,
                variant: AppButtonVariant.secondary,
                onPressed: () => showProjectFormDialog(
                  context,
                  project: project,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Excluir',
                color: AppColors.redText,
                onPressed: () => _delete(context, ref, project),
              ),
            ],
          ],
          child: _Body(project: project),
        );
      },
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// BODY
// ════════════════════════════════════════════════════════════════════════════

class _Body extends StatelessWidget {
  const _Body({required this.project});
  final Project project;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Hero(project: project),
        const SizedBox(height: AppSpacing.xl),
        LayoutBuilder(
          builder: (context, c) {
            final twoCols = c.maxWidth >= 720;
            final left = _TeamCard(project: project);
            final right = _LinksCard(project: project);
            if (!twoCols) {
              return Column(
                children: [
                  left,
                  const SizedBox(height: AppSpacing.md),
                  right,
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: left),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: right),
              ],
            );
          },
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// HERO
// ════════════════════════════════════════════════════════════════════════════

class _Hero extends StatelessWidget {
  const _Hero({required this.project});
  final Project project;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (badgeVariant, badgeLabel) = ProjectVisuals.badge(project.status);
    final progressColor = ProjectVisuals.progressColor(project.color);
    final leader = project.members.firstWhere(
      (m) => m.uid == project.ownerId,
      orElse: () => project.members.isEmpty
          ? const ProjectMemberRef(uid: '', displayName: '—')
          : project.members.first,
    );

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
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
              Expanded(
                child: Text(
                  project.name,
                  style: theme.textTheme.displayMedium,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              AppBadge(label: badgeLabel, variant: badgeVariant),
            ],
          ),
          if (project.description != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              project.description!,
              style: theme.textTheme.bodyLarge,
            ),
          ],
          const SizedBox(height: AppSpacing.xl),

          // ─── Meta-info em grid 4 colunas (responsivo) ──────────────
          LayoutBuilder(
            builder: (context, c) {
              const gap = AppSpacing.lg;
              final cols = c.maxWidth < 600 ? 2 : 4;
              final cardWidth = (c.maxWidth - gap * (cols - 1)) / cols;
              final items = [
                _MetaItem(
                  label: 'Início',
                  value: project.startDate == null
                      ? '—'
                      : DateFormat('MMM yyyy', 'pt_BR')
                          .format(project.startDate!),
                ),
                _MetaItem(
                  label: 'Previsão',
                  value: project.dueDate == null
                      ? '—'
                      : DateFormat('MMM yyyy', 'pt_BR')
                          .format(project.dueDate!),
                ),
                _MetaItem(
                  label: 'Membros',
                  value: '${project.members.length} alocados',
                ),
                _MetaItem(
                  label: 'Líder',
                  value: leader.displayName.split(' ').take(2).join(' '),
                ),
              ];
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: items
                    .map((w) => SizedBox(width: cardWidth, child: w))
                    .toList(growable: false),
              );
            },
          ),
          const SizedBox(height: AppSpacing.xl),

          // ─── Barra de progresso ───────────────────────────────────
          Row(
            children: [
              Text('Progresso geral', style: theme.textTheme.labelMedium),
              const Spacer(),
              Text(
                '${project.progress}%',
                style: theme.textTheme.headlineMedium,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AppProgressBar(
            value: project.progress / 100,
            color: progressColor,
            height: 8,
          ),
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: AppSpacing.xxs),
        Text(value, style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// TEAM
// ════════════════════════════════════════════════════════════════════════════

class _TeamCard extends StatelessWidget {
  const _TeamCard({required this.project});
  final Project project;

  @override
  Widget build(BuildContext context) {
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
          Text(
            'Equipe do projeto',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          if (project.members.isEmpty)
            Text(
              'Nenhum membro alocado.',
              style: Theme.of(context).textTheme.bodySmall,
            )
          else
            ...project.members.map((m) => _TeamRow(
                  member: m,
                  isLeader: m.uid == project.ownerId,
                )),
        ],
      ),
    );
  }
}

class _TeamRow extends ConsumerWidget {
  const _TeamRow({required this.member, required this.isLeader});
  final ProjectMemberRef member;
  final bool isLeader;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: AppRadius.radiusSm,
      onTap: () => context.pushNamed(
        Routes.memberDetailName,
        pathParameters: {'uid': member.uid},
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            AppAvatar(
              initials: _initialsFor(member.displayName),
              size: AvatarSize.md,
              seed: member.uid,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                member.displayName,
                style: Theme.of(context).textTheme.headlineSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isLeader)
              const AppBadge(label: 'Líder', variant: BadgeVariant.dev),
          ],
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
}

// ════════════════════════════════════════════════════════════════════════════
// LINKS
// ════════════════════════════════════════════════════════════════════════════

class _LinksCard extends StatelessWidget {
  const _LinksCard({required this.project});
  final Project project;

  @override
  Widget build(BuildContext context) {
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
          Text(
            'Links do projeto',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          if (project.links.isEmpty)
            Text(
              'Nenhum link cadastrado.',
              style: Theme.of(context).textTheme.bodySmall,
            )
          else
            ...project.links.map((l) => _LinkRow(link: l)),
        ],
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({required this.link});
  final ProjectLink link;

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: link.url));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Link "${link.label}" copiado.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = LinkIconInfo.forUrl(link.url);
    return InkWell(
      borderRadius: AppRadius.radiusSm,
      onTap: () => _copy(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: info.bg,
                borderRadius: AppRadius.radiusSm,
              ),
              child: Text(
                info.label,
                style: TextStyle(
                  color: info.fg,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    link.label,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    prettyUrl(link.url),
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.content_copy,
              size: 14,
              color: AppColors.txtTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
