import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/auth_failure.dart';
import 'auth_providers.dart';

/// Controller de operações de autenticação (login, signup, reset, etc).
///
/// Diferente de `authStateProvider` — que apenas reflete o estado do
/// FirebaseAuth — este controller é o que a UI usa para *executar* uma
/// ação. Estado é `AsyncValue<void>`:
///   - `AsyncData(null)` → idle ou sucesso
///   - `AsyncLoading()`  → operação em andamento
///   - `AsyncError(...)` → último erro (já mapeado para `AuthFailure`)
class AuthController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Faz login. Retorna `true` em sucesso, `false` em erro (UI lê o estado).
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(authRepositoryProvider)
          .signIn(email: email, password: password);
    });
    return !state.hasError;
  }

  /// Cria conta nova + cria doc users/{uid} no Firestore + envia verification.
  Future<bool> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final auth = ref.read(authRepositoryProvider);
      final users = ref.read(appUserRepositoryProvider);

      final credential = await auth.signUp(
        email: email,
        password: password,
        displayName: displayName,
      );
      final user = credential.user;
      if (user == null) {
        throw const UnknownAuthFailure('Falha ao criar usuário.');
      }
      await users.createIfMissing(
        uid: user.uid,
        email: user.email ?? email.trim().toLowerCase(),
        displayName: displayName.trim(),
      );
    });
    return !state.hasError;
  }

  /// Envia email de redefinição de senha.
  Future<bool> sendPasswordReset(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).sendPasswordResetEmail(email);
    });
    return !state.hasError;
  }

  /// Recarrega o usuário atual e retorna se o e-mail já está verificado.
  Future<bool> checkEmailVerified() async {
    final auth = ref.read(authRepositoryProvider);
    await auth.reloadCurrentUser();
    return auth.currentUser?.emailVerified ?? false;
  }

  /// Reenvia e-mail de verificação.
  Future<void> resendEmailVerification() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).sendEmailVerification();
    });
  }

  /// Logout.
  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signOut();
    });
  }
}

final authControllerProvider =
    AsyncNotifierProvider<AuthController, void>(AuthController.new);
