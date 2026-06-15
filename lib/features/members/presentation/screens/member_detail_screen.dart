import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/shell/app_shell.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/skill_tag.dart';
import '../../../auth/domain/app_user.dart';
import '../../../extras/presentation/providers/extras_providers.dart';
import '../../../projects/presentation/widgets/member_projects_card.dart';
import '../../domain/member.dart';
import '../providers/members_providers.dart';

class MemberDetailScreen extends ConsumerWidget {
  const MemberDetailScreen({super.key, required this.uid});
  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberAsync = ref.watch(memberByIdProvider(uid));
    final userAsync = ref.watch(userByIdProvider(uid));
    final currentMembership = ref.watch(currentMembershipProvider).value;
    final extra = ref.watch(activeExtraProvider).value;

    return AppShell(
      title: 'Perfil do membro',
      actions: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Voltar',
          onPressed: () => context.pop(),
        ),
      ],
      child: memberAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(message: '$e'),
        data: (member) {
          if (member == null) {
            return const Center(
              child: Text('Membro não encontrado.'),
            );
          }
          final user = userAsync.value;
          final isAdmin = currentMembership?.role == MemberRole.admin;
          final isMyself = currentMembership?.uid == member.uid;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Hero(member: member, user: user),
              const SizedBox(height: AppSpacing.xl),
              LayoutBuilder(
                builder: (context, c) {
                  final twoCols = c.maxWidth >= 720;
                  final left = _PersonalInfoCard(member: member, user: user);
                  final right = _SkillsCard(user: user);
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
              const SizedBox(height: AppSpacing.md),
              MemberProjectsCard(
                uid: member.uid,
                emptyLabel: member.status == MemberStatus.inactive
                    ? 'Não participou de nenhum projeto.'
                    : 'Nenhum projeto alocado.',
              ),
              if (isAdmin && !isMyself && extra != null) ...[
                const SizedBox(height: AppSpacing.xl),
                _AdminActionsCard(member: member, extraId: extra.id),
              ],
            ],
          );
        },
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// HERO (avatar + nome + badges)
// ════════════════════════════════════════════════════════════════════════════

