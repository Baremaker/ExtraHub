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
import '../../domain/member.dart';
import '../providers/members_providers.dart';
import '../widgets/invite_member_dialog.dart';
import '../widgets/member_card.dart';

/// Filtro ativo na lista de membros.
enum MemberFilter { all, admins, inactive }

class MembersScreen extends ConsumerStatefulWidget {
  const MembersScreen({super.key});

  @override
  ConsumerState<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends ConsumerState<MembersScreen> {
  MemberFilter _filter = MemberFilter.all;
  String _query = '';

  List<Member> _applyFilters(
    List<Member> active,
    List<Member> inactive,
  ) {
    final source = _filter == MemberFilter.inactive ? inactive : active;
    final filtered = _filter == MemberFilter.admins
        ? source.where((m) => m.role == MemberRole.admin).toList()
        : source;

    if (_query.isEmpty) return filtered;
    final q = _query.toLowerCase();
    return filtered
        .where((m) =>
            m.displayName.toLowerCase().contains(q) ||
            (m.position?.toLowerCase().contains(q) ?? false) ||
            m.email.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final activeAsync = ref.watch(activeMembersProvider);
    final inactiveAsync = ref.watch(inactiveMembersProvider);
    final isAdmin =
        ref.watch(currentMembershipProvider).value?.role == MemberRole.admin;

    final activeCount = activeAsync.value?.length ?? 0;

    return AppShell(
      title: 'Membros',
      subtitle: '$activeCount ativos',
      actions: [
        if (isAdmin)
          AppButton(
            label: 'Convidar',
            icon: Icons.person_add_alt,
            onPressed: () async {
              final ok = await showInviteMemberDialog(context);
              if (ok && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Convite enviado.')),
                );
              }
            },
          ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ─── BUSCA + FILTROS ─────────────────────────────────────────
          _SearchBar(
            onChanged: (v) => setState(() => _query = v),
          ),
          const SizedBox(height: AppSpacing.md),
          _FilterChips(
            current: _filter,
            onChanged: (f) => setState(() => _filter = f),
          ),
          const SizedBox(height: AppSpacing.xl),

          // ─── GRID ────────────────────────────────────────────────────
          activeAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(AppSpacing.xl),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) =>
                ErrorView(message: '$e', onRetry: () => setState(() {})),
            data: (active) => inactiveAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) =>
                  ErrorView(message: '$e', onRetry: () => setState(() {})),
              data: (inactive) {
                final list = _applyFilters(active, inactive);
                return _MembersGrid(
                  members: list,
                  showInviteCard: isAdmin && _filter == MemberFilter.all,
                  onInvite: () => showInviteMemberDialog(context),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// SEARCH BAR
// ════════════════════════════════════════════════════════════════════════════

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onChanged});
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.search, size: 18),
        hintText: 'Buscar por nome, e-mail ou cargo...',
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// FILTER CHIPS
// ════════════════════════════════════════════════════════════════════════════

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.current, required this.onChanged});
  final MemberFilter current;
  final ValueChanged<MemberFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      children: [
        _FilterChip(
          label: 'Todos',
          selected: current == MemberFilter.all,
          onTap: () => onChanged(MemberFilter.all),
        ),
        _FilterChip(
          label: 'Admins',
          selected: current == MemberFilter.admins,
          onTap: () => onChanged(MemberFilter.admins),
        ),
        _FilterChip(
          label: 'Ex-membros',
          selected: current == MemberFilter.inactive,
          onTap: () => onChanged(MemberFilter.inactive),
        ),
      ],
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

// ════════════════════════════════════════════════════════════════════════════
// GRID
// ════════════════════════════════════════════════════════════════════════════

class _MembersGrid extends StatelessWidget {
  const _MembersGrid({
    required this.members,
    required this.showInviteCard,
    required this.onInvite,
  });

  final List<Member> members;
  final bool showInviteCard;
  final VoidCallback onInvite;

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty && !showInviteCard) {
      return const EmptyState(
        icon: Icons.people_outline,
        title: 'Nenhum membro encontrado',
        subtitle: 'Tente ajustar a busca ou os filtros.',
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Grid responsivo via Wrap (mesmo padrão de ProjectsScreen): a altura
        // de cada card acompanha o conteúdo, evitando overflow no mobile.
        const gap = AppSpacing.md;
        final width = constraints.maxWidth;
        final cols = width < 480
            ? 1
            : width < 720
                ? 2
                : width < 1080
                    ? 3
                    : 4;
        final cardWidth = (width - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final m in members)
              SizedBox(
                width: cardWidth,
                child: MemberCard(
                  member: m,
                  onTap: () => context.pushNamed(
                    Routes.memberDetailName,
                    pathParameters: {'uid': m.uid},
                  ),
                ),
              ),
            if (showInviteCard)
              SizedBox(
                width: cardWidth,
                child: InviteMemberCard(onTap: onInvite),
              ),
          ],
        );
      },
    );
  }
}
