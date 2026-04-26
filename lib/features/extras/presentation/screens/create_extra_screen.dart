import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/extra_category.dart';
import '../providers/extras_providers.dart';

class CreateExtraScreen extends ConsumerStatefulWidget {
  const CreateExtraScreen({super.key});

  @override
  ConsumerState<CreateExtraScreen> createState() =>
      _CreateExtraScreenState();
}

class _CreateExtraScreenState extends ConsumerState<CreateExtraScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  ExtraCategory _category = ExtraCategory.juniorEnterprise;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final firebaseUser = ref.read(currentFirebaseUserProvider);
      final appUser = ref.read(currentAppUserProvider).value;
      if (firebaseUser == null || appUser == null) {
        throw StateError('Usuário não autenticado.');
      }

      await ref.read(extrasRepositoryProvider).createExtra(
            ownerUid: firebaseUser.uid,
            ownerEmail: firebaseUser.email!,
            ownerDisplayName: appUser.displayName,
            name: _nameCtrl.text,
            description: _descCtrl.text,
            category: _category,
          );
      // O redirect do router leva ao dashboard.
    } catch (e) {
      if (mounted) {
        setState(() => _error = 'Erro ao criar extra: $e');
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar nova extra'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _submitting ? null : () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Sobre a extra',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Você se tornará o administrador-dono desta extra. '
                      'Outros admins e membros podem ser adicionados depois.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    AppTextField(
                      label: 'Nome',
                      hint: 'Ex: Empresa Júnior X, Atlética Y',
                      controller: _nameCtrl,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        final value = v?.trim() ?? '';
                        if (value.isEmpty) return 'Informe o nome.';
                        if (value.length < 3) {
                          return 'Mínimo 3 caracteres.';
                        }
                        if (value.length > 80) {
                          return 'Máximo 80 caracteres.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    Text(
                      'Categoria',
                      style:
                          Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: const Color(0xFF8892A4),
                              ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    DropdownButtonFormField<ExtraCategory>(
                      initialValue: _category,
                      onChanged: _submitting
                          ? null
                          : (v) {
                              if (v != null) setState(() => _category = v);
                            },
                      items: ExtraCategory.values
                          .map((c) => DropdownMenuItem(
                                value: c,
                                child: Text(c.label),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    AppTextField(
                      label: 'Descrição (opcional)',
                      hint: 'Sobre o que é a sua extra?',
                      controller: _descCtrl,
                      maxLines: 4,
                      minLines: 3,
                      maxLength: 500,
                    ),

                    if (_error != null) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        _error!,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                              color:
                                  Theme.of(context).colorScheme.error,
                            ),
                      ),
                    ],

                    const SizedBox(height: AppSpacing.xl),
                    AppButton(
                      label: 'Criar extra',
                      onPressed: _submitting ? null : _submit,
                      loading: _submitting,
                      fullWidth: true,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Center(
                      child: TextButton(
                        onPressed:
                            _submitting ? null : () => context.pop(),
                        child: const Text('Cancelar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
