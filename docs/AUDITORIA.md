# Auditoria do ExtraHub — Fase 0

> ⚠️ **DOCUMENTO HISTÓRICO (Fase 0).** Descreve o estado do repositório em
> **06/06/2026**, antes dos commits que concluíram HU-05/07/08/09, as correções
> de Firestore Rules, os testes e a acessibilidade. **Não reflete o estado
> atual** — vários itens marcados abaixo como "parcial / placeholder /
> incompleto" **já foram finalizados**. Para o estado real e a lista de
> pendências remanescentes, ver `analise_pendencias.txt` na raiz do projeto.
> Mantido apenas como registro do processo.

> Documento de auditoria para a Entrega 2 de SSC0961. Mapeia o estado real do
> repositório contra as 9 Histórias de Usuário e contra o que o relatório final
> cobra (testes, segurança, acessibilidade, build nas 3 plataformas).
>
> **Data da auditoria:** 06/06/2026
> **Branch:** `main` · **Commit base:** `3203e19`
> **Verificado por:** auditoria estática + builds reais (web/APK) + `flutter analyze`.

---

## 1. Resumo executivo

O projeto está **maduro na camada de UI e de dados**: as 9 features existem,
o código é limpo, organizado por feature/camada, usa o design system de forma
consistente e **compila sem nenhum issue** (`flutter analyze` = 0,
`flutter build web` e `flutter build apk` OK).

O grosso do trabalho restante **não está nas features**, e sim em três frentes
que pesam na nota da Entrega 2 e hoje estão essencialmente vazias:

1. **Testes** — existe **1 teste, e está desabilitado** (`skip: true`). Cobertura ≈ 0%.
2. **Segurança** — as Firestore Rules têm **3 bloqueios prováveis de fluxos
   centrais** (signup, criação de extra e aceite de convite) que precisam ser
   validados no emulador e corrigidos. Sem testes de rules.
3. **Acessibilidade** — **zero `Semantics`/labels explícitos**, contraste
   reprovando em uma cor de texto, alvos de toque abaixo de 48dp. Nenhuma
   varredura automatizada feita ainda.

Além disso, há **2 lacunas de feature reais** (Dashboard agregador por papel —
HU-05; e "projetos do membro" no perfil — HU-07/HU-08) e **1 campo faltando** em
eventos ("convocados" — HU-09).

> ⚠️ **Achado mais importante:** as regras do Firestore, como escritas,
> aparentam **negar a criação do doc `users/{uid}` no signup**, a **criação da
> extra** e o **aceite de convite**. Se as regras estiverem deployadas, esses
> fluxos estão quebrados em produção. Isso é coerente com a armadilha do
> briefing ("quando algo funcionava e parou, suspeite de rules/config"). É o
> primeiro item a validar no emulador (detalhe na seção 6).
>
> **✅ Resolvido no P0:** os 3 bloqueios foram confirmados por teste e
> corrigidos. Ver §6 e `docs/testes/seguranca.md` (22 testes de rules passando).

---

## 2. Mapa do repositório

Arquitetura: **Clean leve, organizada por feature**. Cada feature tem
`data/` (repositórios Firestore), `domain/` (models freezed) e
`presentation/` (`screens/`, `widgets/`, `providers/` Riverpod).

```
lib/
├── main.dart                     # init Firebase + intl pt_BR + ProviderScope
├── firebase_options.dart         # gerado pelo flutterfire
├── app/
│   ├── app.dart                  # MaterialApp.router
│   ├── router/                   # go_router (app_router.dart, routes.dart)
│   ├── shell/                    # app_shell.dart (sidebar fixa/drawer), sidebar.dart
│   └── theme/                    # AppColors, AppTypography, AppSpacing, AppRadius, AppTheme
├── core/
│   ├── extensions/               # string_x (isUspEmail, senha), date_format_x (datas pt-BR)
│   ├── firestore/                # firestore_paths, timestamp_converter
│   └── widgets/                  # 12 componentes reutilizáveis (botão, avatar, badge, ...)
└── features/
    ├── auth/                     # login, signup, verify, forgot, repos, AppUser
    ├── extras/                   # criar/escolher extra, convites, ExtrasRepository, InvitesRepository
    ├── members/                  # lista, detalhe, convite, MembersRepository
    ├── projects/                 # CRUD, detalhe, ProjectsRepository (transações)
    ├── announcements/            # mural, AnnouncementsRepository
    ├── calendar/                 # calendário próprio + eventos, EventsRepository
    ├── dashboard/                # DashboardPlaceholderScreen (parcial)
    ├── profile/                  # meu perfil + edição
    └── splash/                   # splash/redirect
```

