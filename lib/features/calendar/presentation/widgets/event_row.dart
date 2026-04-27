import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/extensions/date_format_x.dart';
import '../../domain/app_event.dart';

/// Linha de evento estilo `.row-item` do protótipo: data à esquerda
/// (dia grande + mês pequeno) + título + sub (horário · local).
class EventRow extends StatelessWidget {
  const EventRow({
    super.key,
    required this.event,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.dayColor,
  });

  final AppEvent event;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  /// Cor do número do dia (esquerda do card). Se nulo, alterna entre
  /// accentText / blueText / amberText conforme [event.startDate.day].
  final Color? dayColor;

  bool get _hasAdminActions => onEdit != null || onDelete != null;

  Color _resolvedDayColor() {
    if (dayColor != null) return dayColor!;
    final mod = event.startDate.day % 3;
    return mod == 0
        ? AppColors.amberText
        : mod == 1
            ? AppColors.accentText
            : AppColors.blueText;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (day, month) = DateFormatX.dayMonth(event.startDate);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadius.radiusMd,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Data à esquerda
              SizedBox(
                width: 40,
                child: Column(
                  children: [
                    Text(
                      day,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: _resolvedDayColor(),
                      ),
                    ),
                    Text(
                      month,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.txtTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              // Conteúdo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: theme.textTheme.headlineSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _subline(),
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              if (_hasAdminActions)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 18),
                  tooltip: 'Ações',
                  onSelected: (v) {
                    switch (v) {
                      case 'edit':
                        onEdit?.call();
                      case 'delete':
                        onDelete?.call();
                    }
                  },
                  itemBuilder: (_) => [
                    if (onEdit != null)
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Editar'),
                      ),
                    if (onDelete != null)
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Excluir'),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _subline() {
    final time = event.allDay
        ? 'O dia todo'
        : DateFormatX.timeRange(event.startDate, event.endDate);
    if (event.location != null && event.location!.isNotEmpty) {
      return '$time · ${event.location}';
    }
    return time;
  }
}
