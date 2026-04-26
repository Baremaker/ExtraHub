/// Tokens de espaçamento.
///
/// Use sempre que precisar de um `EdgeInsets` ou `SizedBox`. Evite valores
/// numéricos soltos no código de UI — eles vão ficando inconsistentes.
class AppSpacing {
  AppSpacing._();

  static const double xxs = 2;
  static const double xs  = 4;
  static const double sm  = 8;
  static const double md  = 12;
  static const double lg  = 16;
  static const double xl  = 20;
  static const double xxl = 24;
  static const double x3l = 32;
  static const double x4l = 48;

  /// Largura da sidebar (do protótipo: --sidebar-w: 196px).
  static const double sidebarWidth = 196;
}
