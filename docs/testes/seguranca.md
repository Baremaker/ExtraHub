# Seção 5 — Testes de Segurança (Firestore Rules)

> Material pronto para o relatório da Entrega 2. Cobre a estratégia, os casos de
> teste, as vulnerabilidades encontradas e as correções, com resultados
> reproduzíveis.

## Estratégia e ambiente

As regras de segurança do Cloud Firestore (`firestore.rules`) são a camada de
autorização do ExtraHub (não há backend próprio). Foram testadas com **testes
unitários de regras** usando
[`@firebase/rules-unit-testing`](https://firebase.google.com/docs/rules/unit-tests)
+ **mocha**, executados contra o **Firebase Emulator Suite** — nunca contra
produção.

Cada caso assume um usuário (autenticado ou não; `@usp.br` ou não; membro,
admin, dono, convidado ou estranho) e verifica se uma operação é **permitida**
ou **negada**. São **22 casos**, todos passando.

**Como reproduzir** (a partir da raiz do repositório):

```bash
./test_rules/run.sh
```

Código dos testes: [`test_rules/rules.test.js`](../../test_rules/rules.test.js).

## Vulnerabilidades encontradas e correções

A auditoria estática apontou 3 bloqueios críticos + 1 vazamento; os testes
**confirmaram** os 3 bloqueios (reproduzindo a negação indevida) e, após a
correção, passaram a confirmar o comportamento correto.

| # | Vulnerabilidade / bug | Causa | Correção |
|---|------------------------|-------|----------|
| V1 | **Criar extra falhava** (HU-01) | A criação do membro-dono, no mesmo `batch` da extra, validava `get(extras/X).ownerId`, mas `get()` não enxerga doc criado na mesma transação. | Trocar `get()` por **`getAfter()`** na regra de criação de membro (ramo do dono). |
| V2 | **Signup não persistia o perfil** (HU-02) | A criação de `users/{uid}` exigia `email_verified == true`, mas o perfil é criado logo após o cadastro, antes da verificação. | Separar `isUspEmail()` (sem verificação) de `isAuthed()`; usar `isUspEmail()` **somente** no `create` de `users/{uid}`. |
| V3 | **Aceitar convite falhava** (HU-03) | O convidado precisa criar o próprio `members/{uid}` e incrementar `memberCount`, mas as regras só permitiam isso a um admin. | Convite com **id determinístico** (`invites/{extraId}__{email}`) + regra que autoriza o self-create do membership e o `+1` em `memberCount` quando há convite **pendente e não expirado**, com o papel batendo. |
| V4 | **Leitura global de perfis (PII)** | `users/{uid}` tem `allow read: if isAuthed()` — qualquer logado lê celular/nº USP de qualquer um. | **Risco residual aceito** nesta entrega (app fechado de uma extra; HU-07/HU-08 dependem de ler curso/skills de outros membros). Mitigação futura: restringir PII sensível. Documentado abaixo. |

## Casos de teste (resumo dos 22)

**Autenticação e e-mail institucional**
| Caso | Esperado | Resultado |
|------|----------|-----------|
| Não autenticado lê perfil | negar | ✅ |
| E-mail não `@usp.br` (autenticado) lê perfil | negar | ✅ |
| E-mail não verificado cria extra | negar | ✅ |

**Isolamento multi-tenant**
| Caso | Esperado | Resultado |
|------|----------|-----------|
| Membro ativo lê a própria extra | permitir | ✅ |
| Usuário `@usp.br` não-membro lê a extra | negar | ✅ |
| Não-membro lê projetos/avisos/eventos | negar | ✅ |

**HU-02 — signup cria o próprio perfil (correção V2)**
| Caso | Esperado | Resultado |
|------|----------|-----------|
| `@usp.br` não verificado cria o próprio perfil | permitir | ✅ |
| `@usp.br` verificado cria o próprio perfil | permitir | ✅ |
| Criar perfil de OUTRO uid | negar | ✅ |
| Escrever em outras coleções antes de verificar | negar | ✅ |

**HU-01 — criar extra (correção V1)**
| Caso | Esperado | Resultado |
|------|----------|-----------|
| Batch extra + membership do dono + update do user | permitir | ✅ |
| Extra do batch com `ownerId` diferente do criador | negar | ✅ |
| Criar membership `isOwner=true` em extra de outro dono | negar | ✅ |

**HU-03 — aceitar convite (correção V3)**
| Caso | Esperado | Resultado |
|------|----------|-----------|
| Batch completo do aceite (convite + membership + user + `memberCount`) | permitir | ✅ |
| Convidado cria o próprio membership (papel batendo) | permitir | ✅ |
| Incrementar `memberCount` em +1 | permitir | ✅ |
| Criar membership SEM convite | negar | ✅ |
| Criar membership com papel acima do convite | negar | ✅ |
| Aceitar convite expirado | negar | ✅ |
| Incrementar `memberCount` em mais de +1 | negar | ✅ |
| Usar o convite de outra pessoa (e-mail diferente) | negar | ✅ |

**Achado V4 (documentação)**
| Caso | Comportamento atual | Resultado |
|------|---------------------|-----------|
| Usuário sem extra em comum lê perfil de qualquer um | permitido (risco residual) | ✅ documentado |

## Conclusão

Os três bloqueios que impediam os fluxos centrais (criar extra, cadastro e
aceite de convite) foram corrigidos nas regras e cobertos por testes — incluindo
**casos negativos** que provam que acessos indevidos continuam bloqueados
(escalada de papel, reuso de convite alheio, abuso de contador, acesso
cross-tenant). O único item em aberto (V4) é um risco residual de privacidade,
aceito para esta entrega e registrado para evolução futura.
</content>
