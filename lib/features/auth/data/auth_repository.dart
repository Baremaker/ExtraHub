import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/extensions/string_x.dart';
import '../domain/auth_failure.dart';

/// Repositório de autenticação. Encapsula `FirebaseAuth` para que a UI nunca
/// importe diretamente o pacote do Firebase — assim mockamos em testes e
/// trocamos a impl no futuro se precisar.
class AuthRepository {
  AuthRepository(this._auth);

  final FirebaseAuth _auth;

  /// Stream que emite o usuário atual (`null` quando deslogado).
  ///
  /// Usamos `userChanges()` (em vez de `authStateChanges()`) para também
  /// capturar mudanças em campos do user — em particular, `emailVerified`
  /// após o usuário clicar no link de verificação e o app chamar
  /// [reloadCurrentUser]. Isso permite que o router redirecione
  /// automaticamente assim que a verificação acontece.
  Stream<User?> authStateChanges() => _auth.userChanges();

  /// Usuário atual sem stream. Pode ser `null`.
  User? get currentUser => _auth.currentUser;

  /// Faz login com email institucional + senha.
  ///
  /// Lança [AuthFailure] em caso de erro.
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    final normalized = email.trim().toLowerCase();
    if (!normalized.isUspEmail) {
      throw const NotUspEmail();
    }
    try {
      return await _auth.signInWithEmailAndPassword(
        email: normalized,
        password: password,
      );
    } catch (e) {
      throw AuthFailure.from(e);
    }
  }

  /// Cria conta nova. Após criar, atualiza o `displayName` e dispara o
  /// e-mail de verificação. **Não cria o doc em `users/{uid}`** — isso é
  /// responsabilidade do `AppUserRepository`, chamado em sequência pelo
  /// controller.
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final normalized = email.trim().toLowerCase();
    if (!normalized.isUspEmail) {
      throw const NotUspEmail();
    }
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: normalized,
        password: password,
      );
      await credential.user?.updateDisplayName(displayName.trim());
      await credential.user?.sendEmailVerification();
      return credential;
    } catch (e) {
      throw AuthFailure.from(e);
    }
  }

  /// Envia e-mail de redefinição de senha.
  Future<void> sendPasswordResetEmail(String email) async {
    final normalized = email.trim().toLowerCase();
    if (!normalized.isUspEmail) {
      throw const NotUspEmail();
    }
    try {
      await _auth.sendPasswordResetEmail(email: normalized);
    } catch (e) {
      throw AuthFailure.from(e);
    }
  }

  /// Reenvia o e-mail de verificação para o usuário atual.
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      throw AuthFailure.from(e);
    }
  }

  /// Recarrega o usuário atual do servidor (para checar se já verificou
  /// o e-mail, por exemplo).
  Future<void> reloadCurrentUser() async {
    try {
      await _auth.currentUser?.reload();
    } catch (e) {
      throw AuthFailure.from(e);
    }
  }

  /// Logout.
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw AuthFailure.from(e);
    }
  }
}
