import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/shell/app_shell.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../extras/presentation/providers/extras_providers.dart';
import '../../../members/domain/member.dart';
import '../../../members/presentation/providers/members_providers.dart';
import '../../domain/announcement.dart';
import '../providers/announcements_providers.dart';
import '../widgets/announcement_card.dart';
import '../widgets/announcement_form_dialog.dart';

class AnnouncementsScreen extends ConsumerWidget {
  const AnnouncementsScreen({super.key});

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    Announcement a,
  ) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Excluir aviso',
      message: 'Esta ação remove o aviso "${a.title}" definitivamente.',
      confirmLabel: 'Excluir',
      danger: true,
    );
    if (!ok) return;
    final extra = ref.read(activeExtraProvider).value;
    if (extra == null) return;
    try {
      await ref.read(announcementsRepositoryProvider).delete(
            extraId: extra.id,
            announcementId: a.id,
          );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erro: $e')));
      }
    }
  }

  Future<void> _togglePin(
    BuildContext context,
    WidgetRef ref,
    Announcement a,
  ) async {
    final extra = ref.read(activeExtraProvider).value;
    if (extra == null) return;
    try {
      await ref.read(announcementsRepositoryProvider).togglePinned(
            extraId: extra.id,
            announcementId: a.id,
            pinned: !a.pinned,
          );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erro: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncList = ref.watch(announcementsProvider);
    final isAdmin =
        ref.watch(currentMembershipProvider).value?.role == MemberRole.admin;

    return AppShell(
      title: 'Mural de Avisos',
      actions: [
        if (isAdmin)
          AppButton(
            label: 'Novo aviso',
            icon: Icons.add,
            onPressed: () => showAnnouncementFormDialog(context),
          ),
      ],
      child: asyncList.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(message: '$e'),
        data: (all) {
          if (all.isEmpty) {
            return EmptyState(
              icon: Icons.campaign_outlined,
              title: 'Nenhum aviso ainda',
              subtitle: isAdmin
                  ? 'Que tal publicar o primeiro?'
                  : 'Quando os admins publicarem, aparece aqui.',
              action: isAdmin
                  ? AppButton(
                      label: 'Publicar aviso',
                      icon: Icons.add,
                      onPressed: () =>
                          showAnnouncementFormDialog(context),
                    )
                  : null,
            );
          }

          final pinned = all.where((a) => a.pinned).toList();
          final others = all.where((a) => !a.pinned).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (pinned.isNotEmpty) ...[
                const _SectionLabel(label: 'FIXADOS'),
                const SizedBox(height: AppSpacing.sm),
                ...pinned.map(
                  (a) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: AnnouncementCard(
                      announcement: a,
                      onEdit: isAdmin
                          ? () => showAnnouncementFormDialog(
                                context,
                                announcement: a,
                              )
                          : null,
                      onTogglePin:
                          isAdmin ? () => _togglePin(context, ref, a) : null,
                      onDelete:
                          isAdmin ? () => _delete(context, ref, a) : null,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              if (others.isNotEmpty) ...[
                _SectionLabel(
                  label: pinned.isEmpty ? 'AVISOS' : 'OUTROS AVISOS',
                ),
                const SizedBox(height: AppSpacing.sm),
                ...others.map(
                  (a) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: AnnouncementCard(
                      announcement: a,
                      onEdit: isAdmin
                          ? () => showAnnouncementFormDialog(
                                context,
                                announcement: a,
                              )
                          : null,
                      onTogglePin:
                          isAdmin ? () => _togglePin(context, ref, a) : null,
                      onDelete:
                          isAdmin ? () => _delete(context, ref, a) : null,
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(label, style: Theme.of(context).textTheme.labelSmall);
  }
}
