import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Variante visual do botão.
enum AppButtonVariant { primary, secondary, ghost, danger }

/// Botão padronizado do ExtraHub.
///
/// Mostra spinner se [loading] = true (e desativa o press). Suporta as 4
/// variantes mais comuns no protótipo: primary (verde), secondary (borda),
/// ghost (só texto) e danger (vermelho).
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.loading = false,
    this.icon,
    this.fullWidth = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool loading;
  final IconData? icon;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || loading;
    final child = loading
        ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          );

    final button = switch (variant) {
      AppButtonVariant.primary => ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          child: child,
        ),
      AppButtonVariant.secondary => OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          child: child,
        ),
      AppButtonVariant.ghost => TextButton(
          onPressed: isDisabled ? null : onPressed,
          child: child,
        ),
      AppButtonVariant.danger => ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: isDisabled ? null : onPressed,
          child: child,
        ),
    };

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}
