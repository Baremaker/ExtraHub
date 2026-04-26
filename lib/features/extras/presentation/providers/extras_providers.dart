import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/extras_repository.dart';
import '../../data/invites_repository.dart';
import '../../domain/extra.dart';
import '../../domain/invite.dart';

// ─── REPOSITÓRIOS ─────────────────────────────────────────────────────────────
final extrasRepositoryProvider = Provider<ExtrasRepository>(
  (ref) => ExtrasRepository(ref.watch(firestoreProvider)),
);

final invitesRepositoryProvider = Provider<InvitesRepository>(
  (ref) => InvitesRepository(ref.watch(firestoreProvider)),
);

// ─── EXTRAS DO USUÁRIO ATUAL ─────────────────────────────────────────────────

/// Stream da lista de [Extra] em que o usuário atual é membro.
/// `null` quando deslogado.
final myExtrasProvider = FutureProvider<List<Extra>>((ref) async {
  final user = ref.watch(currentAppUserProvider).value;
  if (user == null || user.extraIds.isEmpty) return const [];
  return ref.watch(extrasRepositoryProvider).getMany(user.extraIds);
});

/// Extra atualmente selecionada (`activeExtraId` do AppUser). `null` se
/// o usuário ainda não escolheu.
final activeExtraProvider = StreamProvider<Extra?>((ref) {
  final user = ref.watch(currentAppUserProvider).value;
  final activeId = user?.activeExtraId;
  if (activeId == null) return Stream<Extra?>.value(null);
  return ref.watch(extrasRepositoryProvider).watch(activeId);
});

// ─── CONVITES ────────────────────────────────────────────────────────────────

/// Convites pendentes para o e-mail do usuário logado.
final pendingInvitesProvider = StreamProvider<List<Invite>>((ref) {
  final firebaseUser = ref.watch(currentFirebaseUserProvider);
  final email = firebaseUser?.email;
  if (email == null) return Stream<List<Invite>>.value(const []);
  return ref.watch(invitesRepositoryProvider).watchPendingFor(email);
});
