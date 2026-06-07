# Seção 5 — Testes Funcionais

> Material para o relatório da Entrega 2. Cobre a estratégia, os casos de teste,
> os resultados e as correções dos fluxos críticos do ExtraHub.

## Estratégia e ambiente

Os fluxos críticos do app concentram-se nos **repositórios** (camada `data/`),
que encapsulam as transações do Firestore (criar extra, aceitar convite, CRUD de
projetos com `inProjectIds`/`projectCount`, etc.). Eles foram testados com:

- **`flutter_test`** como runner.
- **`fake_cloud_firestore`** — um Firestore em memória que executa transações,
  `FieldValue.increment`, `arrayUnion/arrayRemove` e `serverTimestamp` sem rede e
  sem tocar em produção.
- **`mocktail`** — para mockar o `FirebaseAuth` nos testes do `AuthRepository`.

**Como rodar** (a partir da raiz):

```bash
flutter test
```

São **27 testes** automatizados, todos passando. Código em `test/`.

## Casos de teste e resultados

### Validação de e-mail institucional e regras de formulário
| Caso | Esperado | Resultado |
|------|----------|-----------|
| `isUspEmail` aceita `@usp.br` e subdomínios (`icmc.usp.br`) | aceitar | ✅ |
| `isUspEmail` rejeita não-USP e falsificações (`usp.br.evil.com`) | rejeitar | ✅ |
| `isStrongPassword` exige 8+ chars com letra e número | validar | ✅ |
| `isFullName` exige nome + sobrenome | validar | ✅ |
| `AuthRepository.signIn` rejeita e-mail não `@usp.br` (sem chamar o Auth) | `NotUspEmail` | ✅ |
| `AuthRepository.signUp` rejeita e-mail não `@usp.br` | `NotUspEmail` | ✅ |
| `AuthRepository.sendPasswordResetEmail` rejeita e-mail não `@usp.br` | `NotUspEmail` | ✅ |

### HU-01 — Criar extra (transação)
| Caso | Esperado | Resultado |
|------|----------|-----------|
| `createExtra` cria extra + membership do dono (admin/owner) + atualiza `users` | tudo consistente | ✅ |
| `createExtra` falha se o doc do usuário não existe | `StateError` | ✅ |

### HU-03 — Convites
| Caso | Esperado | Resultado |
|------|----------|-----------|
| `createInvite` gera id determinístico `extraId__email` (normalizado) | id correto | ✅ |
| `createInvite` bloqueia convite pendente duplicado | `StateError` | ✅ |
| `acceptInvite` cria membership, +1 `memberCount`, atualiza `users`, marca `accepted` | consistente | ✅ |
| `acceptInvite` recusa convite expirado | `StateError` | ✅ |
| `declineInvite` marca como `declined` | status correto | ✅ |

### HU-04 — Projetos (transações `inProjectIds` / `projectCount`)
| Caso | Esperado | Resultado |
|------|----------|-----------|
| `createProject` grava projeto, popula `inProjectIds` dos alocados e +1 `projectCount` | consistente | ✅ |
| `createProject` falha se um membro alocado não existe | `StateError` | ✅ |
| `updateProject` sincroniza `inProjectIds` (adiciona novos, remove os que saíram) | consistente | ✅ |
| `deleteProject` remove `inProjectIds` e -1 `projectCount` | consistente | ✅ |

### HU-06 — Avisos
| Caso | Esperado | Resultado |
|------|----------|-----------|
| `create` grava aviso com autor e `pinned` | correto | ✅ |
| `togglePinned` alterna o destaque | correto | ✅ |
| `update` altera título/corpo e mantém o autor | correto | ✅ |

### HU-08 — Membros / ex-membros
| Caso | Esperado | Resultado |
|------|----------|-----------|
| `markAsInactive` marca ex-membro (preserva doc) e -1 `memberCount` | correto | ✅ |
| `reactivate` volta a ativo e +1 `memberCount` | correto | ✅ |
| `promoteToAdmin` / `demoteToMember` alteram o papel | correto | ✅ |
| `removeMember` apaga doc, tira `extraId` do user e -1 `memberCount` | correto | ✅ |

### HU-09 — Eventos
| Caso | Esperado | Resultado |
|------|----------|-----------|
| `create` grava evento com convocados, local e projeto associado | correto | ✅ |
| `update` substitui os convocados | correto | ✅ |

## Erros encontrados e estratégias de correção

Durante a construção dos testes funcionais (e dos testes de segurança que os
antecederam — ver `seguranca.md`), o principal achado foi que **os três fluxos
centrais (cadastro, criar extra e aceitar convite) estavam bloqueados pelas
Firestore Rules**. A correção (regras + id determinístico de convite) está
documentada em `seguranca.md`; os testes funcionais acima exercitam exatamente
esses fluxos já corrigidos, garantindo a consistência das transações
(contadores e `inProjectIds` sempre coerentes).

Pontos de robustez confirmados pelos testes: rejeição de convite expirado,
bloqueio de convite duplicado, falha controlada ao alocar membro inexistente em
projeto, e preservação do histórico ao inativar um membro (o doc não é apagado).
</content>
