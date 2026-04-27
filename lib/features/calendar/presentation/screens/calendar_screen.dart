import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/shell/app_shell.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../extras/presentation/providers/extras_providers.dart';
import '../../../members/domain/member.dart';
import '../../../members/presentation/providers/members_providers.dart';
import '../../domain/app_event.dart';
import '../providers/events_providers.dart';
import '../widgets/event_form_dialog.dart';
import '../widgets/event_row.dart';
import '../widgets/month_calendar.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late DateTime _focusedMonth;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month, 1);
    _selectedDay = DateTime(now.year, now.month, now.day);
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Future<void> _delete(AppEvent e) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Excluir evento',
      message: 'O evento "${e.title}" será removido.',
      confirmLabel: 'Excluir',
      danger: true,
    );
    if (!ok) return;
    final extra = ref.read(activeExtraProvider).value;
    if (extra == null) return;
    try {
      await ref.read(eventsRepositoryProvider).delete(
            extraId: extra.id,
            eventId: e.id,
          );
    } catch (err) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erro: $err')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncEvents = ref.watch(eventsProvider);
    final isAdmin =
        ref.watch(currentMembershipProvider).value?.role == MemberRole.admin;

    return AppShell(
      title: 'Calendário',
      actions: [
        if (isAdmin)
          AppButton(
            label: 'Novo evento',
            icon: Icons.add,
            onPressed: () => showEventFormDialog(
              context,
              initialDate: _selectedDay,
            ),
          ),
      ],
      child: asyncEvents.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(message: '$e'),
        data: (allEvents) {
          if (allEvents.isEmpty) {
            return EmptyState(
              icon: Icons.calendar_today_outlined,
              title: 'Nenhum evento ainda',
              subtitle: isAdmin
                  ? 'Crie o primeiro evento para a sua extra.'
                  : 'Quando os admins agendarem, aparece aqui.',
              action: isAdmin
                  ? AppButton(
                      label: 'Criar evento',
                      icon: Icons.add,
                      onPressed: () => showEventFormDialog(context),
                    )
                  : null,
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final twoCols = constraints.maxWidth >= 900;
              return twoCols
                  ? _DesktopLayout(
                      events: allEvents,
                      focusedMonth: _focusedMonth,
                      selectedDay: _selectedDay,
                      isAdmin: isAdmin,
                      onMonthPrev: () => setState(() => _focusedMonth =
                          DateTime(_focusedMonth.year,
                              _focusedMonth.month - 1, 1)),
                      onMonthNext: () => setState(() => _focusedMonth =
                          DateTime(_focusedMonth.year,
                              _focusedMonth.month + 1, 1)),
                      onDaySelected: (d) => setState(() => _selectedDay = d),
                      onEdit: (e) =>
                          showEventFormDialog(context, event: e),
                      onDelete: _delete,
                      sameDay: _sameDay,
                    )
                  : _MobileLayout(
                      events: allEvents,
                      isAdmin: isAdmin,
                      onEdit: (e) =>
                          showEventFormDialog(context, event: e),
                      onDelete: _delete,
                    );
            },
          );
        },
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// LAYOUT DESKTOP (>= 900px): calendário à esquerda + lista à direita
// ════════════════════════════════════════════════════════════════════════════

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.events,
    required this.focusedMonth,
    required this.selectedDay,
    required this.isAdmin,
    required this.onMonthPrev,
    required this.onMonthNext,
    required this.onDaySelected,
    required this.onEdit,
    required this.onDelete,
    required this.sameDay,
  });

  final List<AppEvent> events;
  final DateTime focusedMonth;
  final DateTime selectedDay;
  final bool isAdmin;
  final VoidCallback onMonthPrev;
  final VoidCallback onMonthNext;
  final ValueChanged<DateTime> onDaySelected;
  final void Function(AppEvent) onEdit;
  final void Function(AppEvent) onDelete;
  final bool Function(DateTime a, DateTime b) sameDay;

  @override
  Widget build(BuildContext context) {
    final eventsOfDay =
        events.where((e) => sameDay(e.startDate, selectedDay)).toList();
    final upcoming = events
        .where((e) => !e.startDate.isBefore(
              DateTime.now().subtract(const Duration(hours: 1)),
            ))
        .take(8)
        .toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: MonthCalendar(
            month: focusedMonth,
            events: events,
            selectedDay: selectedDay,
            onDaySelected: onDaySelected,
            onPrevMonth: onMonthPrev,
            onNextMonth: onMonthNext,
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CardSection(
                title: 'Eventos do dia',
                emptyText: 'Nenhum evento para o dia selecionado.',
                events: eventsOfDay,
                isAdmin: isAdmin,
                onEdit: onEdit,
                onDelete: onDelete,
              ),
              const SizedBox(height: AppSpacing.md),
              _CardSection(
                title: 'Próximos eventos',
                emptyText: 'Nada agendado nos próximos dias.',
                events: upcoming,
                isAdmin: isAdmin,
                onEdit: onEdit,
                onDelete: onDelete,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// LAYOUT MOBILE: só lista de próximos
// ════════════════════════════════════════════════════════════════════════════

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.events,
    required this.isAdmin,
    required this.onEdit,
    required this.onDelete,
  });

  final List<AppEvent> events;
  final bool isAdmin;
  final void Function(AppEvent) onEdit;
  final void Function(AppEvent) onDelete;

  @override
  Widget build(BuildContext context) {
    final upcoming = events
        .where((e) => !e.startDate.isBefore(
              DateTime.now().subtract(const Duration(hours: 1)),
            ))
        .toList();
    final past = events
        .where((e) => e.startDate.isBefore(
              DateTime.now().subtract(const Duration(hours: 1)),
            ))
        .toList()
        .reversed
        .take(10)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CardSection(
          title: 'Próximos eventos',
          emptyText: 'Nada agendado.',
          events: upcoming,
          isAdmin: isAdmin,
          onEdit: onEdit,
          onDelete: onDelete,
        ),
        if (past.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          _CardSection(
            title: 'Anteriores',
            emptyText: '',
            events: past,
            isAdmin: isAdmin,
            onEdit: onEdit,
            onDelete: onDelete,
          ),
        ],
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// CARD SECTION
// ════════════════════════════════════════════════════════════════════════════

class _CardSection extends StatelessWidget {
  const _CardSection({
    required this.title,
    required this.emptyText,
    required this.events,
    required this.isAdmin,
    required this.onEdit,
    required this.onDelete,
  });

  final String title;
  final String emptyText;
  final List<AppEvent> events;
  final bool isAdmin;
  final void Function(AppEvent) onEdit;
  final void Function(AppEvent) onDelete;

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
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          if (events.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Text(
                emptyText,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            )
          else
            ...events.map(
              (e) => EventRow(
                event: e,
                onEdit: isAdmin ? () => onEdit(e) : null,
                onDelete: isAdmin ? () => onDelete(e) : null,
              ),
            ),
        ],
      ),
    );
  }
}
