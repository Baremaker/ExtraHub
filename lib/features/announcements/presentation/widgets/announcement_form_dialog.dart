import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../extras/presentation/providers/extras_providers.dart';
import '../../domain/announcement.dart';
import '../providers/announcements_providers.dart';

Future<bool> showAnnouncementFormDialog(
  BuildContext context, {
  Announcement? announcement,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _AnnouncementFormDialog(announcement: announcement),
  );
  return result ?? false;
}

class _AnnouncementFormDialog extends ConsumerStatefulWidget {
  const _AnnouncementFormDialog({this.announcement});
  final Announcement? announcement;

  @override
  ConsumerState<_AnnouncementFormDialog> createState() =>
      _AnnouncementFormDialogState();
}

class _AnnouncementFormDialogState
    extends ConsumerState<_AnnouncementFormDialog> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _bodyCtrl;
  late bool _pinned;
  final _formKey = GlobalKey<FormState>();
  bool _busy = false;
  String? _error;

  bool get _isEdit => widget.announcement != null;

  @override
  void initState() {
    super.initState();
    final a = widget.announcement;
    _titleCtrl = TextEditingController(text: a?.title ?? '');
    _bodyCtrl = TextEditingController(text: a?.body ?? '');
    _pinned = a?.pinned ?? false;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final extra = ref.read(activeExtraProvider).value;
      final firebaseUser = ref.read(currentFirebaseUserProvider);
      final appUser = ref.read(currentAppUserProvider).value;
      if (extra == null || firebaseUser == null || appUser == null) {
        throw StateError('Sessão inválida.');
      }
      final repo = ref.read(announcementsRepositoryProvider);
      if (_isEdit) {
        await repo.update(
          extraId: extra.id,
          announcementId: widget.announcement!.id,
          title: _titleCtrl.text,
          body: _bodyCtrl.text,
          pinned: _pinned,
        );
      } else {
        await repo.create(
          extraId: extra.id,
          title: _titleCtrl.text,
          body: _bodyCtrl.text,
          pinned: _pinned,
          author: AnnouncementAuthor(
            uid: firebaseUser.uid,
            displayName: appUser.displayName,
            photoURL: appUser.photoURL,
          ),
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
    return AlertDialog(
      title: Text(_isEdit ? 'Editar aviso' : 'Novo aviso'),
      contentPadding: const EdgeInsets.fromLTRB(
        AppSpacing.xxl,
        AppSpacing.lg,
        AppSpacing.xxl,
        0,
      ),
      content: SizedBox(
        width: 540,
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                label: 'Título',
                hint: 'Resumo curto do aviso',
                controller: _titleCtrl,
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.isEmpty) return 'Informe um título.';
                  if (value.length < 4) return 'Mínimo 4 caracteres.';
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: 'Mensagem',
                hint: 'Conteúdo completo do aviso',
                controller: _bodyCtrl,
                maxLines: 8,
                minLines: 5,
                maxLength: 1500,
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.isEmpty) return 'Informe a mensagem.';
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Fixar no topo'),
                subtitle: Text(
                  'Avisos fixados aparecem em destaque acima dos demais.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                value: _pinned,
                onChanged:
                    _busy ? null : (v) => setState(() => _pinned = v),
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
      actionsPadding: const EdgeInsets.all(AppSpacing.lg),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        AppButton(
          label: _isEdit ? 'Salvar' : 'Publicar',
          loading: _busy,
          onPressed: _busy ? null : _submit,
        ),
      ],
    );
  }
}
