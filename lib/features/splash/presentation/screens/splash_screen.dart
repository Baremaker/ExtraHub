import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';

/// Tela de smoke test (Fase 0).
///
/// Mostra o logo do ExtraHub, o tema dark aplicado, e confirma que o Firebase
/// inicializou corretamente. Quando construirmos a tela de login real, esta
/// tela vira splash de verdade (verifica se há usuário logado e redireciona).
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseInitialized = Firebase.apps.isNotEmpty;
    final firebaseProjectId = firebaseInitialized
        ? Firebase.app().options.projectId
        : '—';

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ─── LOGO ──────────────────────────────────────────────────
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    'ExtraHub',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'gestão de extras universitárias',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.x3l),

              // ─── STATUS DO FIREBASE ────────────────────────────────────
              _StatusRow(
                label: 'Firebase',
                ok: firebaseInitialized,
                detail: firebaseInitialized
                    ? 'projeto: $firebaseProjectId'
                    : 'não inicializado',
              ),
              const SizedBox(height: AppSpacing.sm),
              const _StatusRow(
                label: 'Tema',
                ok: true,
                detail: 'dark mode aplicado',
              ),
              const SizedBox(height: AppSpacing.sm),
              const _StatusRow(
                label: 'Roteador',
                ok: true,
                detail: 'go_router ativo',
              ),

              const SizedBox(height: AppSpacing.x3l),
              Text(
                'Fase 0 — fundação do projeto',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Linha de status (✓ verde / ✗ vermelho) usada no smoke test.
///
/// Será removida quando substituirmos esta tela pela tela de splash real.
class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.label,
    required this.ok,
    required this.detail,
  });

  final String label;
  final bool ok;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            ok ? Icons.check_circle : Icons.error,
            size: 16,
            color: ok ? AppColors.accentText : AppColors.redText,
          ),
          const SizedBox(width: AppSpacing.md),
          Text(label, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(width: AppSpacing.sm),
          Text(
            detail,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
