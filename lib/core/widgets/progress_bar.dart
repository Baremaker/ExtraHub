import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Barra de progresso simples e reutilizável (espelha `.progress` do
/// protótipo).
///
/// [value] em **[0..1]**, [color] customizável.
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.value,
    this.color = AppColors.accent,
    this.height = 6,
  });

  final double value;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: Container(
        height: height,
        color: AppColors.bgInput,
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: clamped,
          child: Container(color: color),
        ),
      ),
    );
  }
}
