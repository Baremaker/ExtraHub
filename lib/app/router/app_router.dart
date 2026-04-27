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
import '../../features/members/presentation/screens/member_detail_screen.dart';
import '../../features/members/presentation/screens/members_screen.dart';
import '../../features/profile/presentation/screens/my_profile_screen.dart';
import '../../features/projects/presentation/screens/project_detail_screen.dart';
import '../../features/projects/presentation/screens/projects_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import 'routes.dart';

/// Refresh notifier exposto para o GoRouter.
class _RouterRefreshNotifier extends ChangeNotifier {
  void refresh() => notifyListeners();
}

/// Provider do `GoRouter` da aplicação.
final goRouterProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefreshNotifier();
  ref.listen(authStateProvider, (_, _) => refresh.refresh());
  ref.listen(currentAppUserProvider, (_, _) => refresh.refresh());
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: Routes.splash,
    debugLogDiagnostics: kDebugMode,
    refreshListenable: refresh,

    // ─── REDIRECT ──────────────────────────────────────────────────────────
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

      if (firebaseUser == null) {
        if (isAtAuthFlow) return null;
        return Routes.login;
      }

      if (!firebaseUser.emailVerified) {
        if (isAtVerifyEmail) return null;
        return Routes.verifyEmail;
      }

      if (appUserAsync.isLoading) {
        return isAtSplash ? null : Routes.splash;
      }

      final appUser = appUserAsync.value;
      if (appUser == null) {
        return isAtSplash ? null : Routes.splash;
      }

      if (appUser.activeExtraId == null) {
        if (isAtChooseExtra) return null;
        return Routes.chooseExtra;
      }

      if (isAtSplash ||
          isAtAuthFlow ||
          isAtVerifyEmail ||
          isAtChooseExtra) {
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
      GoRoute(
        path: Routes.members,
        name: Routes.membersName,
        builder: (_, _) => const MembersScreen(),
        routes: [
          GoRoute(
            path: ':uid',
            name: Routes.memberDetailName,
            builder: (context, state) =>
                MemberDetailScreen(uid: state.pathParameters['uid']!),
          ),
        ],
      ),
      GoRoute(
        path: Routes.projects,
        name: Routes.projectsName,
        builder: (_, _) => const ProjectsScreen(),
        routes: [
          GoRoute(
            path: ':id',
            name: Routes.projectDetailName,
            builder: (context, state) =>
                ProjectDetailScreen(id: state.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: Routes.profile,
        name: Routes.profileName,
        builder: (_, _) => const MyProfileScreen(),
      ),
    ],
  );
});
