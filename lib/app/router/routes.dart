/// Constantes de rotas do app.
///
/// Centralizar paths e nomes evita strings mágicas espalhadas pelo código e
/// facilita refatorar URLs depois sem caçar string. Sempre que adicionar uma
/// rota nova, adicione aqui antes de declará-la no router.
class Routes {
  Routes._();

  // ─── PATHS ─────────────────────────────────────────────────────────────────
  static const String splash       = '/';
  static const String login        = '/login';
  static const String signup       = '/signup';
  static const String chooseExtra  = '/extras';
  static const String createExtra  = '/extras/new';
  static const String dashboard    = '/dashboard';
  static const String members      = '/members';
  static const String projects     = '/projects';
  static const String announcements = '/announcements';
  static const String calendar     = '/calendar';
  static const String profile      = '/profile';

  // ─── NAMES ─────────────────────────────────────────────────────────────────
  // Usar names em vez de paths em `context.goNamed(...)` deixa as chamadas
  // mais legíveis e protege contra erro de digitação.
  static const String splashName       = 'splash';
  static const String loginName        = 'login';
  static const String signupName       = 'signup';
  static const String chooseExtraName  = 'chooseExtra';
  static const String createExtraName  = 'createExtra';
  static const String dashboardName    = 'dashboard';
  static const String membersName      = 'members';
  static const String projectsName     = 'projects';
  static const String announcementsName = 'announcements';
  static const String calendarName     = 'calendar';
  static const String profileName      = 'profile';
}
