import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/app_avatar.dart';
import '../../features/auth/domain/app_user.dart';
import '../../features/auth/presentation/providers/auth_controller.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/extras/presentation/providers/extras_providers.dart';
import '../../features/members/presentation/providers/members_providers.dart';
import '../router/routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

const double kSidebarWidth = 220;

class Sidebar extends ConsumerWidget {
  const Sidebar({super.key, this.onNavigate});

  final VoidCallback? onNavigate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeExtra = ref.watch(activeExtraProvider).value;
    final appUser = ref.watch(currentAppUserProvider).value;
    final isAdmin =
        ref.watch(currentMembershipProvider).value?.role.name == 'admin';
    final loc = GoRouterState.of(context).matchedLocation;

    return Container(
      width: kSidebarWidth,
      decoration: const BoxDecoration(
        color: AppColors.bgCard,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ─── LOGO + NOME DA EXTRA ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'ExtraHub',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
                if (activeExtra != null) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: Text(
                      activeExtra.name,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1),

          // ─── NAV ──────────────────────────────────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.md,
                horizontal: AppSpacing.sm,
              ),
              children: [
                const _NavSection(label: 'PRINCIPAL'),
                _NavItem(
                  label: 'Dashboard',
                  icon: Icons.dashboard_outlined,
                  active: loc == Routes.dashboard,
                  onTap: () => _go(context, Routes.dashboardName),
                ),
                _NavItem(
                  label: 'Projetos',
                  icon: Icons.folder_outlined,
                  active: loc.startsWith(Routes.projects),
                  onTap: () => _go(context, Routes.projectsName),
                ),
                _NavItem(
                  label: 'Membros',
                  icon: Icons.people_outline,
                  active: loc.startsWith(Routes.members),
                  onTap: () => _go(context, Routes.membersName),
                ),
                _NavItem(
                  label: 'Avisos',
                  icon: Icons.campaign_outlined,
                  active: loc.startsWith(Routes.announcements),
                  onTap: () => _go(context, Routes.announcementsName),
                ),
                _NavItem(
                  label: 'Calendário',
                  icon: Icons.calendar_today_outlined,
                  active: loc.startsWith(Routes.calendar),
                  onTap: () => _go(context, Routes.calendarName),
                ),

                const SizedBox(height: AppSpacing.md),
                const _NavSection(label: 'PESSOAL'),
                _NavItem(
                  label: 'Meu perfil',
                  icon: Icons.person_outline,
                  active: loc == Routes.profile,
                  onTap: () => _go(context, Routes.profileName),
                ),
                _NavItem(
                  label: 'Trocar de extra',
                  icon: Icons.swap_horiz,
                  active: false,
                  onTap: () => _switchExtra(ref),
                ),
                if (isAdmin) ...[
                  const SizedBox(height: AppSpacing.md),
                  const _NavSection(label: 'ADMINISTRAÇÃO'),
                  _NavItem(
                    label: 'Configurações',
                    icon: Icons.settings_outlined,
                    active: false,
                    enabled: false,
                    onTap: () {},
                  ),
                ],
              ],
            ),
          ),

          if (appUser != null) _UserCard(user: appUser),
        ],
      ),
    );
  }

  void _go(BuildContext context, String name) {
    context.goNamed(name);
    onNavigate?.call();
  }

  Future<void> _switchExtra(WidgetRef ref) async {
    final user = ref.read(currentAppUserProvider).value;
    if (user == null) return;
    await ref.read(appUserRepositoryProvider).setActiveExtra(user.uid, null);
    onNavigate?.call();
  }
}

class _NavSection extends StatelessWidget {
  const _NavSection({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: Text(label, style: AppTypography.navSection),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
    this.enabled = true,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final fg = active
        ? AppColors.accentText
        : enabled
            ? AppColors.txtPrimary
            : AppColors.txtTertiary;
    final bg = active ? AppColors.accentDim : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Material(
        color: bg,
        borderRadius: AppRadius.radiusSm,
        child: InkWell(
          borderRadius: AppRadius.radiusSm,
          onTap: enabled ? onTap : null,
          child: Container(
            constraints: const BoxConstraints(minHeight: 44),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              children: [
                Icon(icon, size: 16, color: fg),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: active ? FontWeight.w500 : FontWeight.w400,
                      color: fg,
                    ),
                  ),
                ),
                if (!enabled)
                  const Text(
                    'em breve',
                    style: TextStyle(
                      fontSize: 9,
                      color: AppColors.txtTertiary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserCard extends ConsumerWidget {
  const _UserCard({required this.user});
  final AppUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membership = ref.watch(currentMembershipProvider).value;
    final roleLabel = switch ((membership?.isOwner ?? false, membership?.role.name)) {
      (true, _) => 'Dono',
      (false, 'admin') => 'Admin',
      _ => 'Membro',
    };

    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          AppAvatar(
            initials: user.initials,
            size: AvatarSize.md,
            seed: user.uid,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName.split(' ').take(2).join(' '),
                  style: Theme.of(context).textTheme.labelLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  roleLabel,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, size: 16),
            tooltip: 'Sair',
            onPressed: () =>
                ref.read(authControllerProvider.notifier).signOut(),
          ),
        ],
      ),
    );
  }
}
