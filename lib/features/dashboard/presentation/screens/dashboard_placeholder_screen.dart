import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/shell/app_shell.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../extras/presentation/providers/extras_providers.dart';
import '../../../members/presentation/providers/members_providers.dart';
import '../../../projects/domain/project.dart';
import '../../../projects/presentation/providers/projects_providers.dart';

/// Placeholder do dashboard usado até a Fase 4 (dashboard agregador real).
class DashboardPlaceholderScreen extends ConsumerWidget {
  const DashboardPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentAppUserProvider).value;
    final extra = ref.watch(activeExtraProvider).value;
    final activeMembers = ref.watch(activeMembersProvider).value?.length ?? 0;
    final projects = ref.watch(projectsProvider).value ?? const <Project>[];
    final activeProjects = projects
        .where((p) => p.status == ProjectStatus.active)
        .length;

    return AppShell(
      title: 'Dashboard',
      subtitle: extra?.name,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (user != null)
            Text(
              'Olá, ${user.displayName.split(' ').first}',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          const SizedBox(height: AppSpacing.lg),

          // ─── STATS ───────────────────────────────────────────────────
          LayoutBuilder(
            builder: (context, c) {
              const gap = AppSpacing.md;
              final cols = c.maxWidth < 600 ? 2 : 4;
              final cardWidth = (c.maxWidth - gap * (cols - 1)) / cols;
              final cards = <Widget>[
                _StatCard(
                  label: 'Membros ativos',
                  value: '$activeMembers',
                  sub: extra == null ? '—' : 'na ${extra.name}',
                ),
                _StatCard(
                  label: 'Projetos',
                  value: '${projects.length}',
                  sub: '$activeProjects em andamento',
                ),
                const _StatCard(
                  label: 'Avisos',
                  value: '—',
                  sub: 'em breve',
                ),
                const _StatCard(
                  label: 'Eventos',
                  value: '—',
                  sub: 'em breve',
                ),
              ];
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: cards
                    .map((w) => SizedBox(width: cardWidth, child: w))
                    .toList(growable: false),
              );
            },
          ),

          const SizedBox(height: AppSpacing.xl),

          // ─── BOAS-VINDAS ─────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: const BoxDecoration(
              color: AppColors.accentDim,
              borderRadius: AppRadius.radiusLg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.celebration_outlined,
                        color: AppColors.accentText),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Bem-vindo(a) ao ExtraHub',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'A Fase 3 do desenvolvimento está concluída — agora o app '
                  'tem gestão de membros, perfil e projetos completos. '
                  'Avisos e calendário virão nas próximas fases.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.sub,
  });

  final String label;
  final String value;
  final String sub;

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(sub, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
