import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_logo.dart';

/// Scaffold das telas de autenticação.
///
/// Centraliza o conteúdo num card de até 420px no centro da tela. No mobile,
/// vira full-width. Logo do ExtraHub no topo, depois título, subtítulo
/// (opcional) e o conteúdo do form.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    this.subtitle,
    required this.children,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(child: AppLogo(size: AppLogoSize.medium)),
                  const SizedBox(height: AppSpacing.x3l),
                  Text(
                    title,
                    style: theme.textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.x3l),
                  ...children,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
