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

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _passConfirmCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _passConfirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authControllerProvider.notifier).signUp(
          email: _emailCtrl.text,
          password: _passCtrl.text,
          displayName: _nameCtrl.text,
        );
    // Sucesso: redirect leva para EmailVerificationScreen.
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final loading = state.isLoading;
    final failure =
        state.hasError && !loading ? state.error as AuthFailure? : null;

    return AuthScaffold(
      title: 'Crie sua conta',
      subtitle: 'Use seu e-mail institucional da USP',
      children: [
        Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                label: 'Nome completo',
                hint: 'Como você quer ser chamado',
                controller: _nameCtrl,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.isEmpty) return 'Informe seu nome.';
                  if (!value.isFullName) {
                    return 'Informe nome e sobrenome.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: 'E-mail institucional',
                hint: 'voce@usp.br',
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.newUsername],
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.isEmpty) return 'Informe seu e-mail.';
                  if (!value.isUspEmail) return 'Use um e-mail @usp.br.';
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: 'Senha',
                hint: 'Mínimo 8 caracteres com letras e números',
                controller: _passCtrl,
                obscureText: _obscure,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.newPassword],
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility : Icons.visibility_off,
                    size: 18,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Crie uma senha.';
                  if (!v.isStrongPassword) {
                    return 'Mín. 8 caracteres com letras e números.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: 'Confirme a senha',
                hint: 'Digite novamente',
                controller: _passConfirmCtrl,
                obscureText: _obscure,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Confirme a senha.';
                  if (v != _passCtrl.text) return 'As senhas não conferem.';
                  return null;
                },
              ),
              if (failure != null) ...[
                const SizedBox(height: AppSpacing.lg),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .error
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .error
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline,
                          size: 16,
                          color: Theme.of(context).colorScheme.error),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          failure.message,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'Criar conta',
                onPressed: loading ? null : _submit,
                loading: loading,
                fullWidth: true,
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Já tem conta?',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  TextButton(
                    onPressed: loading ? null : () => context.pop(),
                    child: const Text('Entrar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
