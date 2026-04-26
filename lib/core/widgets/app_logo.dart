import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

/// Logo padrão do ExtraHub: uma bolinha verde + nome.
///
/// Tamanho controlado por [size] (small/medium/large), o que escala
/// proporcionalmente bolinha e tipografia.
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = AppLogoSize.medium,
    this.subtitle,
  });

  final AppLogoSize size;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dotSize = switch (size) {
      AppLogoSize.small  => 8.0,
      AppLogoSize.medium => 12.0,
      AppLogoSize.large  => 16.0,
    };
    final textStyle = switch (size) {
      AppLogoSize.small  => theme.textTheme.headlineMedium,
      AppLogoSize.medium => theme.textTheme.displayMedium,
      AppLogoSize.large  => theme.textTheme.displayLarge,
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: dotSize,
              height: dotSize,
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: dotSize),
            Text('ExtraHub', style: textStyle),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(subtitle!, style: theme.textTheme.bodySmall),
        ],
      ],
    );
  }
}

enum AppLogoSize { small, medium, large }
