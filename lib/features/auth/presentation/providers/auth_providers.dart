import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/app_user_repository.dart';
import '../../data/auth_repository.dart';
import '../../domain/app_user.dart';

// ─── INSTÂNCIAS DE BACKEND ────────────────────────────────────────────────────
final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

final firestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

// ─── REPOSITÓRIOS ─────────────────────────────────────────────────────────────
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(firebaseAuthProvider)),
);

final appUserRepositoryProvider = Provider<AppUserRepository>(
  (ref) => AppUserRepository(ref.watch(firestoreProvider)),
);

// ─── ESTADO DE AUTENTICAÇÃO ───────────────────────────────────────────────────

/// Stream do `User` do Firebase Auth (`null` quando deslogado).
///
/// Não expõe [AppUser] — esse vem do Firestore via [currentAppUserProvider].
final authStateProvider = StreamProvider<User?>(
  (ref) => ref.watch(authRepositoryProvider).authStateChanges(),
);

/// `User?` síncrono. Útil para checks rápidos no router.
final currentFirebaseUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).value;
});

/// Stream do [AppUser] do usuário logado. `null` se deslogado ou se o doc
/// ainda não foi criado.
final currentAppUserProvider = StreamProvider<AppUser?>((ref) {
  final firebaseUser = ref.watch(authStateProvider).value;
  if (firebaseUser == null) {
    return Stream<AppUser?>.value(null);
  }
  return ref.watch(appUserRepositoryProvider).watch(firebaseUser.uid);
});
