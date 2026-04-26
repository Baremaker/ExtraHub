import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/splash/presentation/screens/splash_screen.dart';
import 'routes.dart';

/// Provider do `GoRouter` da aplicação.
///
/// Um único router é criado para todo o app e disponibilizado via Riverpod.
/// Conforme adicionarmos features, registramos suas rotas aqui.
///
/// Para rotas protegidas por auth, mais à frente adicionaremos um `redirect:`
/// que observa o estado de autenticação.
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: Routes.splash,
        name: Routes.splashName,
        builder: (context, state) => const SplashScreen(),
      ),
      // Conforme criamos features, registramos as rotas aqui.
      // Exemplo (a fazer):
      // GoRoute(
      //   path: Routes.login,
      //   name: Routes.loginName,
      //   builder: (context, state) => const LoginScreen(),
      // ),
    ],
  );
});
