import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/shell/app_shell.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/skill_tag.dart';
import '../../../auth/domain/app_user.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../members/domain/member.dart';
import '../../../members/presentation/providers/members_providers.dart';
import '../../../projects/presentation/widgets/member_projects_card.dart';
import '../widgets/edit_profile_dialog.dart';

/// Tela "Meu perfil" — vê e edita o próprio [AppUser] + mostra membership.
class MyProfileScreen extends ConsumerWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentAppUserProvider);
    final membership = ref.watch(currentMembershipProvider).value;

    return AppShell(
      title: 'Meu perfil',
      actions: [
        userAsync.value == null
            ? const SizedBox.shrink()
            : AppButton(
                label: 'Editar perfil',
                icon: Icons.edit_outlined,
                variant: AppButtonVariant.secondary,
                onPressed: () => showEditProfileDialog(
                  context,
                  user: userAsync.value!,
                ),
              ),
      ],
      child: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (user) {
          if (user == null) {
            return const EmptyState(
              icon: Icons.person_off_outlined,
              title: 'Perfil não encontrado',
            );
          }
          return _ProfileBody(user: user, membership: membership);
        },
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({required this.user, required this.membership});
  final AppUser user;
  final Member? membership;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Hero(user: user, membership: membership),
        const SizedBox(height: AppSpacing.xl),
        LayoutBuilder(
          builder: (context, c) {
            final twoCols = c.maxWidth >= 720;
            final left = _PersonalCard(user: user, membership: membership);
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
        MemberProjectsCard(uid: user.uid),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.user, required this.membership});
  final AppUser user;
  final Member? membership;

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
            initials: user.initials,
            size: AvatarSize.xl,
            seed: user.uid,
          ),
          const SizedBox(width: AppSpacing.xl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                if (user.academicLine != null) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    user.academicLine!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                if (membership != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    children: [
                      if (membership!.isOwner)
                        const AppBadge(
                          label: 'Dono',
                          variant: BadgeVariant.owner,
                        )
                      else if (membership!.role == MemberRole.admin)
                        const AppBadge(
                          label: 'Admin',
                          variant: BadgeVariant.admin,
                        )
                      else
                        const AppBadge(
                          label: 'Membro',
                          variant: BadgeVariant.member,
                        ),
                      if (membership!.position != null)
                        AppBadge(
                          label: membership!.position!,
                          variant: BadgeVariant.dev,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonalCard extends StatelessWidget {
  const _PersonalCard({required this.user, required this.membership});
  final AppUser user;
  final Member? membership;

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
            'Informações pessoais',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          _Row(label: 'E-mail', value: user.email),
          if (user.phone != null) _Row(label: 'Celular', value: user.phone!),
          if (user.course != null) _Row(label: 'Curso', value: user.course!),
          if (user.semester != null)
            _Row(label: 'Semestre', value: '${user.semester}º período'),
          if (user.uspNumber != null)
            _Row(label: 'Nº USP', value: user.uspNumber!),
          if (membership?.position != null)
            _Row(label: 'Cargo', value: membership!.position!),
          if (user.bio != null && user.bio!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text('Sobre', style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(user.bio!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
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

class _SkillsCard extends StatelessWidget {
  const _SkillsCard({required this.user});
  final AppUser user;

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
            'Habilidades',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          SkillTagList(tags: user.skills),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Interesses',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          SkillTagList(tags: user.interests),
        ],
      ),
    );
  }
}
