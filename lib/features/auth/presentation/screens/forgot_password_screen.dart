import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/extensions/string_x.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/auth_failure.dart';
import '../providers/auth_controller.dart';
import '../widgets/auth_scaffold.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref
        .read(authControllerProvider.notifier)
        .sendPasswordReset(_emailCtrl.text);
    if (ok && mounted) {
      setState(() => _sent = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final loading = state.isLoading;
    final failure =
        state.hasError && !loading ? state.error as AuthFailure? : null;

    if (_sent) {
      return AuthScaffold(
        title: 'Verifique seu e-mail',
        subtitle:
            'Enviamos um link de redefinição para ${_emailCtrl.text.trim()}. '
            'Confira sua caixa de entrada (e o spam).',
        children: [
          AppButton(
            label: 'Voltar para o login',
            onPressed: () => context.pop(),
            fullWidth: true,
          ),
        ],
      );
    }

    return AuthScaffold(
      title: 'Recuperar senha',
      subtitle: 'Te enviamos um link por e-mail para criar uma nova senha.',
      children: [
        Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                label: 'E-mail',
                hint: 'voce@usp.br',
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.email],
                onFieldSubmitted: (_) => _submit(),
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.isEmpty) return 'Informe seu e-mail.';
                  if (!value.isUspEmail) return 'Use um e-mail @usp.br.';
                  return null;
                },
              ),
              if (failure != null) ...[
                const SizedBox(height: AppSpacing.lg),
                Text(
                  failure.message,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'Enviar link',
                onPressed: loading ? null : _submit,
                loading: loading,
                fullWidth: true,
              ),
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: TextButton(
                  onPressed: loading ? null : () => context.pop(),
                  child: const Text('Voltar'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
