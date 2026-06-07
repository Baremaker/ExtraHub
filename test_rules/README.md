# Testes das Firestore Security Rules

Testes unitários das regras de segurança (`../firestore.rules`) usando
[`@firebase/rules-unit-testing`](https://firebase.google.com/docs/rules/unit-tests)
contra o **Firebase Emulator Suite**. Não tocam em produção.

## Como rodar

A partir da raiz do repositório:

```bash
./test_rules/run.sh
```

O script garante um JDK no PATH (o emulador do Firestore precisa de Java; ele
reaproveita o JDK do Android Studio se necessário), instala as dependências na
primeira vez e sobe o emulador só durante os testes.

Pré-requisitos: Node ≥ 18, `firebase-tools` (instalado: `npm i -g firebase-tools`)
e um JDK. O JAR do emulador é baixado automaticamente pelo `firebase-tools` na
primeira execução (precisa de internet uma vez).

## O que está coberto

| Grupo | O que verifica |
|-------|----------------|
| ✅ Autenticação / `@usp.br` | Nega leitura sem login e para e-mail fora de `@usp.br`; nega escrita com e-mail não verificado. |
| ✅ Isolamento multi-tenant | Membro lê a própria extra; não-membro **não** lê extra/projetos/avisos/eventos. |
| 🔴 Bloqueio 6.1 | Criar extra + membership do dono na **mesma transação** é negado (o `get()` da regra não enxerga a extra recém-criada). |
| 🔴 Bloqueio 6.2 | Criar `users/{uid}` no **signup** é negado porque a regra exige `email_verified` antes da verificação. |
| 🔴 Bloqueio 6.3 | **Aceitar convite** é negado: o convidado não pode criar o próprio membership nem incrementar `memberCount`. |
| 🟡 Achado 6.4 | Documenta que qualquer usuário logado lê o perfil de qualquer outro (PII entre tenants). |

> Os testes 🔴 hoje **passam confirmando que a operação é NEGADA** (ou seja,
> reproduzem o bug). Quando as regras forem corrigidas (P0 passo 3), eles serão
> ajustados para exigir que a operação seja **permitida**. Detalhes e plano em
> `../docs/AUDITORIA.md` (§6).
</content>
