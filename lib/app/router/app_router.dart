import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/screens/email_verification_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_placeholder_screen.dart';
import '../../features/extras/presentation/screens/choose_extra_screen.dart';
import '../../features/extras/presentation/screens/create_extra_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import 'routes.dart';

/// Refresh notifier exposto para o GoRouter.
///
/// `ChangeNotifier` cujo único propósito é expor publicamente o
/// `notifyListeners`. O provider escuta os providers de auth via
/// `ref.listen` e chama [refresh] quando algo muda, fazendo o GoRouter
/// re-executar o `redirect`.
class _RouterRefreshNotifier extends ChangeNotifier {
  void refresh() => notifyListeners();
}

/// Provider do `GoRouter` da aplicação.
final goRouterProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefreshNotifier();
  // `ref.listen` cuida do cleanup das subscriptions automaticamente quando
  // o provider é descartado. Não precisamos guardar referências.
  ref.listen(authStateProvider, (_, _) => refresh.refresh());
  ref.listen(currentAppUserProvider, (_, _) => refresh.refresh());
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: Routes.splash,
    debugLogDiagnostics: kDebugMode,
    refreshListenable: refresh,

    // ─── REDIRECT BASEADO EM ESTADO DE AUTH ────────────────────────────────
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final firebaseUser = ref.read(currentFirebaseUserProvider);
      final appUserAsync = ref.read(currentAppUserProvider);

      final isAtSplash = loc == Routes.splash;
      final isAtAuthFlow = loc == Routes.login ||
          loc == Routes.signup ||
          loc == Routes.forgotPassword;
      final isAtVerifyEmail = loc == Routes.verifyEmail;
      final isAtChooseExtra =
          loc == Routes.chooseExtra || loc == Routes.createExtra;

      // 1) Não autenticado → tela de auth
      if (firebaseUser == null) {
        if (isAtAuthFlow) return null;
        return Routes.login;
      }

      // 2) Autenticado mas e-mail não verificado → tela de verificação
      if (!firebaseUser.emailVerified) {
        if (isAtVerifyEmail) return null;
        return Routes.verifyEmail;
      }

      // 3) Autenticado e verificado, mas ainda carregando o doc do AppUser
      //    → fica na splash
      if (appUserAsync.isLoading) {
        return isAtSplash ? null : Routes.splash;
      }

      final appUser = appUserAsync.value;

      // 3b) Edge case: doc não existe (ex: criado fora do app, ou erro
      //     transitório). Mantém na splash; o stream eventualmente atualiza.
      if (appUser == null) {
        return isAtSplash ? null : Routes.splash;
      }

      // 4) Sem activeExtraId → escolher (ou criar) extra
      if (appUser.activeExtraId == null) {
        if (isAtChooseExtra) return null;
        return Routes.chooseExtra;
      }

      // 5) Tudo certo → dashboard. Se está em splash/auth/verify, manda pra lá.
      if (isAtSplash || isAtAuthFlow || isAtVerifyEmail) {
        return Routes.dashboard;
      }
      return null;
    },

    // ─── ROTAS ─────────────────────────────────────────────────────────────
    routes: [
      GoRoute(
        path: Routes.splash,
        name: Routes.splashName,
        builder: (_, _) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.login,
        name: Routes.loginName,
        builder: (_, _) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.signup,
        name: Routes.signupName,
        builder: (_, _) => const SignupScreen(),
      ),
      GoRoute(
        path: Routes.forgotPassword,
        name: Routes.forgotPasswordName,
        builder: (_, _) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: Routes.verifyEmail,
        name: Routes.verifyEmailName,
        builder: (_, _) => const EmailVerificationScreen(),
      ),
      GoRoute(
        path: Routes.chooseExtra,
        name: Routes.chooseExtraName,
        builder: (_, _) => const ChooseExtraScreen(),
      ),
      GoRoute(
        path: Routes.createExtra,
        name: Routes.createExtraName,
        builder: (_, _) => const CreateExtraScreen(),
      ),
      GoRoute(
        path: Routes.dashboard,
        name: Routes.dashboardName,
        builder: (_, _) => const DashboardPlaceholderScreen(),
      ),
    ],
  );
});