**Onde vive o quê**
- **Models (domain):** `lib/features/*/domain/*.dart` (+ `.freezed.dart`/`.g.dart` gerados).
- **Providers Riverpod:** `lib/features/*/presentation/providers/*.dart`.
- **Telas:** `lib/features/*/presentation/screens/*.dart`.
- **Regras de segurança:** `firestore.rules` (raiz). **Índices:** `firestore.indexes.json`.
- **Firestore paths centralizados:** `lib/core/firestore/firestore_paths.dart`.

**Modelo de dados (Firestore)**
```
users/{uid}                                  # perfil global (AppUser), extraIds[], activeExtraId
extras/{extraId}                             # Extra (ownerId, memberCount, projectCount, category)
  ├── members/{uid}                          # Member (role, isOwner, status, inProjectIds)
  ├── projects/{projectId}                   # Project (status, progress, members[], links[], ownerId=líder)
  ├── announcements/{id}                     # Announcement (pinned, author)
  └── events/{id}                            # AppEvent (startDate, allDay, relatedProjectId)
invites/{inviteId}                           # Invite top-level (email, extraId, role, status, expiresAt)
```

Multi-tenant via subcollections sob `extras/{extraId}` + `users/{uid}.extraIds`
e `activeExtraId`. Papéis via `role` (`admin`/`member`) + flag `isOwner`. ✔️
Coerente com a decisão "3 papéis via isOwner, sem Super Admin".

---

## 3. Status por História de Usuário

| HU | Feature | Status | Resumo |
|----|---------|--------|--------|
| HU-01 | Cadastro da Extra | ✅ | Fluxo e transação OK; bloqueio de rules **corrigido e testado** (§6 / P0). |
| HU-02 | Login email USP | ✅ | Login/verify/reset OK; `@usp.br` validado; criação do doc no signup **corrigida** (§6 / P0). |
| HU-03 | Gestão de Membros | ✅ | Convite/cargo/inativar/filtros OK; aceite de convite **corrigido** (§6 / P0). |
| HU-04 | Gestão de Projetos | ✅ | CRUD completo, transações atômicas (`inProjectIds`, `projectCount`), líder, links, progresso. |
| HU-05 | Dashboard | ✅ | Dashboard por papel (P2): membro vê projetos/avisos/eventos; admin vê visão geral + atalhos de gestão. |
| HU-06 | Mural de Avisos | ✅ | Publicar/editar/fixar/excluir, fixados no topo, datas relativas pt-BR. (Nota: "urgência" tratada como "fixado".) |
| HU-07 | Perfil do Membro | ✅ | Ver/editar dados + skills/interesses; projetos alocados listados no perfil (P2). |
| HU-08 | Histórico de Ex-membros | ✅ | Inativar (preserva doc), filtro, reativar, badge, e projetos do ex-membro no detalhe (P2). |
| HU-09 | Calendário de Eventos | ✅ | Calendário próprio, lista, all-day, projeto associado, e "convocados" (model+form+exibição, P2). |

> **✅ ATUALIZAÇÃO (P2):** HU-05, HU-07, HU-08 e HU-09 foram concluídas (commits
> `feat(dashboard)`, `feat(profile)`, `feat(calendar)`). Os detalhes por HU
> abaixo descrevem o **estado original** da auditoria (Fase 0).

