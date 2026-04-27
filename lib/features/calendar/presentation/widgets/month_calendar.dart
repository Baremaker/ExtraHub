import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/extensions/date_format_x.dart';
import '../../domain/app_event.dart';

/// Calendário mensal simples (sem libs externas).
///
/// Mostra os 7 dias da semana como cabeçalho (D/S/T/Q/Q/S/S) e uma grid 6x7
/// com os dias do mês. Dias fora do mês ficam esmaecidos. Dias com eventos
/// recebem um pontinho verde abaixo do número. O dia selecionado fica
/// destacado em verde.
class MonthCalendar extends StatelessWidget {
  const MonthCalendar({
    super.key,
    required this.month,
    required this.events,
    required this.selectedDay,
    required this.onDaySelected,
    required this.onPrevMonth,
    required this.onNextMonth,
  });

  /// Mês a exibir. Usa-se `year`/`month` apenas; o `day` é ignorado.
  final DateTime month;
  final List<AppEvent> events;
  final DateTime selectedDay;
  final ValueChanged<DateTime> onDaySelected;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _hasEvents(DateTime day) => events.any((e) => _sameDay(e.startDate, day));

  @override
  Widget build(BuildContext context) {
    final firstOfMonth = DateTime(month.year, month.month, 1);
    // Dart: weekday é 1 (Mon) a 7 (Sun). Queremos começar no domingo (col=0).
    final leading = firstOfMonth.weekday % 7;
    final daysInMonth =
        DateUtils.getDaysInMonth(month.year, month.month);
    final totalCells = ((leading + daysInMonth) / 7.0).ceil() * 7;

    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.radiusLg,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // ─── Header ───────────────────────────────────────────────
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, size: 18),
                onPressed: onPrevMonth,
                tooltip: 'Mês anterior',
              ),
              Expanded(
                child: Center(
                  child: Text(
                    DateFormatX.monthYear(firstOfMonth),
                    style: theme.textTheme.headlineMedium,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, size: 18),
                onPressed: onNextMonth,
                tooltip: 'Próximo mês',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // ─── Cabeçalho dos dias da semana ─────────────────────────
          const _WeekHeader(),
          const SizedBox(height: AppSpacing.xs),

          // ─── Grid ────────────────────────────────────────────────
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 1,
            ),
            itemCount: totalCells,
            itemBuilder: (_, idx) {
              final dayNum = idx - leading + 1;
              final inMonth = dayNum >= 1 && dayNum <= daysInMonth;
              final date = inMonth
                  ? DateTime(month.year, month.month, dayNum)
                  : null;
              if (!inMonth) return const SizedBox.shrink();

              final isSelected = _sameDay(date!, selectedDay);
              final isToday = _sameDay(date, DateTime.now());
              final hasEvent = _hasEvents(date);

              return _DayCell(
                day: dayNum,
                selected: isSelected,
                isToday: isToday,
                hasEvent: hasEvent,
                onTap: () => onDaySelected(date),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _WeekHeader extends StatelessWidget {
  const _WeekHeader();

  static const _labels = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _labels
          .map(
            (l) => Expanded(
              child: Center(
                child: Text(l, style: Theme.of(context).textTheme.labelSmall),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.selected,
    required this.isToday,
    required this.hasEvent,
    required this.onTap,
  });

  final int day;
  final bool selected;
  final bool isToday;
  final bool hasEvent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? AppColors.accent
        : isToday
            ? AppColors.bgHover
            : Colors.transparent;
    final fg = selected
        ? Colors.white
        : isToday
            ? AppColors.accentText
            : AppColors.txtPrimary;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              '$day',
              style: TextStyle(
                fontSize: 13,
                color: fg,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            if (hasEvent && !selected)
              Positioned(
                bottom: 4,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
