import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_badge.dart';
import '../../domain/member.dart';

/// Card de membro usado na grid de [MembersScreen].
///
/// Mostra avatar, nome, cargo (`position`) ou rótulo do role, badge colorido
/// (Owner/Admin/Membro/Inativo). Skills/curso ficam para a tela de detalhe
/// para evitar lookups N+1.
class MemberCard extends StatelessWidget {
  const MemberCard({
    super.key,
    required this.member,
    required this.onTap,
  });

  final Member member;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppAvatar(
                initials: member.initials,
                size: AvatarSize.lg,
                seed: member.uid,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                member.displayName,
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                member.position ?? member.role.label,
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.sm),
              _RoleBadge(member: member),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.member});
  final Member member;

  @override
  Widget build(BuildContext context) {
    if (member.status == MemberStatus.inactive) {
      return const AppBadge(
        label: 'Ex-membro',
        variant: BadgeVariant.inactive,
      );
    }
    if (member.isOwner) {
      return const AppBadge(label: 'Dono', variant: BadgeVariant.owner);
    }
    if (member.role == MemberRole.admin) {
      return const AppBadge(label: 'Admin', variant: BadgeVariant.admin);
    }
    return const AppBadge(label: 'Membro', variant: BadgeVariant.member);
  }
}

/// Card "Convidar membro" (estilo `.member-card.dashed` do protótipo).
///
/// Visualmente igual a um card normal, mas com borda tracejada e sem
/// avatar de pessoa.
class InviteMemberCard extends StatelessWidget {
  const InviteMemberCard({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadius.radiusLg,
        onTap: onTap,
        child: DottedBorderContainer(
          borderRadius: AppRadius.radiusLg,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.bgHover,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.txtTertiary,
                    size: 22,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Convidar membro',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.txtTertiary,
                      ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Enviar convite por e-mail',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                // Espaço reservado para alinhar altura com [MemberCard]
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Container com borda tracejada (Flutter não tem isso nativo).
///
/// Implementação simples: usa `CustomPaint` para desenhar borda dashed.
class DottedBorderContainer extends StatelessWidget {
  const DottedBorderContainer({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.color = AppColors.borderMd,
    this.dashWidth = 4,
    this.dashSpace = 4,
    this.strokeWidth = 1,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final Color color;
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: color,
        radius: borderRadius.topLeft.x,
        dashWidth: dashWidth,
        dashSpace: dashSpace,
        strokeWidth: strokeWidth,
      ),
      child: child,
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({
    required this.color,
    required this.radius,
    required this.dashWidth,
    required this.dashSpace,
    required this.strokeWidth,
  });

  final Color color;
  final double radius;
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    final dashed = Path();
    for (final metric in path.computeMetrics()) {
      double dist = 0;
      while (dist < metric.length) {
        final next = dist + dashWidth;
        dashed.addPath(metric.extractPath(dist, next), Offset.zero);
        dist = next + dashSpace;
      }
    }
    canvas.drawPath(dashed, paint);
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) =>
      color != old.color ||
      radius != old.radius ||
      dashWidth != old.dashWidth ||
      dashSpace != old.dashSpace ||
      strokeWidth != old.strokeWidth;
}