### Detalhamento

**HU-01 — Cadastro da Extra** 🟡
`create_extra_screen.dart` + `ExtrasRepository.createExtra()` fazem **tudo em
uma transação**: cria `extras/{id}`, cria o membership do dono
(`role: admin`, `isOwner: true`), adiciona o id em `users/{uid}.extraIds` e
seta `activeExtraId`. Código correto. **Porém** o membership do dono é criado na
mesma transação da extra, e a rule de criação de membro faz
`get(.../extras/$(extraId)).data.ownerId == auth.uid` — esse `get()` **não
enxerga a extra criada na mesma transação** → negação provável (§6.1).

**HU-02 — Login com email USP** 🟡
`AuthRepository` valida `isUspEmail` (aceita subdomínios: `icmc.usp.br` etc.) em
login, signup e reset. Fluxo de verificação de email + recuperação de senha
prontos; o router redireciona para `/verify-email` enquanto não verificado.
**Porém** `signUp()` chama `createIfMissing(users/{uid})` **antes do email estar
verificado**, e a rule de `users/create` exige `email_verified == true` →
negação provável (§6.2).

**HU-03 — Gestão de Membros** 🟡
Convite por email `@usp.br` com validade de 7 dias (`expiresAt`), cargo
member/admin (`SegmentedButton`), aceitar/recusar (`choose_extra_screen`),
promover/rebaixar, **marcar inativo (preserva histórico)**, remover, e filtros
**Todos / Admins / Ex-membros** + busca. Owner é protegido. **Porém** o
`acceptInvite()` faz o convidado **criar o próprio doc de membro** e
**incrementar `memberCount`**, ações que as rules só permitem a um admin →
negação provável (§6.3). Observação menor: edição de "cargo/position" existe no
repositório mas não está exposta com destaque na UI.

**HU-04 — Gestão de Projetos** ✅
CRUD completo: título, descrição, categoria, datas, links (label+url), status
(planejamento/andamento/pausado/concluído/arquivado), barra de progresso,
membros alocados, líder (`ownerId`). `createProject`/`updateProject`/
`deleteProject` mantêm `inProjectIds` dos membros e `projectCount` da extra em
**transações atômicas**, validando que os membros existem. Lista usa `Wrap`
(evita a armadilha do `GridView`).

