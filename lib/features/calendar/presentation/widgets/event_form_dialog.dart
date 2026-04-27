import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../extras/presentation/providers/extras_providers.dart';
import '../../../projects/presentation/providers/projects_providers.dart';
import '../../domain/app_event.dart';
import '../providers/events_providers.dart';

Future<bool> showEventFormDialog(
  BuildContext context, {
  AppEvent? event,
  DateTime? initialDate,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) =>
        _EventFormDialog(event: event, initialDate: initialDate),
  );
  return result ?? false;
}

class _EventFormDialog extends ConsumerStatefulWidget {
  const _EventFormDialog({this.event, this.initialDate});
  final AppEvent? event;
  final DateTime? initialDate;

  @override
  ConsumerState<_EventFormDialog> createState() =>
      _EventFormDialogState();
}

class _EventFormDialogState extends ConsumerState<_EventFormDialog> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _locationCtrl;
  late DateTime _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;
  late bool _allDay;
  String? _projectId;

  final _formKey = GlobalKey<FormState>();
  bool _busy = false;
  String? _error;

  bool get _isEdit => widget.event != null;

  @override
  void initState() {
    super.initState();
    final e = widget.event;
    _titleCtrl = TextEditingController(text: e?.title ?? '');
    _descCtrl = TextEditingController(text: e?.description ?? '');
    _locationCtrl = TextEditingController(text: e?.location ?? '');
    _allDay = e?.allDay ?? false;
    _projectId = e?.relatedProjectId;

    final startSeed = e?.startDate ?? widget.initialDate ?? DateTime.now();
    _startDate = DateTime(startSeed.year, startSeed.month, startSeed.day);
    _startTime = e == null
        ? const TimeOfDay(hour: 19, minute: 0)
        : TimeOfDay.fromDateTime(e.startDate);

    if (e?.endDate != null) {
      final ed = e!.endDate!;
      _endDate = DateTime(ed.year, ed.month, ed.day);
      _endTime = TimeOfDay.fromDateTime(ed);
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      locale: const Locale('pt', 'BR'),
    );
    if (d != null) setState(() => _startDate = d);
  }

  Future<void> _pickStartTime() async {
    if (_allDay) return;
    final t = await showTimePicker(
      context: context,
      initialTime: _startTime ?? const TimeOfDay(hour: 19, minute: 0),
    );
    if (t != null) setState(() => _startTime = t);
  }

  Future<void> _pickEndDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      locale: const Locale('pt', 'BR'),
    );
    if (d != null) setState(() => _endDate = d);
  }

  Future<void> _pickEndTime() async {
    if (_allDay) return;
    final t = await showTimePicker(
      context: context,
      initialTime: _endTime ?? const TimeOfDay(hour: 20, minute: 0),
    );
    if (t != null) setState(() => _endTime = t);
  }

  DateTime _composeStart() {
    if (_allDay) {
      return DateTime(_startDate.year, _startDate.month, _startDate.day);
    }
    final t = _startTime ?? const TimeOfDay(hour: 19, minute: 0);
    return DateTime(
      _startDate.year,
      _startDate.month,
      _startDate.day,
      t.hour,
      t.minute,
    );
  }

  DateTime? _composeEnd() {
    if (_endDate == null && _endTime == null) return null;
    final base = _endDate ?? _startDate;
    if (_allDay) return DateTime(base.year, base.month, base.day, 23, 59);
    final t = _endTime ?? const TimeOfDay(hour: 20, minute: 0);
    return DateTime(base.year, base.month, base.day, t.hour, t.minute);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final start = _composeStart();
    final end = _composeEnd();
    if (end != null && end.isBefore(start)) {
      setState(() => _error = 'O fim deve ser depois do início.');
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final extra = ref.read(activeExtraProvider).value;
      final firebaseUser = ref.read(currentFirebaseUserProvider);
      if (extra == null || firebaseUser == null) {
        throw StateError('Sessão inválida.');
      }
      final repo = ref.read(eventsRepositoryProvider);
      if (_isEdit) {
        await repo.update(
          extraId: extra.id,
          eventId: widget.event!.id,
          title: _titleCtrl.text,
          description: _descCtrl.text,
          startDate: start,
          endDate: end,
          allDay: _allDay,
          location: _locationCtrl.text,
          relatedProjectId: _projectId,
        );
      } else {
        await repo.create(
          extraId: extra.id,
          title: _titleCtrl.text,
          description: _descCtrl.text,
          startDate: start,
          endDate: end,
          allDay: _allDay,
          location: _locationCtrl.text,
          relatedProjectId: _projectId,
          createdBy: firebaseUser.uid,
        );
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(projectsProvider).value ?? const [];

    return AlertDialog(
      title: Text(_isEdit ? 'Editar evento' : 'Novo evento'),
      contentPadding: const EdgeInsets.fromLTRB(
        AppSpacing.xxl,
        AppSpacing.lg,
        AppSpacing.xxl,
        0,
      ),
      content: SizedBox(
        width: 540,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  label: 'Título',
                  hint: 'Ex: Reunião geral',
                  controller: _titleCtrl,
                  validator: (v) {
                    final value = v?.trim() ?? '';
                    if (value.isEmpty) return 'Informe um título.';
                    if (value.length < 3) return 'Mínimo 3 caracteres.';
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.lg),

                Row(
                  children: [
                    Expanded(
                      child: _PickerField(
                        label: 'Data de início',
                        value: DateFormat('d MMM yyyy', 'pt_BR')
                            .format(_startDate),
                        icon: Icons.calendar_today_outlined,
                        onTap: _pickStartDate,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _PickerField(
                        label: 'Hora de início',
                        value: _allDay
                            ? '—'
                            : (_startTime?.format(context) ?? 'Selecionar'),
                        icon: Icons.access_time,
                        enabled: !_allDay,
                        onTap: _pickStartTime,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: _PickerField(
                        label: 'Data de fim (opc.)',
                        value: _endDate == null
                            ? 'Selecionar'
                            : DateFormat('d MMM yyyy', 'pt_BR')
                                .format(_endDate!),
                        icon: Icons.calendar_today_outlined,
                        onTap: _pickEndDate,
                        onClear: _endDate == null
                            ? null
                            : () => setState(() => _endDate = null),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _PickerField(
                        label: 'Hora de fim (opc.)',
                        value: _allDay
                            ? '—'
                            : (_endTime?.format(context) ?? 'Selecionar'),
                        icon: Icons.access_time,
                        enabled: !_allDay,
                        onTap: _pickEndTime,
                        onClear: _endTime == null
                            ? null
                            : () => setState(() => _endTime = null),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Dia inteiro'),
                  subtitle: Text(
                    'Não exibe horário, ocupa o dia todo no calendário.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  value: _allDay,
                  onChanged:
                      _busy ? null : (v) => setState(() => _allDay = v),
                ),
                const SizedBox(height: AppSpacing.md),

                AppTextField(
                  label: 'Local (opcional)',
                  hint: 'Ex: Sala 5-104 do ICMC, Online (Meet), ...',
                  controller: _locationCtrl,
                ),
                const SizedBox(height: AppSpacing.lg),

                AppTextField(
                  label: 'Descrição (opcional)',
                  hint: 'Pauta, observações, etc.',
                  controller: _descCtrl,
                  maxLines: 4,
                  minLines: 2,
                  maxLength: 800,
                ),
                const SizedBox(height: AppSpacing.lg),

                if (projects.isNotEmpty) ...[
                  Text(
                    'Projeto relacionado (opcional)',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.txtSecondary,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  DropdownButtonFormField<String?>(
                    initialValue: _projectId,
                    onChanged: _busy
                        ? null
                        : (v) => setState(() => _projectId = v),
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('Nenhum'),
                      ),
                      ...projects.map(
                        (p) => DropdownMenuItem<String?>(
                          value: p.id,
                          child: Text(p.name),
                        ),
                      ),
                    ],
                  ),
                ],

                if (_error != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    _error!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.all(AppSpacing.lg),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        AppButton(
          label: _isEdit ? 'Salvar' : 'Criar',
          loading: _busy,
          onPressed: _busy ? null : _submit,
        ),
      ],
    );
  }
}

class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
    this.onClear,
    this.enabled = true,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback? onClear;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.txtSecondary,
              ),
        ),
        const SizedBox(height: AppSpacing.xs),
        InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: AppRadius.radiusMd,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: enabled ? AppColors.bgInput : AppColors.grayDim,
              borderRadius: AppRadius.radiusMd,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(icon,
                    size: 16,
                    color: enabled
                        ? AppColors.txtSecondary
                        : AppColors.txtTertiary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: enabled
                              ? AppColors.txtPrimary
                              : AppColors.txtTertiary,
                        ),
                  ),
                ),
                if (onClear != null && enabled)
                  InkWell(
                    onTap: onClear,
                    borderRadius: BorderRadius.circular(99),
                    child: const Padding(
                      padding: EdgeInsets.all(2),
                      child: Icon(Icons.close,
                          size: 16, color: AppColors.txtTertiary),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
