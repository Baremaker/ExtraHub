import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../auth/domain/app_user.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../extras/presentation/providers/extras_providers.dart';

/// Placeholder do dashboard (Fase 1.B).
///
/// Confirma que o login funcionou, mostra o usuário e a extra ativa, e
/// permite logout. Será substituído pela Dashboard real na Fase 4.
class DashboardPlaceholderScreen extends ConsumerWidget {
  const DashboardPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentAppUserProvider).value;
    final extraAsync = ref.watch(activeExtraProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(child: AppLogo()),
                  const SizedBox(height: AppSpacing.x3l),

                  if (user != null) _UserCard(user: user),
                  const SizedBox(height: AppSpacing.lg),

                  extraAsync.when(
                    data: (extra) => extra == null
                        ? const SizedBox.shrink()
                        : Container(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            decoration: BoxDecoration(
                              color: AppColors.bgCard,
                              borderRadius: AppRadius.radiusLg,
                              border:
                                  Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'EXTRA ATIVA',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall,
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  extra.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge,
                                ),
                                const SizedBox(height: AppSpacing.xxs),
                                Text(
                                  '${extra.category.label} · '
                                  '${extra.memberCount} membros · '
                                  '${extra.projectCount} projetos',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall,
                                ),
                              ],
                            ),
                          ),
                    loading: () => const Padding(
                      padding: EdgeInsets.all(AppSpacing.xl),
                      child:
                          Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, _) => Text('Erro: $e'),
                  ),

                  const SizedBox(height: AppSpacing.x3l),

                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: const BoxDecoration(
                      color: AppColors.accentDim,
                      borderRadius: AppRadius.radiusLg,
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.construction,
                            color: AppColors.accentText),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Dashboard em construção',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                  color: AppColors.accentText),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Você concluiu a Fase 1.B! Membros, projetos, '
                          'avisos e calendário virão nas próximas fases.',
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    label: 'Trocar de extra',
                    variant: AppButtonVariant.secondary,
                    icon: Icons.swap_horiz,
                    onPressed: user == null
                        ? null
                        : () => ref
                            .read(appUserRepositoryProvider)
                            .setActiveExtra(user.uid, null),
                    fullWidth: true,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Center(
                    child: TextButton(
                      onPressed: () => ref
                          .read(authControllerProvider.notifier)
                          .signOut(),
                      child: const Text('Sair'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({required this.user});
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
      child: Row(
        children: [
          AppAvatar(
            initials: user.initials,
            size: AvatarSize.lg,
            seed: user.uid,
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  user.email,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