**HU-05 — Dashboard** 🟡 *(prioridade de feature)*
A tela existe (`DashboardPlaceholderScreen`) e mostra 4 cards de contadores
(membros ativos, projetos, avisos, eventos) — **iguais para qualquer papel**.
Falta o que a HU pede: **conteúdo adaptado ao papel** (Membro: projetos em que
está alocado, avisos recentes, próximos eventos; Admin: + atalhos de gestão e
visão geral). Há ainda um **box de texto hardcoded** ("A Fase 4 do
desenvolvimento está concluída…") que não pode ir para a entrega.

**HU-06 — Mural de Avisos** ✅
Admin publica (título, conteúdo, fixado), edita, fixa/desfixa, exclui.
Ordenação **fixados no topo, depois cronológica** (índice composto
`pinned desc, createdAt desc`). Datas relativas pt-BR ("Hoje, 14h32", "Ontem…").
*Nota:* a HU cita "urgência/fixado"; só `pinned` foi implementado — aceitável,
mas registrar no relatório.

**HU-07 — Perfil do Membro** 🟡
Ver/editar nome, celular, curso, semestre, nº USP, bio, **habilidades** e
**interesses**. **Falta** o que a HU pede explicitamente: **"exibe projetos
alocados e histórico"** — `Member.inProjectIds` existe mas **não é renderizado**
nem em `my_profile_screen` nem em `member_detail_screen`.

**HU-08 — Histórico de Ex-membros** 🟡
Inativação preserva o doc do membro (`status: inactive`, `leftAt`), filtro
"Ex-membros", badge "Ex-membro", reativar. Núcleo do histórico OK. **Falta** a
parte "com perfil e **projetos**" — mesma lacuna do HU-07 (projetos do membro
não aparecem na tela de detalhe).

**HU-09 — Calendário de Eventos** 🟡
`MonthCalendar` é **widget próprio, sem lib externa** (grid 6×7, pontinho de
evento, hoje/selecionado), + lista cronológica + criar/editar com data, horário,
**toggle dia inteiro**, local e **projeto associado**. **Falta "convocados"**
(lista de membros convidados): não existe no model `AppEvent` nem no formulário.

---

## 4. Build nas 3 plataformas

| Plataforma | Comando | Resultado |
|-----------|---------|-----------|
| Análise estática | `flutter analyze` | ✅ **No issues found** (Flutter 3.41.7 / Dart 3.11.5) |
| **Web** | `flutter build web --release` | ✅ **Built build/web** (~44s; só aviso informativo de WASM dry-run) |
| **Android** | `flutter build apk --debug` | ✅ **Built app-debug.apk** (~172s) |
| **iOS** | `flutter build ios` | ❌ **Não verificável aqui** — `flutter doctor` não tem Xcode (ambiente Linux). Precisa de macOS. |

**Config Android conferida:** `applicationId` = `br.usp.icmc.extrahub`,
`google-services.json` presente e com `package_name` batendo. ✔️
**Toolchains disponíveis:** Flutter ✓, Android SDK ✓, Chrome ✓, 2 devices.
**iOS:** sem `Runner`/Xcode neste ambiente → o build e o vídeo iOS exigem macOS
(ver questões em aberto). A pasta `ios/` precisa ser verificada em uma máquina
Apple.

---

## 5. Estado dos testes

- **Único arquivo:** `test/widget_test.dart` — um smoke test **com `skip: true`**.
- **Não existe** `integration_test/`, nem testes de unidade de repositórios, nem
  testes de rules.
- Dependências de teste presentes: `flutter_test`, `mocktail`. **Faltam**:
  `fake_cloud_firestore`, `firebase_auth_mocks` (para repos sem emulador) e setup
  do **Firebase Emulator Suite** (não há bloco `emulators` no `firebase.json`).
- **Cobertura aproximada: ~0%.**

Esta é a **maior frente de nota em aberto** (Seção 5 do relatório tem peso alto:
testes funcionais + segurança + acessibilidade).

---

## 6. Segurança (Firestore Rules)

**Pontos fortes** (já corretos):
- ✅ **Sem timestamp de expiração** (a armadilha clássica não está presente).
- ✅ `isAuthed()` exige autenticação **+ email verificado + `@usp.br`** (regex).
- ✅ **Isolamento multi-tenant** nas leituras: `extras/**` exige `isMember(extraId)`.
- ✅ Escrita gated por papel: `isAdmin`/`isOwner`; campos imutáveis via `unchanged()`.
- ✅ Owner protegido contra delete/alteração por outros admins.

### Achados (precisam de correção / validação no emulador)

> **✅ ATUALIZAÇÃO (P0):** 6.1, 6.2 e 6.3 foram **corrigidos e testados** no
> emulador (22 testes em `test_rules/`, relatório em `docs/testes/seguranca.md`).
> 6.4 ficou como **risco residual aceito** (decisão de produto). As regras
> corrigidas ainda **precisam ser deployadas** em produção (`firebase deploy
> --only firestore:rules`) — ação externa, a confirmar.

**6.1 🔴 Crítico — criação de membro referencia doc da mesma transação.**
Na criação da extra (HU-01), a rule de `members/create` (ramo do dono) faz
`get(.../extras/$(extraId)).data.ownerId == auth.uid`. Em uma transação, o
`get()` das rules **lê o estado anterior** — a extra recém-criada não é visível
→ criação do membro do dono **negada**. Efeito: **criar extra falha**.

**6.2 🔴 Crítico — `email_verified` bloqueia o doc de usuário no signup.**
`signUp()` cria `users/{uid}` logo após criar a conta, **antes** de o email ser
verificado. A rule `users/create` depende de `isAuthed()`, que exige
`email_verified == true` → **negada**. Efeito: **signup não persiste o perfil**;
o usuário fica preso no fluxo (router espera `AppUser` que nunca é criado).
*Correção:* separar um `isSignedIn()` (sem exigir verificação) para o
`create` de `users`, **ou** criar o doc só após a verificação.

**6.3 🔴 Crítico — aceite de convite exige permissão de admin.**
`acceptInvite()` faz o convidado **criar o próprio `members/{uid}`** (com
`isOwner:false`) e **incrementar `extras/{id}.memberCount`**. As rules só
permitem criar membro a um admin (ou ao dono no self-branch) e só permitem
atualizar a extra a um admin → **negadas**. Efeito: **aceitar convite falha**
(HU-03). *Correção:* permitir o self-create de membro quando existir um convite
**pendente e válido** correspondente (exigirá repensar o id/caminho do convite
para ser localizável pela rule, ex.: doc determinístico por `extraId+email`).

**6.4 🟡 Médio — leitura global de perfis (`users`).**
`users/{uid}` tem `allow read: if isAuthed()` — **qualquer** usuário logado lê
**qualquer** perfil (incluindo celular/nº USP). Vaza PII entre tenants e permite
enumeração. *Correção sugerida:* restringir a "eu mesmo OU compartilhamos alguma
extra", ou minimizar os campos sensíveis.

**6.5 🟢 Menor — Storage sem rules.**
`firebase_storage` está no `pubspec` mas **não é usado** (fotos fora de escopo) e
**não há `storage.rules`** nem bloco `storage` no `firebase.json`. Remover a
dependência (ou adicionar regra default-deny) evita ponto cego.

> **Importante:** 6.1–6.3 são *análise estática*. O próximo passo é **subir o
> Firebase Emulator Suite, escrever testes de rules** que reproduzam esses
> fluxos e **corrigir** — o que já entrega a "Seção 5 — Segurança" do relatório
> (casos de teste + vulnerabilidade + correção).

---

## 7. Acessibilidade

| Aspecto | Estado | Detalhe |
|--------|--------|---------|
| `Semantics` / `semanticLabel` explícitos | ❌ 0 | Nenhum widget semântico manual no `lib/`. |
| Tooltips em ícone-botão | 🟡 9 | Viram label semântico (bom), mas é o único reforço de a11y. |
| Contraste de texto | 🟡 | Maioria passa AA; **`txtTertiary #4A5568` reprova** (2.3–2.5:1) e **texto branco em botão verde = 3.39:1** (reprova AA normal, passa só "large"). |
| Alvos de toque ≥48dp | ❌ | Itens da sidebar (~32px) e chips de filtro (~32px) abaixo de 48dp. |
| Varredura automatizada | ❌ | Nenhuma rodada ainda (faltam testes de `meetsGuideline`/accessibility_tools). |

**Contrastes medidos (WCAG, fundo `#0D1117`/`#161B27`):**
- `txtPrimary` 15.7:1 ✅ · `txtSecondary` 6.0:1 ✅ · `accentText` 8.6:1 ✅ · `accent` 5.6:1 ✅
- `txtTertiary` **2.5:1 ❌** · branco em `accent` (botão primário) **3.4:1 ❌ (AA normal)**

Base não é ruim (cores principais passam, ícones têm tooltip), mas a Seção 5 do
relatório pede **casos de teste com ferramenta automatizada + correções** — hoje
zerado.

---

## 8. Dívidas técnicas e bugs

1. 🟡 **`members_screen` usa `GridView.count` com `childAspectRatio: 1.0`** — é
   exatamente a armadilha do briefing (overflow no mobile com 1 coluna). O
   `projects_screen` já usa `Wrap` corretamente; padronizar.
2. 🟡 **Dashboard com texto "placeholder" hardcoded** ("Fase 4 concluída…") e
   nome de classe `DashboardPlaceholderScreen` — impróprio para a entrega.
3. 🟢 **`analysis_options.yaml` referencia o plugin `custom_lint`** (e comenta
   `riverpod_lint`), mas **nenhum dos dois está no `pubspec`** → o plugin é
   inerte. Adicionar as deps (e rodar `dart run custom_lint`) ou remover a
   referência.
4. 🟢 **`DateFormatX.dayMonth` sem locale** — usa `DateFormat('MMM')` sem
   `'pt_BR'`, gerando mês em inglês ("APR" em vez de "ABR"), contrariando o
   próprio comentário.
5. 🟢 **`firebase_storage` é dependência morta** (nenhum uso em `lib/`).
6. 🟢 **`removeMember` (hard delete) exposto na UI** ao lado de "Marcar como
   ex-membro". A decisão de produto é **inativar, nunca apagar** (preserva
   HU-08); o botão "Remover" definitivo contradiz isso e pode destruir
   histórico. Considerar esconder/remover.
