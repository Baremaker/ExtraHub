import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';

/// Widget root do ExtraHub.
///
/// Responsável apenas por configurar `MaterialApp.router` com:
/// - tema dark customizado (`AppTheme.dark()`)
/// - router declarativo (`go_router`)
/// - debug banner desligado
///
/// Toda a lógica de inicialização (Firebase, etc.) fica em `main.dart`.
class ExtraHubApp extends ConsumerWidget {
  const ExtraHubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'ExtraHub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      routerConfig: router,
    );
  }
}