class _Hero extends StatelessWidget {
  const _Hero({required this.member, required this.user});
  final Member member;
  final AppUser? user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.radiusLg,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppAvatar(
            initials: member.initials,
            size: AvatarSize.xl,
            seed: member.uid,
          ),
          const SizedBox(width: AppSpacing.xl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.displayName,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                if (user?.academicLine != null) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    user!.academicLine!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  children: [
                    if (member.isOwner)
                      const AppBadge(
                        label: 'Dono',
                        variant: BadgeVariant.owner,
                      )
                    else if (member.role == MemberRole.admin)
                      const AppBadge(
                        label: 'Admin',
                        variant: BadgeVariant.admin,
                      )
                    else
                      const AppBadge(
                        label: 'Membro',
                        variant: BadgeVariant.member,
                      ),
                    if (member.status == MemberStatus.inactive)
                      const AppBadge(
                        label: 'Ex-membro',
                        variant: BadgeVariant.inactive,
                      ),
                    if (member.position != null)
                      AppBadge(
                        label: member.position!,
                        variant: BadgeVariant.dev,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// PERSONAL INFO
// ════════════════════════════════════════════════════════════════════════════

class _PersonalInfoCard extends StatelessWidget {
  const _PersonalInfoCard({required this.member, required this.user});
  final Member member;
  final AppUser? user;

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
            'Informações',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          _InfoRow(label: 'E-mail', value: member.email),
          if (user?.phone != null)
            _InfoRow(label: 'Celular', value: user!.phone!),
          if (user?.course != null)
            _InfoRow(label: 'Curso', value: user!.course!),
          if (user?.semester != null)
            _InfoRow(label: 'Semestre', value: '${user!.semester}º período'),
          if (user?.uspNumber != null)
            _InfoRow(label: 'Nº USP', value: user!.uspNumber!),
          if (member.position != null)
            _InfoRow(label: 'Cargo', value: member.position!),
          _InfoRow(
            label: 'Membro desde',
            value: _formatDate(member.joinedAt),
          ),
          if (user?.bio != null && user!.bio!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              'Sobre',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              user!.bio!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      'jan', 'fev', 'mar', 'abr', 'mai', 'jun',
      'jul', 'ago', 'set', 'out', 'nov', 'dez',
    ];
    return '${months[d.month - 1]} ${d.year}';
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// SKILLS
// ════════════════════════════════════════════════════════════════════════════

class _SkillsCard extends StatelessWidget {
  const _SkillsCard({required this.user});
  final AppUser? user;

  @override
  Widget build(BuildContext context) {
    final skills = user?.skills ?? const [];
    final interests = user?.interests ?? const [];

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
            'Habilidades',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          SkillTagList(tags: skills),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Interesses',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          SkillTagList(tags: interests),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// ADMIN ACTIONS (só visível para admins, não mostrado em si mesmo)
// ════════════════════════════════════════════════════════════════════════════

class _AdminActionsCard extends ConsumerStatefulWidget {
  const _AdminActionsCard({required this.member, required this.extraId});
  final Member member;
  final String extraId;

  @override
  ConsumerState<_AdminActionsCard> createState() =>
      _AdminActionsCardState();
}

class _AdminActionsCardState extends ConsumerState<_AdminActionsCard> {
  bool _busy = false;

  Future<void> _promote() async {
    setState(() => _busy = true);
    try {
      await ref
          .read(membersRepositoryProvider)
          .promoteToAdmin(widget.extraId, widget.member.uid);
    } catch (e) {
      _showError(e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _demote() async {
    setState(() => _busy = true);
    try {
      await ref
          .read(membersRepositoryProvider)
          .demoteToMember(widget.extraId, widget.member.uid);
    } catch (e) {
      _showError(e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _markInactive() async {
    final ok = await showConfirmDialog(
      context,
      title: 'Marcar como ex-membro',
      message:
          'O vínculo de ${widget.member.displayName} será marcado como inativo. '
          'O histórico é preservado e pode ser reativado depois.',
      confirmLabel: 'Confirmar',
    );
    if (!ok) return;

    setState(() => _busy = true);
    try {
      await ref
          .read(membersRepositoryProvider)
          .markAsInactive(widget.extraId, widget.member.uid);
    } catch (e) {
      _showError(e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _reactivate() async {
    setState(() => _busy = true);
    try {
      await ref
          .read(membersRepositoryProvider)
          .reactivate(widget.extraId, widget.member.uid);
    } catch (e) {
      _showError(e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showError(Object e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro: $e')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.member;
    final isOwner = m.isOwner;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.radiusLg,
        border: Border.all(color: AppColors.borderMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ações administrativas',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            isOwner
                ? 'O dono da extra é protegido contra alterações '
                    'administrativas.'
                : 'Você tem permissão para alterar este membro.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          if (!isOwner)
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                if (m.status == MemberStatus.active &&
                    m.role == MemberRole.member)
                  AppButton(
                    label: 'Promover a admin',
                    icon: Icons.shield_outlined,
                    variant: AppButtonVariant.secondary,
                    onPressed: _busy ? null : _promote,
                  ),
                if (m.status == MemberStatus.active &&
                    m.role == MemberRole.admin)
                  AppButton(
                    label: 'Rebaixar a membro',
                    icon: Icons.arrow_downward,
                    variant: AppButtonVariant.secondary,
                    onPressed: _busy ? null : _demote,
                  ),
                if (m.status == MemberStatus.active)
                  AppButton(
                    label: 'Marcar como ex-membro',
                    icon: Icons.person_off_outlined,
                    variant: AppButtonVariant.secondary,
                    onPressed: _busy ? null : _markInactive,
                  )
                else
                  AppButton(
                    label: 'Reativar',
                    icon: Icons.person_outline,
                    variant: AppButtonVariant.secondary,
                    onPressed: _busy ? null : _reactivate,
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