7. 🟢 **Sem bloco `emulators` no `firebase.json`** — necessário para a fase de
   testes.

---

## 9. Plano priorizado (do que mais pesa na nota → menos)

> Ordenado por impacto na nota da Entrega 2 e por desbloqueio. Sugestão de
> incrementos pequenos e revisáveis; cada item roda `flutter analyze` + testes.

**P0 — Desbloquear os fluxos centrais (segurança + funcional juntos)**
1. Subir **Firebase Emulator Suite** (Auth + Firestore) e adicionar bloco
   `emulators` no `firebase.json`.
2. Escrever **testes de rules** que reproduzam signup, criar extra e aceitar
   convite → confirmar as negações 6.1/6.2/6.3.
3. **Corrigir as rules** (e ajustar o cliente onde necessário) até os 3 fluxos
   passarem. *(Mexe em Rules → confirmo com você antes.)*
   → entrega direta da **Seção 5 (Segurança)** do relatório.

**P1 — Testes funcionais dos fluxos críticos** (peso alto, Seção 5)
4. Unit/integração com `fake_cloud_firestore` + `mocktail`: validação `@usp.br`,
   criar extra, convite→aceite, **CRUD de projeto com as transações**
   (`inProjectIds`/`projectCount`), publicar aviso, criar evento.

