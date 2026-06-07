# Seção 4 — Desenvolvimento do Aplicativo

> Pronta para o relatório da Entrega 2 (pt-BR).

## 4.1. Tecnologias utilizadas

O ExtraHub foi desenvolvido em **Flutter 3.41 / Dart 3.11**, gerando a partir de
um único código-fonte os builds para **Web, Android e iOS**.

**Front-end (interface e estado)**
- **Flutter** (Material 3) — UI declarativa multiplataforma.
- **Riverpod 3** — gerenciamento de estado e injeção de dependências
  (`Provider`, `StreamProvider`, `FutureProvider`, `AsyncNotifier`).
- **go_router 17** — navegação declarativa com *redirects* guardando as rotas
  conforme o estado de autenticação e a extra ativa.
- **freezed** + **json_serializable** — modelos imutáveis e serialização
  de/para JSON do Firestore.
- **google_fonts**, **intl** e **flutter_localizations** — tipografia e
  formatação/localização em pt-BR.

**Back-end (BaaS — Firebase)**
- **Firebase Authentication** — cadastro/login por e-mail e senha, com
  verificação de e-mail e restrição ao domínio `@usp.br`.
- **Cloud Firestore** (região `southamerica-east1`) — banco de dados NoSQL em
  tempo real, com **regras de segurança declarativas** como camada de
  autorização.
- **Firebase Hosting** — hospedagem do build web (`extrahub-fcc35.web.app`).

**Qualidade**
- **flutter_lints** (lints estritos), **flutter_test**, **mocktail** e
  **fake_cloud_firestore** para os testes, e **@firebase/rules-unit-testing**
  para os testes das regras de segurança.

## 4.2. Estrutura do código

O projeto adota uma arquitetura **Clean "leve", organizada por *feature***. Cada
funcionalidade de negócio é uma pasta independente com três camadas:

```
lib/
├── main.dart                  # init do Firebase + intl pt-BR + ProviderScope
├── firebase_options.dart      # gerado pelo flutterfire
├── app/                       # configuração global
│   ├── app.dart               # MaterialApp.router
│   ├── router/                # go_router (rotas + redirects)
│   ├── shell/                 # layout-pai (sidebar/drawer + topbar)
│   └── theme/                 # design system (cores, tipografia, espaçamento)
├── core/                      # código reutilizado entre features
│   ├── extensions/            # validações (@usp.br, senha), datas pt-BR
│   ├── firestore/             # paths centralizados, conversores de Timestamp
│   └── widgets/               # componentes reutilizáveis (botão, avatar, ...)
└── features/                  # uma pasta por feature
    ├── auth/  extras/  members/  projects/
    ├── announcements/  calendar/  dashboard/  profile/  splash/
        ├── data/              # repositórios (acesso ao Firestore)
        ├── domain/            # modelos (freezed) e enums
        └── presentation/      # screens, widgets e providers (Riverpod)
```

Essa divisão mantém o código **modificável**: a UI não conhece o Firebase
diretamente (só os repositórios), o que facilita testar (trocando o Firestore
real por um *fake*) e evoluir cada feature isoladamente.

**Modelo de dados (Firestore):**
```
users/{uid}                          # perfil global (AppUser)
extras/{extraId}                     # organização (Extra)
  ├── members/{uid}                  # vínculo (Member: role, isOwner, status)
  ├── projects/{projectId}           # Project (status, progresso, equipe, líder)
  ├── announcements/{id}             # Announcement (avisos)
  └── events/{id}                    # AppEvent (eventos do calendário)
invites/{extraId__email}             # convites (id determinístico)
```

## 4.3. Integração com o banco de dados

O acesso ao Firestore é **encapsulado na camada `data/` (repositórios)**. Cada
repositório recebe a instância de `FirebaseFirestore` por injeção (Riverpod),
converte documentos em modelos imutáveis (`fromFirestore`) e — quando uma
operação envolve **mais de um documento** — usa **transações atômicas** para
garantir consistência.

Exemplo: ao cadastrar uma extra (HU-01), três escritas precisam acontecer juntas
— criar a extra, criar o vínculo do dono e atualizar o usuário. Tudo em uma
transação:

```dart
// lib/features/extras/data/extras_repository.dart
Future<String> createExtra({ ... }) async {
  final newExtraRef = _extras.doc();
  final extraId = newExtraRef.id;
  final memberRef = _firestore.doc(FirestorePaths.member(extraId, ownerUid));
  final userRef = _firestore.doc(FirestorePaths.user(ownerUid));

  await _firestore.runTransaction((tx) async {
    // 1) cria a extra
    tx.set(newExtraRef, { 'ownerId': ownerUid, 'memberCount': 1, ... });
    // 2) cria o membership do dono (admin + isOwner)
    tx.set(memberRef, { 'role': 'admin', 'isOwner': true, 'status': 'active', ... });
    // 3) vincula a extra ao usuário e marca como ativa
    tx.update(userRef, { 'extraIds': FieldValue.arrayUnion([extraId]),
                         'activeExtraId': extraId });
  });
  return extraId;
}
```

O mesmo padrão mantém contadores e relações sempre coerentes: ao criar/editar/
excluir um projeto, a transação atualiza `inProjectIds` de cada membro alocado e
o `projectCount` da extra; ao aceitar um convite, cria o membership, incrementa
`memberCount` e marca o convite como aceito.

**Autorização — regras de segurança.** Como não há servidor próprio, a
autorização vive nas **Firestore Security Rules** (`firestore.rules`): negam tudo
por padrão e só liberam operações para usuários autenticados, com e-mail `@usp.br`
verificado, respeitando o papel (membro/admin/dono) e o isolamento entre extras
(*multi-tenant*). Essas regras são versionadas no repositório e cobertas por
testes automatizados (ver Seção 5).

## 4.4. Links

- **Repositório:** https://github.com/FelipeFMaia/ExtraHub
- **Aplicação web (no ar):** https://extrahub-fcc35.web.app
- **Protótipo:** https://felipefmaia.github.io/ExtraHub/extrahub_prototipo.html
- **Vídeo demo (web, Android e iOS):** _[inserir link]_
</content>
