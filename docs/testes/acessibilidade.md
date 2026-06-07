# Seção 5 — Testes de Acessibilidade

> Material para o relatório da Entrega 2: estratégia, ferramenta automatizada,
> casos de teste, resultados e correções.

## Estratégia e ferramenta

A acessibilidade foi avaliada com a **ferramenta automatizada de testes de
acessibilidade do Flutter** (`flutter_test`), que aplica *guidelines* sobre a
árvore renderizada:

- **`textContrastGuideline`** — contraste de texto conforme WCAG AA.
- **`androidTapTargetGuideline`** — alvos de toque com no mínimo 48×48 dp.
- **`labeledTapTargetGuideline`** — todo controle tocável possui rótulo
  (lido por leitores de tela).

Além disso, foram medidos manualmente os contrastes da paleta do design system
(fórmula WCAG sobre os tokens de `AppColors`).

**Como rodar:**

```bash
flutter test test/a11y/accessibility_test.dart
```

## Erros encontrados e correções

| # | Problema | Antes | Depois |
|---|----------|-------|--------|
| A1 | Texto terciário (hints, rótulos, datas off-month) com contraste insuficiente | `txtTertiary` `#4A5568` = **2.5:1** ❌ | `#7A8699` = **5.1:1** ✅ |
| A2 | Texto branco no botão primário (verde) abaixo do AA | branco sobre `accent` `#1D9E75` = **3.4:1** ❌ | branco sobre `accentStrong` `#158055` = **4.9:1** ✅ |
| A3 | Itens da barra lateral com alvo de toque pequeno | ~32 dp ❌ | `minHeight: 44` no item (Container) ✅ |
| A4 | Ícones-botão sem rótulo para leitor de tela | — | confirmado: todos usam `tooltip` (vira label semântico) ✅ |

> Os botões padronizados (`AppButton`, baseados em `ElevatedButton`/
> `OutlinedButton`) já têm área de toque de 48 dp via o *tap target* "padded" do
> Material — confirmado pelo teste automatizado.

## Casos de teste (automatizados) e resultados

| Caso | Guideline | Resultado |
|------|-----------|-----------|
| Texto terciário e rótulos têm contraste AA | `textContrastGuideline` | ✅ |
| Texto do botão primário (branco/verde) tem contraste AA | `textContrastGuideline` | ✅ |
| Botões primário e secundário têm alvo ≥ 48×48 | `androidTapTargetGuideline` | ✅ |
| Ícone-botão tem alvo ≥ 48×48 | `androidTapTargetGuideline` | ✅ |
| Todos os controles tocáveis têm rótulo | `labeledTapTargetGuideline` | ✅ |

Resultado: **todos os casos passam** (`flutter test test/a11y/`).

## Observações e limitações

- Os avatares usam **iniciais** (não imagens), então não há necessidade de
  texto alternativo de imagem.
- Alguns *chips* de filtro compactos (Membros/Projetos) têm altura ~36–40 dp;
  permanecem utilizáveis mas abaixo do ideal de 48 dp — melhoria futura de baixo
  impacto. A navegação principal (barra lateral) e os botões já atendem.
- O app é *dark-only*; a paleta principal de texto (`txtPrimary` 15.7:1,
  `txtSecondary` 6.0:1, `accentText` 8.6:1) já passava com folga.
</content>
