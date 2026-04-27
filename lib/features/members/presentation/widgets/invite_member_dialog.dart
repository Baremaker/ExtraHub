import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/extensions/string_x.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../extras/presentation/providers/extras_providers.dart';
import '../../domain/member.dart';

/// Mostra o diálogo de convite. Retorna `true` se o convite foi enviado.
Future<bool> showInviteMemberDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (_) => const _InviteMemberDialog(),
  );
  return result ?? false;
}

class _InviteMemberDialog extends ConsumerStatefulWidget {
  const _InviteMemberDialog();

  @override
  ConsumerState<_InviteMemberDialog> createState() =>
      _InviteMemberDialogState();
}

class _InviteMemberDialogState extends ConsumerState<_InviteMemberDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  MemberRole _role = MemberRole.member;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
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
        throw StateError('Dados ausentes.');
      }

      await ref.read(invitesRepositoryProvider).createInvite(
            extraId: extra.id,
            extraName: extra.name,
            email: _emailCtrl.text,
            role: _role,
            inviterUid: firebaseUser.uid,
            inviterDisplayName: appUser.displayName,
          );

      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        setState(() => _error = '$e');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Convidar membro'),
      contentPadding: const EdgeInsets.fromLTRB(
        AppSpacing.xxl,
        AppSpacing.lg,
        AppSpacing.xxl,
        0,
      ),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'O convite será enviado por e-mail. A pessoa precisa criar '
                'conta no ExtraHub (se ainda não tiver) e aceitar o convite.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: 'E-mail',
                hint: 'pessoa@usp.br',
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.isEmpty) return 'Informe o e-mail.';
                  if (!value.isUspEmail) return 'Use um e-mail @usp.br.';
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Cargo',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              SegmentedButton<MemberRole>(
                segments: const [
                  ButtonSegment(
                    value: MemberRole.member,
                    label: Text('Membro'),
                    icon: Icon(Icons.person_outline, size: 16),
                  ),
                  ButtonSegment(
                    value: MemberRole.admin,
                    label: Text('Admin'),
                    icon: Icon(Icons.shield_outlined, size: 16),
                  ),
                ],
                selected: {_role},
                onSelectionChanged: _busy
                    ? null
                    : (s) => setState(() => _role = s.first),
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
          label: 'Enviar convite',
          loading: _busy,
          onPressed: _busy ? null : _submit,
        ),
      ],
    );
  }
}
