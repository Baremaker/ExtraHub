import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/domain/app_user.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/members_repository.dart';
import '../../domain/member.dart';

// ─── REPOSITÓRIO ──────────────────────────────────────────────────────────────
final membersRepositoryProvider = Provider<MembersRepository>(
  (ref) => MembersRepository(ref.watch(firestoreProvider)),
);

// ─── LISTAS ───────────────────────────────────────────────────────────────────

/// Membros ativos da extra ativa.
final activeMembersProvider = StreamProvider<List<Member>>((ref) {
  final extraId =
      ref.watch(currentAppUserProvider).value?.activeExtraId;
  if (extraId == null) return Stream<List<Member>>.value(const []);
  return ref.watch(membersRepositoryProvider).watchActive(extraId);
});

/// Ex-membros (HU-08).
final inactiveMembersProvider = StreamProvider<List<Member>>((ref) {
  final extraId =
      ref.watch(currentAppUserProvider).value?.activeExtraId;
  if (extraId == null) return Stream<List<Member>>.value(const []);
  return ref.watch(membersRepositoryProvider).watchInactive(extraId);
});

// ─── SINGLE MEMBER ────────────────────────────────────────────────────────────

/// Stream do membro identificado por [uid] na extra ativa.
final memberByIdProvider =
    StreamProvider.family<Member?, String>((ref, uid) {
  final extraId =
      ref.watch(currentAppUserProvider).value?.activeExtraId;
  if (extraId == null) return Stream<Member?>.value(null);
  return ref.watch(membersRepositoryProvider).watchOne(extraId, uid);
});

// ─── MEMBERSHIP DO USUÁRIO ATUAL ──────────────────────────────────────────────

/// `Member` correspondente ao usuário atualmente logado, na extra ativa.
///
/// Usado para checar role/isOwner na UI (mostrar ou esconder botões admin).
final currentMembershipProvider = StreamProvider<Member?>((ref) {
  final user = ref.watch(currentAppUserProvider).value;
  final extraId = user?.activeExtraId;
  if (user == null || extraId == null) return Stream<Member?>.value(null);
  return ref.watch(membersRepositoryProvider).watchOne(extraId, user.uid);
});

// ─── USER POR UID (perfil de outro membro) ────────────────────────────────────

/// `AppUser` por uid (para detalhes/perfil de outro membro).
final userByIdProvider =
    FutureProvider.family<AppUser?, String>((ref, uid) async {
  return ref.watch(appUserRepositoryProvider).get(uid);
});
