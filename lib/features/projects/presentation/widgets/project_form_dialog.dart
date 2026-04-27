import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../extras/presentation/providers/extras_providers.dart';
import '../../../members/domain/member.dart';
import '../../../members/presentation/providers/members_providers.dart';
import '../../domain/project.dart';
import '../providers/projects_providers.dart';

/// Mostra o diálogo de criação ou edição de projeto.
///
/// Se [project] for null, é criação; caso contrário é edição.
/// Retorna `true` se o projeto foi salvo.
Future<bool> showProjectFormDialog(
  BuildContext context, {
  Project? project,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _ProjectFormDialog(project: project),
  );
  return result ?? false;
}

class _ProjectFormDialog extends ConsumerStatefulWidget {
  const _ProjectFormDialog({this.project});
  final Project? project;

  @override
  ConsumerState<_ProjectFormDialog> createState() =>
      _ProjectFormDialogState();
}

class _ProjectFormDialogState extends ConsumerState<_ProjectFormDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _categoryCtrl;
  late ProjectStatus _status;
  late ProjectColor _color;
  late int _progress;
  DateTime? _startDate;
  DateTime? _dueDate;
  late Set<String> _selectedUids;
  String? _ownerUid;
  late List<ProjectLink> _links;

  final _newLinkLabelCtrl = TextEditingController();
  final _newLinkUrlCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _busy = false;
  String? _error;

  bool get _isEdit => widget.project != null;

  @override
  void initState() {
    super.initState();
    final p = widget.project;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _descCtrl = TextEditingController(text: p?.description ?? '');
    _categoryCtrl = TextEditingController(text: p?.category ?? '');
    _status = p?.status ?? ProjectStatus.planning;
    _color = p?.color ?? ProjectColor.green;
    _progress = p?.progress ?? 0;
    _startDate = p?.startDate;
    _dueDate = p?.dueDate;
    _selectedUids = p?.members.map((m) => m.uid).toSet() ?? <String>{};
    _ownerUid = p?.ownerId;
    _links = List.of(p?.links ?? const <ProjectLink>[]);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _categoryCtrl.dispose();
    _newLinkLabelCtrl.dispose();
    _newLinkUrlCtrl.dispose();
    super.dispose();
  }

  // ─── Helpers ────────────────────────────────────────────────────────────
  Future<DateTime?> _pickDate(DateTime? initial) {
    return showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      locale: const Locale('pt', 'BR'),
    );
  }

  void _toggleMember(Member m, {required bool selected}) {
    setState(() {
      if (selected) {
        _selectedUids.add(m.uid);
        _ownerUid ??= m.uid;
      } else {
        _selectedUids.remove(m.uid);
        if (_ownerUid == m.uid) {
          _ownerUid = _selectedUids.isEmpty ? null : _selectedUids.first;
        }
      }
    });
  }

  void _addLink() {
    final label = _newLinkLabelCtrl.text.trim();
    final url = _newLinkUrlCtrl.text.trim();
    if (label.isEmpty || url.isEmpty) return;
    setState(() {
      _links = [..._links, ProjectLink(label: label, url: url)];
      _newLinkLabelCtrl.clear();
      _newLinkUrlCtrl.clear();
    });
  }

  void _removeLink(int idx) {
    setState(() => _links = [..._links]..removeAt(idx));
  }

  Future<void> _submit(List<Member> activeMembers) async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedUids.isEmpty) {
      setState(() => _error = 'Selecione ao menos um membro.');
      return;
    }
    if (_ownerUid == null || !_selectedUids.contains(_ownerUid)) {
      setState(() => _error = 'O líder precisa ser um dos membros alocados.');
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
        throw StateError('Dados de sessão ausentes.');
      }

      // Constrói lista de [ProjectMemberRef] a partir dos uids selecionados.
      final byUid = {for (final m in activeMembers) m.uid: m};
      final memberRefs = _selectedUids.map((uid) {
        final m = byUid[uid];
        if (m == null) {
          throw StateError('Membro $uid não está mais ativo.');
        }
        return ProjectMemberRef(
          uid: m.uid,
          displayName: m.displayName,
          photoURL: m.photoURL,
        );
      }).toList();

      final repo = ref.read(projectsRepositoryProvider);
      if (_isEdit) {
        await repo.updateProject(
          extraId: extra.id,
          projectId: widget.project!.id,
          name: _nameCtrl.text,
          description: _descCtrl.text,
          status: _status,
          category: _categoryCtrl.text,
          color: _color,
          startDate: _startDate,
          dueDate: _dueDate,
          progress: _progress,
          ownerId: _ownerUid!,
          members: memberRefs,
          links: _links,
        );
      } else {
        await repo.createProject(
          extraId: extra.id,
          name: _nameCtrl.text,
          description: _descCtrl.text,
          status: _status,
          category: _categoryCtrl.text,
          color: _color,
          startDate: _startDate,
          dueDate: _dueDate,
          progress: _progress,
          ownerId: _ownerUid!,
          members: memberRefs,
          links: _links,
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

  // ─── Build ──────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final activeMembersAsync = ref.watch(activeMembersProvider);

    return AlertDialog(
      title: Text(_isEdit ? 'Editar projeto' : 'Novo projeto'),
      contentPadding: const EdgeInsets.fromLTRB(
        AppSpacing.xxl,
        AppSpacing.lg,
        AppSpacing.xxl,
        0,
      ),
      content: SizedBox(
        width: 640,
        height: 600,
        child: activeMembersAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Erro: $e')),
          data: (members) => _buildForm(context, members),
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
          onPressed: _busy
              ? null
              : () => _submit(activeMembersAsync.value ?? const []),
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context, List<Member> activeMembers) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ─── BÁSICO ─────────────────────────────────────────────
            AppTextField(
              label: 'Nome do projeto',
              hint: 'Ex: ExtraHub — App de Gestão',
              controller: _nameCtrl,
              validator: (v) {
                final value = v?.trim() ?? '';
                if (value.isEmpty) return 'Informe um nome.';
                if (value.length < 3) return 'Mínimo 3 caracteres.';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Descrição',
              hint: 'O que esse projeto entrega?',
              controller: _descCtrl,
              maxLines: 3,
              minLines: 2,
              maxLength: 500,
            ),
            const SizedBox(height: AppSpacing.lg),

            // ─── STATUS ─────────────────────────────────────────────
            const _SectionTitle('Status'),
            DropdownButtonFormField<ProjectStatus>(
              initialValue: _status,
              onChanged: _busy
                  ? null
                  : (v) {
                      if (v == null) return;
                      setState(() {
                        _status = v;
                        if (v == ProjectStatus.completed) _progress = 100;
                      });
                    },
              items: ProjectStatus.values
                  .map((s) =>
                      DropdownMenuItem(value: s, child: Text(s.label)))
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.lg),

            // ─── COR ────────────────────────────────────────────────
            const _SectionTitle('Cor da barra de progresso'),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: ProjectColor.values
                  .map((c) => _ColorChip(
                        color: c,
                        selected: _color == c,
                        onTap: () => setState(() => _color = c),
                      ))
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.lg),

            // ─── DATAS ──────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _DateField(
                    label: 'Início',
                    value: _startDate,
                    onPick: () async {
                      final d = await _pickDate(_startDate);
                      if (d != null) setState(() => _startDate = d);
                    },
                    onClear: () => setState(() => _startDate = null),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _DateField(
                    label: 'Previsão de entrega',
                    value: _dueDate,
                    onPick: () async {
                      final d = await _pickDate(_dueDate);
                      if (d != null) setState(() => _dueDate = d);
                    },
                    onClear: () => setState(() => _dueDate = null),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // ─── PROGRESSO ──────────────────────────────────────────
            _SectionTitle('Progresso: $_progress%'),
            Slider(
              value: _progress.toDouble(),
              max: 100,
              divisions: 20,
              label: '$_progress%',
              onChanged: _busy
                  ? null
                  : (v) => setState(() => _progress = v.round()),
            ),
            const SizedBox(height: AppSpacing.sm),

            // ─── CATEGORIA ──────────────────────────────────────────
            AppTextField(
              label: 'Categoria (opcional)',
              hint: 'Ex: Tecnologia, Marketing, Eventos...',
              controller: _categoryCtrl,
            ),
            const SizedBox(height: AppSpacing.lg),

            // ─── MEMBROS ────────────────────────────────────────────
            _SectionTitle('Equipe (${_selectedUids.length} selecionados)'),
            if (activeMembers.isEmpty)
              Text(
                'Não há membros ativos para alocar.',
                style: Theme.of(context).textTheme.bodySmall,
              )
            else
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: activeMembers
                    .map((m) => _MemberSelectChip(
                          member: m,
                          selected: _selectedUids.contains(m.uid),
                          onChanged: (v) =>
                              _toggleMember(m, selected: v),
                        ))
                    .toList(),
              ),
            const SizedBox(height: AppSpacing.lg),

            // ─── LÍDER ──────────────────────────────────────────────
            if (_selectedUids.isNotEmpty) ...[
              const _SectionTitle('Líder do projeto'),
              DropdownButtonFormField<String>(
                initialValue: _ownerUid != null &&
                        _selectedUids.contains(_ownerUid)
                    ? _ownerUid
                    : null,
                hint: const Text('Selecione o líder'),
                onChanged: _busy
                    ? null
                    : (v) => setState(() => _ownerUid = v),
                items: activeMembers
                    .where((m) => _selectedUids.contains(m.uid))
                    .map((m) => DropdownMenuItem(
                          value: m.uid,
                          child: Text(m.displayName),
                        ))
                    .toList(),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],

            // ─── LINKS ──────────────────────────────────────────────
            const _SectionTitle('Links externos'),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 2,
                  child: AppTextField(
                    label: 'Rótulo',
                    hint: 'Ex: GitHub',
                    controller: _newLinkLabelCtrl,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  flex: 3,
                  child: AppTextField(
                    label: 'URL',
                    hint: 'https://...',
                    controller: _newLinkUrlCtrl,
                    keyboardType: TextInputType.url,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                    onFieldSubmitted: (_) => _addLink(),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: AppButton(
                    label: '+',
                    variant: AppButtonVariant.secondary,
                    onPressed: _addLink,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ..._links.asMap().entries.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: _LinkRow(
                      link: e.value,
                      onRemove: () => _removeLink(e.key),
                    ),
                  ),
                ),

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
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// SUB-WIDGETS
// ════════════════════════════════════════════════════════════════════════════

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}

class _ColorChip extends StatelessWidget {
  const _ColorChip({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final ProjectColor color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fillColor = switch (color) {
      ProjectColor.green  => AppColors.accent,
      ProjectColor.blue   => AppColors.blue,
      ProjectColor.amber  => AppColors.amber,
      ProjectColor.purple => AppColors.purple,
      ProjectColor.pink   => AppColors.pink,
      ProjectColor.red    => AppColors.red,
    };
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(99),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: fillColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? AppColors.txtPrimary : AppColors.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: selected
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : null,
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onPick,
    required this.onClear,
  });

  final String label;
  final DateTime? value;
  final VoidCallback onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final formatted = value == null
        ? 'Selecionar'
        : DateFormat('d MMM yyyy', 'pt_BR').format(value!);
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
          onTap: onPick,
          borderRadius: AppRadius.radiusMd,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: AppColors.bgInput,
              borderRadius: AppRadius.radiusMd,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 16, color: AppColors.txtSecondary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    formatted,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                if (value != null)
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

class _MemberSelectChip extends StatelessWidget {
  const _MemberSelectChip({
    required this.member,
    required this.selected,
    required this.onChanged,
  });

  final Member member;
  final bool selected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!selected),
      borderRadius: BorderRadius.circular(99),
      child: Container(
        padding: const EdgeInsets.fromLTRB(4, 4, 12, 4),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentDim : AppColors.bgInput,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: selected ? AppColors.accent : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppAvatar(
              initials: member.initials,
              size: AvatarSize.xs,
              seed: member.uid,
            ),
            const SizedBox(width: 8),
            Text(
              member.displayName.split(' ').take(2).join(' '),
              style: TextStyle(
                fontSize: 12,
                color:
                    selected ? AppColors.accentText : AppColors.txtPrimary,
                fontWeight:
                    selected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
            if (selected) ...[
              const SizedBox(width: 6),
              const Icon(Icons.check,
                  size: 14, color: AppColors.accentText),
            ],
          ],
        ),
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({required this.link, required this.onRemove});
  final ProjectLink link;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgInput,
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  link.label,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(
                  link.url,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18),
            onPressed: onRemove,
            tooltip: 'Remover',
          ),
        ],
      ),
    );
  }
}
