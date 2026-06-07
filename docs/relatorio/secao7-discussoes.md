# Seção 7 — Discussões

> Pronta para o relatório da Entrega 2 (pt-BR). Complementa as discussões da
> Entrega 1 com o que foi vivido na fase de desenvolvimento e testes.

## 7.1. Dificuldades e desafios encontrados

**Regras de segurança que bloqueavam fluxos centrais.** O desafio técnico mais
relevante desta etapa foi descobrir — ao escrever testes — que as regras do
Cloud Firestore, embora bem-intencionadas, **bloqueavam três fluxos essenciais**:
o cadastro de usuário (a regra exigia e-mail já verificado, mas o perfil é criado
no momento do *signup*), a criação de extra (a regra consultava, via `get()`, um
documento criado na **mesma transação** — que ainda não existe para a regra) e o
aceite de convite (o convidado precisava criar o próprio vínculo, o que só era
permitido a administradores). A correção exigiu entender particularidades do
Firestore: usar **`getAfter()`** para enxergar documentos criados na mesma
transação, separar a verificação de e-mail da criação do perfil, e dar ao convite
um **id determinístico** (`extraId__email`) para que a regra conseguisse
localizá-lo e autorizar o aceite.

**Testar as regras de segurança.** Validar regras exige o **Firebase Emulator
Suite**, que por sua vez depende de um JDK (Java) — um pré-requisito de ambiente
que precisou ser resolvido. Montar os casos de teste (com `@firebase/
rules-unit-testing`) também demandou cobrir tanto os fluxos permitidos quanto os
**acessos indevidos** (escalада de papel, reuso de convite alheio, acesso entre
extras), que são o real objetivo de um teste de segurança.

**Ausência de macOS para o iOS.** Por usar Flutter, o app já é multiplataforma,
mas **gerar o build iOS exige um Mac com Xcode**, indisponível para a equipe.
Web e Android foram compilados e validados; o iOS depende de acesso a um ambiente
Apple para a gravação do vídeo.

**Detalhes de testes automatizados.** Testar widgets que usam `google_fonts`
exigiu desabilitar o download de fontes em tempo de execução; e testar a lógica
de banco sem tocar produção foi possível com o `fake_cloud_firestore` (um
Firestore em memória que executa transações e `FieldValue`).

## 7.2. Aprendizados importantes

- **Testar a camada de autorização, não só o cliente.** Um app que "funciona" no
  emulador com regras abertas pode estar quebrado em produção. Escrever testes de
  regras revelou bugs que nenhum teste de UI pegaria, e virou a forma de
  documentar a segurança do sistema.
- **Consistência em banco NoSQL é responsabilidade da aplicação.** Sem *joins* e
  sem integridade referencial, manter contadores (`memberCount`, `projectCount`)
  e relações denormalizadas (`inProjectIds`) coerentes depende de **transações
  atômicas** bem desenhadas — um cuidado que se paga em confiabilidade.
- **Acessibilidade é barata quando feita cedo.** Corrigir contraste (WCAG AA),
  alvos de toque e rótulos foi rápido e mensurável com a ferramenta automatizada
  do Flutter; teria sido mais caro deixar para o fim.
- **Auditar antes de codar.** Mapear o estado real do projeto (o que estava
  pronto, o que faltava, onde estavam os bugs) antes de implementar evitou
  retrabalho e deu uma ordem de prioridades guiada pelo que mais pesa na entrega.
- **Separação por camadas compensou.** Como a UI não fala direto com o Firebase,
  foi possível testar os repositórios isoladamente e corrigir regras sem
  reescrever telas.
</content>
