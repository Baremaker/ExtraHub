import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/extra.dart';
import '../../domain/invite.dart';
import '../providers/extras_providers.dart';

/// Tela mostrada quando o usuário está logado mas precisa escolher (ou criar)
/// uma extra para abrir. Exibe, na ordem:
///   1. Convites pendentes (com aceitar/recusar)
///   2. Extras de que o usuário já é membro (clicáveis)
///   3. Botão "Cadastrar nova extra"
///
/// Se o usuário ainda não tem extras nem convites, mostra estado vazio
/// chamando para criar a primeira.
class ChooseExtraScreen extends ConsumerWidget {
  const ChooseExtraScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invitesAsync = ref.watch(pendingInvitesProvider);
    final extrasAsync = ref.watch(myExtrasProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ─── HEADER ──────────────────────────────────────────
                  const Center(child: AppLogo()),
                  const SizedBox(height: AppSpacing.x3l),
                  Text(
                    'Suas extras',
                    style: Theme.of(context).textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Selecione uma extra para entrar, aceite um convite, '
                    'ou cadastre uma nova.',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.x3l),

                  // ─── CONVITES PENDENTES ──────────────────────────────
                  invitesAsync.when(
                    data: (invites) => invites.isEmpty
                        ? const SizedBox.shrink()
                        : _PendingInvitesSection(invites: invites),
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                  ),

                  // ─── MINHAS EXTRAS ───────────────────────────────────
                  extrasAsync.when(
                    data: (extras) => _ExtrasSection(extras: extras),
                    loading: () => const Padding(
                      padding: EdgeInsets.all(AppSpacing.xl),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, _) => Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Text(
                        'Erro ao carregar extras: $e',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // ─── AÇÕES ───────────────────────────────────────────
                  AppButton(
                    label: 'Cadastrar nova extra',
                    icon: Icons.add,
                    onPressed: () =>
                        context.pushNamed(Routes.createExtraName),
                    fullWidth: true,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Center(
                    child: TextButton(
                      onPressed: () => ref
                          .read(authControllerProvider.notifier)
                          .signOut(),
                      child: const Text('Sair'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// CONVITES PENDENTES
// ════════════════════════════════════════════════════════════════════════════

class _PendingInvitesSection extends StatelessWidget {
  const _PendingInvitesSection({required this.invites});
  final List<Invite> invites;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Text(
            'CONVITES PENDENTES',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        ...invites.map((i) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _InviteCard(invite: i),
            )),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

class _InviteCard extends ConsumerStatefulWidget {
  const _InviteCard({required this.invite});
  final Invite invite;

  @override
  ConsumerState<_InviteCard> createState() => _InviteCardState();
}

class _InviteCardState extends ConsumerState<_InviteCard> {
  bool _busy = false;

  Future<void> _accept() async {
    setState(() => _busy = true);
    try {
      final firebaseUser = ref.read(currentFirebaseUserProvider);
      final appUser = ref.read(currentAppUserProvider).value;
      if (firebaseUser == null || appUser == null) return;

      await ref.read(invitesRepositoryProvider).acceptInvite(
            inviteId: widget.invite.id,
            uid: firebaseUser.uid,
            userEmail: firebaseUser.email!,
            userDisplayName: appUser.displayName,
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _decline() async {
    setState(() => _busy = true);
    try {
      await ref
          .read(invitesRepositoryProvider)
          .declineInvite(widget.invite.id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.radiusLg,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.invite.extraName,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${widget.invite.invitedBy.displayName} te convidou como '
            '${widget.invite.role.label.toLowerCase()}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Aceitar',
                  loading: _busy,
                  onPressed: _busy ? null : _accept,
                  fullWidth: true,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppButton(
                  label: 'Recusar',
                  variant: AppButtonVariant.secondary,
                  onPressed: _busy ? null : _decline,
                  fullWidth: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// LISTA DE EXTRAS
// ════════════════════════════════════════════════════════════════════════════

class _ExtrasSection extends ConsumerWidget {
  const _ExtrasSection({required this.extras});
  final List<Extra> extras;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (extras.isEmpty) {
      return const EmptyState(
        icon: Icons.school_outlined,
        title: 'Você ainda não está em nenhuma extra',
        subtitle:
            'Crie uma nova extra ou aguarde um convite de quem já está em uma.',
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Text(
            'MINHAS EXTRAS',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        ...extras.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _ExtraCard(extra: e),
            )),
      ],
    );
  }
}

class _ExtraCard extends ConsumerWidget {
  const _ExtraCard({required this.extra});
  final Extra extra;

  Future<void> _enter(WidgetRef ref) async {
    final user = ref.read(currentAppUserProvider).value;
    if (user == null) return;
    await ref
        .read(appUserRepositoryProvider)
        .setActiveExtra(user.uid, extra.id);
    // O redirect do router leva para o dashboard.
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadius.radiusLg,
        onTap: () => _enter(ref),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: AppRadius.radiusLg,
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      extra.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      '${extra.category.label} · ${extra.memberCount} membros',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right,
                  color: AppColors.txtTertiary),
            ],
          ),
        ),
      ),
    );
  }
}
