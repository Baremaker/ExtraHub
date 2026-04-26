import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/auth_controller.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_scaffold.dart';

/// Tela exibida quando o usuário acabou de criar conta mas ainda não
/// clicou no link de verificação enviado por e-mail.
///
/// Faz polling automático a cada 4 segundos para detectar verificação;
/// também tem botão "já verifiquei" pra forçar checagem imediata.
class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> {
  Timer? _pollTimer;
  bool _resending = false;
  String? _resendInfo;

  @override
  void initState() {
    super.initState();
    _pollTimer = Timer.periodic(const Duration(seconds: 4), (_) => _check());
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _check() async {
    final verified = await ref
        .read(authControllerProvider.notifier)
        .checkEmailVerified();
    if (verified && mounted) {
      _pollTimer?.cancel();
      // O redirect do GoRouter cuida da próxima rota.
    }
  }

  Future<void> _resend() async {
    setState(() {
      _resending = true;
      _resendInfo = null;
    });
    try {
      await ref
          .read(authControllerProvider.notifier)
          .resendEmailVerification();
      if (mounted) {
        setState(() => _resendInfo = 'E-mail reenviado.');
      }
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  Future<void> _signOut() async {
    await ref.read(authControllerProvider.notifier).signOut();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = ref.watch(currentFirebaseUserProvider);
    final email = firebaseUser?.email ?? '';

    return AuthScaffold(
      title: 'Verifique seu e-mail',
      subtitle:
          'Enviamos um link de confirmação para $email. Clique nele para '
          'ativar sua conta. Esta tela atualiza sozinha quando detectarmos.',
      children: [
        AppButton(
          label: 'Já verifiquei',
          onPressed: _check,
          fullWidth: true,
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton(
          label: 'Reenviar e-mail',
          variant: AppButtonVariant.secondary,
          onPressed: _resending ? null : _resend,
          loading: _resending,
          fullWidth: true,
        ),
        if (_resendInfo != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            _resendInfo!,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        Center(
          child: TextButton(
            onPressed: _signOut,
            child: const Text('Sair'),
          ),
        ),
      ],
    );
  }
}
