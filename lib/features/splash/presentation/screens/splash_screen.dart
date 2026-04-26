import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_logo.dart';

/// Splash exibida durante a inicialização e enquanto o router decide
/// para qual rota redirecionar (carregando o `AppUser` do Firestore).
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppLogo(
                size: AppLogoSize.large,
                subtitle: 'gestão de extras universitárias',
              ),
              SizedBox(height: AppSpacing.x3l),
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
