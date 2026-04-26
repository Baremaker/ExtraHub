import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/extensions/string_x.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/auth_failure.dart';
import '../providers/auth_controller.dart';
import '../widgets/auth_scaffold.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref.read(authControllerProvider.notifier).signIn(
          email: _emailCtrl.text,
          password: _passCtrl.text,
        );
    if (!mounted || !ok) return;
    // Sucesso: o redirect do GoRouter manda pra tela certa.
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final loading = state.isLoading;
    final failure =
        state.hasError && !loading ? state.error as AuthFailure? : null;

    return AuthScaffold(
      title: 'Bem-vindo de volta',
      subtitle: 'Entre com seu e-mail institucional',
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
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
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
                hint: 'Sua senha',
                controller: _passCtrl,
                obscureText: _obscure,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                onFieldSubmitted: (_) => _submit(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility : Icons.visibility_off,
                    size: 18,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Informe sua senha.' : null,
              ),
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: loading
                      ? null
                      : () => context.pushNamed(Routes.forgotPasswordName),
                  child: const Text('Esqueci minha senha'),
                ),
              ),
              if (failure != null) ...[
                const SizedBox(height: AppSpacing.sm),
                _ErrorBanner(message: failure.message),
              ],
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: 'Entrar',
                onPressed: loading ? null : _submit,
                loading: loading,
                fullWidth: true,
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Não tem conta?',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  TextButton(
                    onPressed: loading
                        ? null
                        : () => context.pushNamed(Routes.signupName),
                    child: const Text('Cadastre-se'),
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

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline,
              size: 16, color: Theme.of(context).colorScheme.error),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
