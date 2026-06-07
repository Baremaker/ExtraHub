import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../../app/shell/app_shell.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../announcements/presentation/providers/announcements_providers.dart';
import '../../../announcements/presentation/widgets/announcement_card.dart';
import '../../../announcements/presentation/widgets/announcement_form_dialog.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../calendar/presentation/providers/events_providers.dart';
import '../../../calendar/presentation/widgets/event_form_dialog.dart';
import '../../../calendar/presentation/widgets/event_row.dart';
import '../../../extras/presentation/providers/extras_providers.dart';
import '../../../members/domain/member.dart';
import '../../../members/presentation/providers/members_providers.dart';
import '../../../members/presentation/widgets/invite_member_dialog.dart';
import '../../../projects/domain/project.dart';
import '../../../projects/presentation/providers/projects_providers.dart';
import '../../../projects/presentation/widgets/member_projects_card.dart';
import '../../../projects/presentation/widgets/project_form_dialog.dart';

/// Tela inicial pós-login, adaptada ao papel (HU-05).
///
///   * Membro: seus projetos, avisos recentes e próximos eventos.
///   * Admin: visão geral (contadores), atalhos de gestão, além de avisos e
///     eventos.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentAppUserProvider).value;
    final extra = ref.watch(activeExtraProvider).value;
    final isAdmin =
        ref.watch(currentMembershipProvider).value?.role == MemberRole.admin;
    final firstName =
        user == null ? '' : user.displayName.trim().split(' ').first;

    return AppShell(
      title: 'Dashboard',
      subtitle: extra?.name,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (firstName.isNotEmpty)
            Text(
              'Olá, $firstName',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            isAdmin
                ? 'Visão geral, atalhos e gestão da extra.'
                : 'Sua visão geral da extra.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.xl),

          // Contadores e atalhos de navegação — para todos os papéis (HU-05).
          const _StatGrid(),
          const SizedBox(height: AppSpacing.xl),
          const _NavShortcuts(),

          // Gestão — só admin.
          if (isAdmin) ...[
            const SizedBox(height: AppSpacing.xl),
            const _QuickActions(),
          ],

          // Conteúdo personalizado: projetos da pessoa.
          if (user != null) ...[
            const SizedBox(height: AppSpacing.xl),
            MemberProjectsCard(
              uid: user.uid,
              title: 'Meus projetos',
              emptyLabel: 'Você ainda não está alocado em nenhum projeto.',
            ),
          ],
          const SizedBox(height: AppSpacing.xl),

          // Avisos + eventos: lado a lado no desktop, empilhados no mobile.
          LayoutBuilder(
            builder: (context, c) {
              const announcements = _RecentAnnouncements();
              const events = _UpcomingEvents();
              if (c.maxWidth < 720) {
                return const Column(
                  children: [
                    announcements,
                    SizedBox(height: AppSpacing.md),
                    events,
                  ],
                );
              }
              return const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: announcements),
                  SizedBox(width: AppSpacing.md),
                  Expanded(child: events),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// VISÃO GERAL (admin) — contadores
// ════════════════════════════════════════════════════════════════════════════

class _StatGrid extends ConsumerWidget {
  const _StatGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final extra = ref.watch(activeExtraProvider).value;
    final activeMembers = ref.watch(activeMembersProvider).value?.length ?? 0;
    final projects = ref.watch(projectsProvider).value ?? const <Project>[];
    final activeProjects =
        projects.where((p) => p.status == ProjectStatus.active).length;
    final announcements =
        ref.watch(announcementsProvider).value ?? const [];
    final pinned = announcements.where((a) => a.pinned).length;
    final upcoming = ref.watch(upcomingEventsProvider).length;

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
      _StatCard(
        label: 'Avisos',
        value: '${announcements.length}',
        sub: pinned == 0
            ? 'nenhum fixado'
            : '$pinned fixado${pinned > 1 ? 's' : ''}',
      ),
      _StatCard(label: 'Eventos', value: '$upcoming', sub: 'próximos'),
    ];

    return LayoutBuilder(
      builder: (context, c) {
        const gap = AppSpacing.md;
        final cols = c.maxWidth < 600 ? 2 : 4;
        final cardWidth = (c.maxWidth - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: cards
              .map((w) => SizedBox(width: cardWidth, child: w))
              .toList(growable: false),
        );
      },
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
          Text(value, style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height: AppSpacing.xxs),
          Text(sub, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// ATALHOS DE GESTÃO (admin)
// ════════════════════════════════════════════════════════════════════════════

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Atalhos de gestão',
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          _ShortcutButton(
            label: 'Convidar membro',
            icon: Icons.person_add_alt,
            onTap: () => showInviteMemberDialog(context),
          ),
          _ShortcutButton(
            label: 'Novo projeto',
            icon: Icons.add,
            onTap: () => showProjectFormDialog(context),
          ),
          _ShortcutButton(
            label: 'Novo aviso',
            icon: Icons.campaign_outlined,
            onTap: () => showAnnouncementFormDialog(context),
          ),
          _ShortcutButton(
            label: 'Novo evento',
            icon: Icons.event_outlined,
            onTap: () => showEventFormDialog(context),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// ATALHOS DE NAVEGAÇÃO (todos os papéis)
// ════════════════════════════════════════════════════════════════════════════

class _NavShortcuts extends StatelessWidget {
  const _NavShortcuts();

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Atalhos',
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          _ShortcutButton(
            label: 'Projetos',
            icon: Icons.folder_outlined,
            onTap: () => context.goNamed(Routes.projectsName),
          ),
          _ShortcutButton(
            label: 'Membros',
            icon: Icons.people_outline,
            onTap: () => context.goNamed(Routes.membersName),
          ),
          _ShortcutButton(
            label: 'Avisos',
            icon: Icons.campaign_outlined,
            onTap: () => context.goNamed(Routes.announcementsName),
          ),
          _ShortcutButton(
            label: 'Calendário',
            icon: Icons.calendar_today_outlined,
            onTap: () => context.goNamed(Routes.calendarName),
          ),
        ],
      ),
    );
  }
}

/// Botão-atalho do dashboard (estilo "chip" de ação).
class _ShortcutButton extends StatelessWidget {
  const _ShortcutButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgInput,
      borderRadius: AppRadius.radiusMd,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.radiusMd,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            borderRadius: AppRadius.radiusMd,
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: AppColors.accentText),
              const SizedBox(width: AppSpacing.sm),
              Text(label, style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// AVISOS RECENTES / PRÓXIMOS EVENTOS
// ════════════════════════════════════════════════════════════════════════════

class _RecentAnnouncements extends ConsumerWidget {
  const _RecentAnnouncements();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all = ref.watch(announcementsProvider).value ?? const [];
    final items = all.take(3).toList();

    return _SectionCard(
      title: 'Avisos recentes',
      onSeeAll: () => context.goNamed(Routes.announcementsName),
      child: items.isEmpty
          ? const _EmptyLine('Nenhum aviso ainda.')
          : Column(
              children: [
                for (final a in items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: AnnouncementCard(announcement: a),
                  ),
              ],
            ),
    );
  }
}

class _UpcomingEvents extends ConsumerWidget {
  const _UpcomingEvents();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(upcomingEventsProvider).take(4).toList();

    return _SectionCard(
      title: 'Próximos eventos',
      onSeeAll: () => context.goNamed(Routes.calendarName),
      child: items.isEmpty
          ? const _EmptyLine('Nenhum evento próximo.')
          : Column(
              children: [
                for (final e in items)
                  EventRow(
                    event: e,
                    onTap: () => context.goNamed(Routes.calendarName),
                  ),
              ],
            ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// AUXILIARES
// ════════════════════════════════════════════════════════════════════════════

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
    this.onSeeAll,
  });

  final String title;
  final Widget child;
  final VoidCallback? onSeeAll;

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
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              if (onSeeAll != null)
                TextButton(onPressed: onSeeAll, child: const Text('Ver tudo')),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }
}

class _EmptyLine extends StatelessWidget {
  const _EmptyLine(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Text(text, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
