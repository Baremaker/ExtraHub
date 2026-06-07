#!/usr/bin/env bash
# =====================================================================
# Roda os testes unitários das Firestore Security Rules contra o
# Firebase Emulator Suite. Nunca toca em produção.
#
# Uso (de qualquer lugar):  ./test_rules/run.sh
# =====================================================================
set -euo pipefail

# Vai para a raiz do repo (este script vive em test_rules/).
cd "$(dirname "$0")/.."

# O emulador do Firestore precisa de um JDK. Se 'java' não estiver no PATH,
# tenta o JDK que vem com o Android Studio (mesmo usado pelo build Android).
if ! command -v java >/dev/null 2>&1; then
  for jbr in /snap/android-studio/*/jbr "$HOME"/android-studio/jbr /opt/android-studio/jbr; do
    if [ -x "$jbr/bin/java" ]; then
      export JAVA_HOME="$jbr"
      export PATH="$JAVA_HOME/bin:$PATH"
      break
    fi
  done
fi
command -v java >/dev/null 2>&1 || {
  echo "ERRO: Java não encontrado. Instale um JDK (ex.: default-jre) ou aponte JAVA_HOME." >&2
  exit 1
}

# Instala as dependências de teste na primeira vez.
[ -d test_rules/node_modules ] || npm install --prefix test_rules

firebase emulators:exec --only firestore --project demo-extrahub "cd test_rules && npm test"
