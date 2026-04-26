/// Extensions de validação em [String].
///
/// Usadas nos forms de auth e cadastro de extra. Centralizamos aqui para
/// não espalhar regex e regras de negócio pelas screens.
extension StringValidationX on String {
  /// Email com formato válido genérico.
  bool get isEmail => RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      ).hasMatch(trim());

  /// Email institucional da USP. Aceita qualquer subdomínio:
  /// `joao@usp.br`, `joao@icmc.usp.br`, `joao@alumni.usp.br`.
  bool get isUspEmail => RegExp(
        r'^[a-zA-Z0-9._%+-]+@([a-zA-Z0-9-]+\.)*usp\.br$',
      ).hasMatch(trim().toLowerCase());

  /// Senha com regras mínimas (8+ chars, ao menos 1 letra e 1 número).
  bool get isStrongPassword =>
      length >= 8 &&
      RegExp(r'[A-Za-z]').hasMatch(this) &&
      RegExp(r'[0-9]').hasMatch(this);

  /// Nome com pelo menos 2 partes (assumimos primeiro+último).
  bool get isFullName {
    final parts = trim().split(RegExp(r'\s+'));
    return parts.length >= 2 && parts.every((p) => p.length >= 2);
  }
}
