import 'package:extrahub/app/theme/app_colors.dart';
import 'package:extrahub/app/theme/app_radius.dart';
import 'package:extrahub/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Testes automatizados de acessibilidade usando as *guidelines* do
/// `flutter_test` (a ferramenta automatizada exigida pela Seção 5):
///   * textContrastGuideline     — contraste de texto WCAG AA.
///   * androidTapTargetGuideline — alvos de toque ≥ 48x48.
///   * labeledTapTargetGuideline — todo controle tocável tem rótulo.
///
/// O tema aqui replica as CORES reais do app (as que importam para contraste:
/// `accentStrong` no fundo do botão, `txtTertiary` corrigido, fundo base), mas
/// com a fonte padrão de teste — assim não dependemos de baixar a fonte Inter.
void main() {
  ThemeData a11yTheme() => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bgBase,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.accent,
          brightness: Brightness.dark,
          primary: AppColors.accent,
          onPrimary: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentStrong,
            foregroundColor: Colors.white,
            shape:
                const RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.txtPrimary,
            side: const BorderSide(color: AppColors.borderMd),
          ),
        ),
      );

  Widget harness(Widget child) => MaterialApp(
        theme: a11yTheme(),
        home: Scaffold(
          backgroundColor: AppColors.bgBase,
          body: Padding(padding: const EdgeInsets.all(24), child: child),
        ),
      );

  testWidgets(
    'botões, ícones e textos atendem contraste, alvo de toque e rótulo',
    (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        harness(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Texto terciário (cor corrigida para passar AA).
              const Text(
                'Informação secundária',
                style: TextStyle(color: AppColors.txtTertiary),
              ),
              const SizedBox(height: 16),
              // Botão primário: branco sobre verde mais escuro (accentStrong).
              AppButton(label: 'Salvar', onPressed: () {}),
              const SizedBox(height: 16),
              AppButton(
                label: 'Cancelar',
                variant: AppButtonVariant.secondary,
                onPressed: () {},
              ),
              const SizedBox(height: 16),
              // Ícone-botão com rótulo (tooltip vira label semântico).
              IconButton(
                tooltip: 'Sair',
                onPressed: () {},
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
        ),
      );

      await expectLater(tester, meetsGuideline(textContrastGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

      handle.dispose();
    },
  );
}
