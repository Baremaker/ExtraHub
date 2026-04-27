import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'sidebar.dart';

/// Breakpoint a partir do qual a sidebar fica fixa no layout (em vez de
/// drawer). Abaixo desse valor, vira mobile.
const double kAppShellBreakpoint = 768;

/// Layout pai de todas as telas internas (após autenticação).
///
/// Renderiza:
///   - **Em mobile** (< 768px): `Scaffold` com [AppBar] customizada e
///     [Drawer] contendo a [Sidebar].
///   - **Em desktop/web** (≥ 768px): [Row] com [Sidebar] fixa à esquerda e
///     conteúdo (topbar + child) à direita.
///
/// Cada screen passa [title], [subtitle] (opcional, ex: "24 membros ativos")
/// e [actions] (botões à direita da topbar). [child] é o conteúdo principal,
/// já com seu próprio scroll se necessário.
class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.actions,
    this.contentPadding =
        const EdgeInsets.fromLTRB(AppSpacing.xxl, AppSpacing.lg, AppSpacing.xxl, AppSpacing.xxl),
  });

  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget child;
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < kAppShellBreakpoint;
        return isMobile ? _buildMobile(context) : _buildDesktop(context);
      },
    );
  }

  // ────────────────────────────────────────────────────────────────────────
  // MOBILE
  // ────────────────────────────────────────────────────────────────────────
  Widget _buildMobile(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: AppColors.bgCard,
        width: kSidebarWidth,
        shape: const RoundedRectangleBorder(),
        child: Builder(
          builder: (innerCtx) =>
              Sidebar(onNavigate: () => Navigator.of(innerCtx).pop()),
        ),
      ),
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            if (subtitle != null)
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        actions: actions,
        toolbarHeight: 64,
      ),
      body: SafeArea(
        child: Padding(padding: contentPadding, child: child),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────────────
  // DESKTOP / WEB
  // ────────────────────────────────────────────────────────────────────────
  Widget _buildDesktop(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Sidebar(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Topbar(
                    title: title,
                    subtitle: subtitle,
                    actions: actions,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: contentPadding,
                      child: child,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Topbar extends StatelessWidget {
  const _Topbar({
    required this.title,
    this.subtitle,
    this.actions,
  });

  final String title;
  final String? subtitle;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      decoration: const BoxDecoration(
        color: AppColors.bgCard,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
              ],
            ),
          ),
          if (actions != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < actions!.length; i++) ...[
                  if (i > 0) const SizedBox(width: AppSpacing.sm),
                  actions![i],
                ],
              ],
            ),
        ],
      ),
    );
  }
}
