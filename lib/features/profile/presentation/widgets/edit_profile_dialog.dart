import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/skill_tag.dart';
import '../../../auth/domain/app_user.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

/// Mostra o diálogo de edição do próprio perfil.
Future<bool> showEditProfileDialog(
  BuildContext context, {
  required AppUser user,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (_) => _EditProfileDialog(user: user),
  );
  return result ?? false;
}

class _EditProfileDialog extends ConsumerStatefulWidget {
  const _EditProfileDialog({required this.user});
  final AppUser user;

  @override
  ConsumerState<_EditProfileDialog> createState() =>
      _EditProfileDialogState();
}

class _EditProfileDialogState extends ConsumerState<_EditProfileDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _bioCtrl;
  late final TextEditingController _courseCtrl;
  late final TextEditingController _semesterCtrl;
  late final TextEditingController _uspNumberCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _newSkillCtrl;
  late final TextEditingController _newInterestCtrl;
  late List<String> _skills;
  late List<String> _interests;
  final _formKey = GlobalKey<FormState>();
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.user.displayName);
    _bioCtrl = TextEditingController(text: widget.user.bio ?? '');
    _courseCtrl = TextEditingController(text: widget.user.course ?? '');
    _semesterCtrl = TextEditingController(
      text: widget.user.semester?.toString() ?? '',
    );
    _uspNumberCtrl =
        TextEditingController(text: widget.user.uspNumber ?? '');
    _phoneCtrl = TextEditingController(text: widget.user.phone ?? '');
    _newSkillCtrl = TextEditingController();
    _newInterestCtrl = TextEditingController();
    _skills = List.of(widget.user.skills);
    _interests = List.of(widget.user.interests);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _bioCtrl.dispose();
    _courseCtrl.dispose();
    _semesterCtrl.dispose();
    _uspNumberCtrl.dispose();
    _phoneCtrl.dispose();
    _newSkillCtrl.dispose();
    _newInterestCtrl.dispose();
    super.dispose();
  }

  void _addSkill() {
    final v = _newSkillCtrl.text.trim();
    if (v.isEmpty || _skills.contains(v)) return;
    setState(() {
      _skills = [..._skills, v];
      _newSkillCtrl.clear();
    });
  }

  void _addInterest() {
    final v = _newInterestCtrl.text.trim();
    if (v.isEmpty || _interests.contains(v)) return;
    setState(() {
      _interests = [..._interests, v];
      _newInterestCtrl.clear();
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final semText = _semesterCtrl.text.trim();
      await ref.read(appUserRepositoryProvider).updateClearable(
        widget.user.uid,
        {
          'displayName': _nameCtrl.text.trim(),
          'bio': _bioCtrl.text.trim().isEmpty ? null : _bioCtrl.text.trim(),
          'course': _courseCtrl.text.trim().isEmpty
              ? null
              : _courseCtrl.text.trim(),
          'semester': semText.isEmpty ? null : int.tryParse(semText),
          'uspNumber': _uspNumberCtrl.text.trim().isEmpty
              ? null
              : _uspNumberCtrl.text.trim(),
          'phone': _phoneCtrl.text.trim().isEmpty
              ? null
              : _phoneCtrl.text.trim(),
          'skills': _skills,
          'interests': _interests,
        },
      );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar perfil'),
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
                  label: 'Nome completo',
                  controller: _nameCtrl,
                  validator: (v) {
                    final value = v?.trim() ?? '';
                    if (value.isEmpty) return 'Informe o nome.';
                    if (value.split(RegExp(r'\s+')).length < 2) {
                      return 'Informe nome e sobrenome.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: 'Sobre mim',
                  hint: 'Breve descrição sobre você (opcional)',
                  controller: _bioCtrl,
                  maxLines: 3,
                  minLines: 2,
                  maxLength: 280,
                ),
                const SizedBox(height: AppSpacing.lg),

                const _SectionTitle('Acadêmico'),
                AppTextField(
                  label: 'Curso',
                  hint: 'Ex: Engenharia de Computação',
                  controller: _courseCtrl,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'Semestre',
                        hint: 'Ex: 5',
                        controller: _semesterCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return null;
                          final n = int.tryParse(v.trim());
                          if (n == null || n < 1 || n > 14) {
                            return '1 a 14';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      flex: 2,
                      child: AppTextField(
                        label: 'Número USP',
                        controller: _uspNumberCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                const _SectionTitle('Contato'),
                AppTextField(
                  label: 'Celular',
                  hint: '(16) 99999-9999',
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: AppSpacing.lg),

                const _SectionTitle('Habilidades'),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: '',
                        hint: 'Ex: Flutter, Python, Design...',
                        controller: _newSkillCtrl,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _addSkill(),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.lg),
                      child: AppButton(
                        label: 'Adicionar',
                        variant: AppButtonVariant.secondary,
                        onPressed: _addSkill,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                SkillTagList(
                  tags: _skills,
                  onRemove: (tag) =>
                      setState(() => _skills = [..._skills]..remove(tag)),
                ),
                const SizedBox(height: AppSpacing.lg),

                const _SectionTitle('Interesses'),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: '',
                        hint: 'Ex: IA, robótica, gestão...',
                        controller: _newInterestCtrl,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _addInterest(),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.lg),
                      child: AppButton(
                        label: 'Adicionar',
                        variant: AppButtonVariant.secondary,
                        onPressed: _addInterest,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                SkillTagList(
                  tags: _interests,
                  onRemove: (tag) => setState(
                    () => _interests = [..._interests]..remove(tag),
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
          label: 'Salvar',
          loading: _busy,
          onPressed: _busy ? null : _submit,
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}