**P2 — Fechar lacunas de feature**
5. **HU-05 Dashboard** por papel (remover placeholder; Membro vs Admin).
6. **HU-07/HU-08** projetos do membro no perfil/detalhe (usar `inProjectIds`).
7. **HU-09** campo "convocados" (model `AppEvent` + form + exibição).

**P3 — Acessibilidade** (Seção 5)
8. `Semantics`/labels, corrigir `txtTertiary` e contraste do botão primário,
   alvos ≥48dp; rodar ferramenta automatizada e **documentar casos/resultados**.

**P4 — Build e documentação do relatório**
9. Confirmar build **web + Android**; **instruções/plano para iOS** (depende de
   macOS).
10. `docs/` para a Seção 4 (tecnologias, estrutura, integração com BD) e tabelas
    de casos de teste/resultados em pt-BR, prontas para o relatório.

**P5 — Limpeza de dívidas** (itens da §8: GridView→Wrap, locale de data, deps
mortas, lint inerte, hard-delete).

---

### Questões em aberto (precisam de você antes de algumas fases)
1. **macOS disponível** para gerar build/vídeo iOS? (Se não, documento uma
   alternativa: build web+Android no vídeo e plano de iOS.)
2. **Testes contra o Firebase real (`extrahub-fcc35`) ou emulador?** (Default
   recomendado: **emulador**, sem tocar produção.)
3. **Workflow de Git:** commits incrementais direto em `main` (como hoje) ou
   branch + PRs?

> Fim da Fase 0. **Aguardando OK** (e respostas às 3 questões) para começar pelo
> P0. Não vou codar feature antes da sua aprovação.
</content>
