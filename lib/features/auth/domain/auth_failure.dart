import 'package:firebase_auth/firebase_auth.dart';

/// Erros de autenticação mapeados para mensagens em pt-BR.
///
/// Em vez de propagar `FirebaseAuthException` cru pra UI, usamos esse tipo
/// para que screens só precisem mostrar [message]. Também facilita testes.
sealed class AuthFailure implements Exception {
  const AuthFailure(this.message);
  final String message;

  @override
  String toString() => 'AuthFailure: $message';

  /// Mapeia uma exception qualquer para um [AuthFailure].
  factory AuthFailure.from(Object error) {
    if (error is AuthFailure) return error;
    if (error is FirebaseAuthException) {
      return switch (error.code) {
        'invalid-credential'         => const InvalidCredentials(),
        'invalid-email'              => const InvalidEmail(),
        'user-not-found'             => const UserNotFound(),
        'wrong-password'             => const InvalidCredentials(),
        'user-disabled'              => const UserDisabled(),
        'email-already-in-use'       => const EmailAlreadyInUse(),
        'weak-password'              => const WeakPassword(),
        'too-many-requests'          => const TooManyRequests(),
        'network-request-failed'     => const NetworkError(),
        'requires-recent-login'      => const RequiresRecentLogin(),
        _ => UnknownAuthFailure(error.message ?? error.code),
      };
    }
    return UnknownAuthFailure(error.toString());
  }
}

/// Email não pertence ao domínio @usp.br.
class NotUspEmail extends AuthFailure {
  const NotUspEmail()
      : super('Use seu e-mail institucional da USP (@usp.br).');
}

class InvalidEmail extends AuthFailure {
  const InvalidEmail() : super('E-mail inválido.');
}

class InvalidCredentials extends AuthFailure {
  const InvalidCredentials() : super('E-mail ou senha incorretos.');
}

class UserNotFound extends AuthFailure {
  const UserNotFound()
      : super('Não há conta com esse e-mail. Cadastre-se primeiro.');
}

class UserDisabled extends AuthFailure {
  const UserDisabled() : super('Esta conta foi desativada.');
}

class EmailAlreadyInUse extends AuthFailure {
  const EmailAlreadyInUse()
      : super('Já existe uma conta com esse e-mail. Tente fazer login.');
}

class WeakPassword extends AuthFailure {
  const WeakPassword()
      : super('Senha muito fraca. Use ao menos 8 caracteres com letras e números.');
}

class TooManyRequests extends AuthFailure {
  const TooManyRequests()
      : super('Muitas tentativas. Aguarde alguns minutos antes de tentar novamente.');
}

class NetworkError extends AuthFailure {
  const NetworkError() : super('Sem conexão com o servidor.');
}

class RequiresRecentLogin extends AuthFailure {
  const RequiresRecentLogin()
      : super('Por segurança, faça login novamente para continuar.');
}

class UnknownAuthFailure extends AuthFailure {
  const UnknownAuthFailure(String detail)
      : super('Erro inesperado: $detail');
}
