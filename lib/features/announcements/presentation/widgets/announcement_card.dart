import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/extensions/date_format_x.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../domain/announcement.dart';

/// Card de aviso. Quando [announcement.pinned] é `true`, ganha borda
/// esquerda âmbar (espelha `.notice-card.urgent` do protótipo, mas
/// generalizado pra "Fixado").
class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({
    super.key,
    required this.announcement,
    this.onTap,
    this.onEdit,
    this.onTogglePin,
    this.onDelete,
  });

  final Announcement announcement;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onTogglePin;
  final VoidCallback? onDelete;

  bool get _hasAdminActions =>
      onEdit != null || onTogglePin != null || onDelete != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pinned = announcement.pinned;

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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (pinned)
                Container(
                  width: 3,
                  margin: const EdgeInsets.only(right: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.amber,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ─── Topo: título + badge "Fixado" ──────────────
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            announcement.title,
                            style: theme.textTheme.headlineMedium,
                          ),
                        ),
                        if (pinned) ...[
                          const SizedBox(width: AppSpacing.sm),
                          const AppBadge(
                            label: 'Fixado',
                            variant: BadgeVariant.idea,
                            icon: Icons.push_pin,
                          ),
                        ],
                        if (_hasAdminActions) ...[
                          const SizedBox(width: AppSpacing.xs),
                          _AdminMenu(
                            pinned: pinned,
                            onEdit: onEdit,
                            onTogglePin: onTogglePin,
                            onDelete: onDelete,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // ─── Corpo ───────────────────────────────────────
                    Text(
                      announcement.body,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // ─── Footer: autor + data ────────────────────────
                    Row(
                      children: [
                        AppAvatar(
                          initials:
                              _initialsFor(announcement.author.displayName),
                          size: AvatarSize.xs,
                          seed: announcement.author.uid,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          announcement.author.displayName,
                          style: theme.textTheme.bodySmall,
                        ),
                        const Spacer(),
                        Text(
                          DateFormatX.relative(announcement.createdAt),
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
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
}

/// Menu de ações do admin no card (kebab "⋯").
class _AdminMenu extends StatelessWidget {
  const _AdminMenu({
    required this.pinned,
    required this.onEdit,
    required this.onTogglePin,
    required this.onDelete,
  });

  final bool pinned;
  final VoidCallback? onEdit;
  final VoidCallback? onTogglePin;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 18),
      tooltip: 'Ações',
      onSelected: (v) {
        switch (v) {
          case 'edit':
            onEdit?.call();
          case 'pin':
            onTogglePin?.call();
          case 'delete':
            onDelete?.call();
        }
      },
      itemBuilder: (_) => [
        if (onEdit != null)
          const PopupMenuItem(value: 'edit', child: Text('Editar')),
        if (onTogglePin != null)
          PopupMenuItem(
            value: 'pin',
            child: Text(pinned ? 'Desfixar' : 'Fixar no topo'),
          ),
        if (onDelete != null)
          const PopupMenuItem(
            value: 'delete',
            child: Text('Excluir'),
          ),
      ],
    );
  }
}
