# ExtraHub

Aplicativo multiplataforma (web + Android) para gestão de extracurriculares
universitárias da USP-São Carlos. Projeto desenvolvido para a disciplina
**SSC0961 — Desenvolvimento Web e Mobile** (2026).

## Stack

- **Flutter 3.41** + **Dart 3.11**
- **Firebase**: Authentication, Cloud Firestore, Storage
- **Riverpod 3** para gerenciamento de estado
- **go_router 17** para navegação declarativa
- **freezed** + **json_serializable** para models imutáveis

## Como rodar

```bash
# Web (Chrome)
flutter run -d chrome

# Android (com device USB conectado ou emulador rodando)
flutter run -d android

# Lista de devices disponíveis
flutter devices
```

## Estrutura de pastas

```
lib/
├── main.dart                  # entry point + init do Firebase
├── firebase_options.dart      # gerado pelo flutterfire — não editar
├── app/                       # configuração global da aplicação
│   ├── app.dart               # MaterialApp.router
│   ├── theme/                 # tokens de design (cores, tipografia, etc.)
│   └── router/                # configuração do go_router
├── core/                      # código reutilizado entre features
│   ├── widgets/               # componentes visuais reutilizáveis
│   ├── extensions/            # extensions sobre tipos do Dart/Flutter
│   └── utils/                 # helpers diversos
└── features/                  # uma pasta por feature de negócio
    ├── splash/                # tela de splash + redirect inicial
    ├── auth/                  # login, signup, autenticação
    ├── extras/                # cadastro/seleção da extra (organização)
    ├── members/               # gestão de membros
    ├── projects/              # gestão de projetos
    ├── announcements/         # mural de avisos
    ├── calendar/              # calendário/eventos
    ├── dashboard/             # tela inicial agregadora
    └── profile/               # perfil do usuário

Cada feature segue a divisão Clean leve:
  - data/         → repositories, datasources (Firestore, etc.)
  - domain/       → models e contratos
  - presentation/ → screens, widgets e providers (Riverpod)
```

## Convenções

- **Nomes de arquivo**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variáveis e funções**: `camelCase`
- **Imports relativos** dentro da mesma feature; **imports de package**
  para tudo que vier de fora
- **Const sempre que possível** — o linter avisa
- **Sem `print`** — usar `debugPrint` ou logger; o linter avisa

## Comandos úteis

```bash
# Análise estática
flutter analyze

# Rodar testes
flutter test

# Gerar código (freezed, riverpod_generator, json_serializable)
dart run build_runner build --delete-conflicting-outputs

# Modo watch (regenera ao salvar)
dart run build_runner watch --delete-conflicting-outputs
```

## Workflow de Git

Commits diretos em `main`, com convenção:

- `feat:` nova feature
- `fix:` correção de bug
- `chore:` manutenção, dependências, scripts
- `refactor:` refatoração sem mudança de comportamento
- `docs:` documentação
- `style:` formatação, sem mudança de código
- `test:` testes

## Equipe

Felipe Freitas Maia (e demais membros do grupo) — Engenharia de Computação,
ICMC-USP São Carlos.
