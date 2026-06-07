// =====================================================================
// ExtraHub — Testes unitários das Firestore Security Rules
// ---------------------------------------------------------------------
// "Firebase Rules unit testing": cada teste assume um usuário (autenticado
// ou não, @usp.br ou não, membro ou não) e verifica se uma operação é
// PERMITIDA (assertSucceeds) ou NEGADA (assertFails) pelas regras de
// `firestore.rules`.
//
// Rodam contra o emulador do Firestore — NUNCA contra produção.
// Como rodar (a partir da raiz do repo):
//   JAVA_HOME=/snap/android-studio/209/jbr PATH=$JAVA_HOME/bin:$PATH \
//   firebase emulators:exec --only firestore --project demo-extrahub \
//     "cd test_rules && npm test"
//
// Estrutura:
//   * Seções "✅ funcionando" documentam o que as regras já protegem certo.
//   * Seções "🔴 BLOQUEIO" reproduzem os fluxos centrais que a auditoria
//     apontou como negados indevidamente (signup, criar extra, aceitar
//     convite). Hoje esses testes passam justamente porque a operação É
//     negada — ou seja, eles CONFIRMAM o bug. Após corrigir as regras,
//     eles serão reescritos para exigir assertSucceeds.
// =====================================================================

import { readFileSync } from 'node:fs';
import { before, after, beforeEach, describe, it } from 'mocha';
import {
  initializeTestEnvironment,
  assertFails,
  assertSucceeds,
} from '@firebase/rules-unit-testing';
import {
  doc,
  getDoc,
  setDoc,
  updateDoc,
  writeBatch,
  increment,
  serverTimestamp,
  setLogLevel,
} from 'firebase/firestore';

let testEnv;

// IDs de apoio
const EXTRA = 'extraA';

// ─── Contextos de autenticação (request.auth.token) ────────────────────
const tok = (email, verified) => ({ email, email_verified: verified });

function ownerCtx() {
  // dono/admin da extraA, @usp.br, verificado
  return testEnv.authenticatedContext('owner', tok('owner@usp.br', true)).firestore();
}
function memberCtx() {
  // membro ativo comum da extraA
  return testEnv.authenticatedContext('charlie', tok('charlie@usp.br', true)).firestore();
}
function outsiderVerified() {
  // @usp.br verificado, mas NÃO é membro da extraA
  return testEnv.authenticatedContext('bob', tok('bob@usp.br', true)).firestore();
}
function selfUnverified() {
  // @usp.br, porém com email AINDA não verificado (estado pós-signup)
  return testEnv.authenticatedContext('alice', tok('alice@usp.br', false)).firestore();
}
function selfVerified() {
  return testEnv.authenticatedContext('alice', tok('alice@usp.br', true)).firestore();
}
function nonUspCtx() {
  return testEnv.authenticatedContext('mallory', tok('mallory@gmail.com', true)).firestore();
}
function anonCtx() {
  return testEnv.unauthenticatedContext().firestore();
}

// Semeia dados base (extraA com dono + 1 membro) ignorando as regras.
async function seedBase() {
  await testEnv.withSecurityRulesDisabled(async (ctx) => {
    const db = ctx.firestore();
    await setDoc(doc(db, 'users/owner'), { uid: 'owner', email: 'owner@usp.br', displayName: 'Owner' });
    await setDoc(doc(db, 'users/alice'), { uid: 'alice', email: 'alice@usp.br', displayName: 'Alice' });
    await setDoc(doc(db, `extras/${EXTRA}`), {
      id: EXTRA, name: 'Extra A', ownerId: 'owner', memberCount: 2, projectCount: 0,
    });
    await setDoc(doc(db, `extras/${EXTRA}/members/owner`), {
      uid: 'owner', email: 'owner@usp.br', displayName: 'Owner',
      role: 'admin', isOwner: true, status: 'active',
    });
    await setDoc(doc(db, `extras/${EXTRA}/members/charlie`), {
      uid: 'charlie', email: 'charlie@usp.br', displayName: 'Charlie',
      role: 'member', isOwner: false, status: 'active',
    });
  });
}

before(async () => {
  setLogLevel('error'); // silencia warnings ruidosos do SDK
  testEnv = await initializeTestEnvironment({
    projectId: 'demo-extrahub',
    firestore: {
      rules: readFileSync('../firestore.rules', 'utf8'),
      host: '127.0.0.1',
      port: 8080,
    },
  });
});

after(async () => {
  if (testEnv) await testEnv.cleanup();
});

beforeEach(async () => {
  await testEnv.clearFirestore();
});

// ════════════════════════════════════════════════════════════════════════
// ✅ O que as regras JÁ protegem corretamente
// ════════════════════════════════════════════════════════════════════════
describe('✅ Autenticação e e-mail @usp.br', () => {
  it('nega leitura de perfil para usuário NÃO autenticado', async () => {
    await seedBase();
    await assertFails(getDoc(doc(anonCtx(), 'users/owner')));
  });

  it('nega leitura para e-mail NÃO @usp.br (mesmo autenticado)', async () => {
    await seedBase();
    await assertFails(getDoc(doc(nonUspCtx(), 'users/owner')));
  });

  it('nega criação de extra com e-mail não verificado', async () => {
    await seedBase();
    const db = selfUnverified();
    await assertFails(
      setDoc(doc(db, 'extras/nova'), { id: 'nova', name: 'X', ownerId: 'alice' }),
    );
  });
});

describe('✅ Isolamento multi-tenant', () => {
  it('membro ativo LÊ a própria extra', async () => {
    await seedBase();
    await assertSucceeds(getDoc(doc(memberCtx(), `extras/${EXTRA}`)));
  });

  it('usuário @usp.br que NÃO é membro NÃO lê a extra', async () => {
    await seedBase();
    await assertFails(getDoc(doc(outsiderVerified(), `extras/${EXTRA}`)));
  });

  it('não-membro NÃO lê projetos/avisos/eventos da extra', async () => {
    await seedBase();
    const db = outsiderVerified();
    await assertFails(getDoc(doc(db, `extras/${EXTRA}/projects/p1`)));
    await assertFails(getDoc(doc(db, `extras/${EXTRA}/announcements/a1`)));
    await assertFails(getDoc(doc(db, `extras/${EXTRA}/events/e1`)));
  });
});

// ════════════════════════════════════════════════════════════════════════
// 🔴 BLOQUEIO 6.2 — doc de usuário no signup (email ainda não verificado)
// ════════════════════════════════════════════════════════════════════════
describe('🔴 BLOQUEIO 6.2 — criar users/{uid} no signup', () => {
  it('CONFIRMA bug: signup (email não verificado) NÃO consegue criar o próprio perfil', async () => {
    const db = selfUnverified();
    await assertFails(
      setDoc(doc(db, 'users/alice'), { uid: 'alice', email: 'alice@usp.br', displayName: 'Alice' }),
    );
  });

  it('controle: com email verificado, criar o próprio perfil é permitido', async () => {
    const db = selfVerified();
    await assertSucceeds(
      setDoc(doc(db, 'users/alice'), { uid: 'alice', email: 'alice@usp.br', displayName: 'Alice' }),
    );
  });
});

// ════════════════════════════════════════════════════════════════════════
// 🔴 BLOQUEIO 6.1 — criar extra + membro do dono na MESMA transação
// ════════════════════════════════════════════════════════════════════════
describe('🔴 BLOQUEIO 6.1 — criar extra (membro do dono na mesma transação)', () => {
  it('CONFIRMA bug: batch que cria extra + membership do dono é NEGADO', async () => {
    // alice precisa ter doc de usuário (createExtra lê/atualiza users/alice)
    await testEnv.withSecurityRulesDisabled(async (ctx) => {
      await setDoc(doc(ctx.firestore(), 'users/alice'),
        { uid: 'alice', email: 'alice@usp.br', displayName: 'Alice', extraIds: [] });
    });
    const db = selfVerified();
    const batch = writeBatch(db);
    batch.set(doc(db, 'extras/nova'), { id: 'nova', name: 'Nova', ownerId: 'alice', memberCount: 1, projectCount: 0 });
    batch.set(doc(db, 'extras/nova/members/alice'), {
      uid: 'alice', email: 'alice@usp.br', displayName: 'Alice',
      role: 'admin', isOwner: true, status: 'active',
    });
    batch.update(doc(db, 'users/alice'), { extraIds: ['nova'], activeExtraId: 'nova' });
    await assertFails(batch.commit());
  });

  it('prova da causa: se a extra JÁ existe, criar o membership do dono é permitido', async () => {
    // Isola que o problema é o get() não enxergar a extra criada no mesmo batch.
    await testEnv.withSecurityRulesDisabled(async (ctx) => {
      const db = ctx.firestore();
      await setDoc(doc(db, 'users/alice'), { uid: 'alice', email: 'alice@usp.br', displayName: 'Alice' });
      await setDoc(doc(db, 'extras/nova'), { id: 'nova', name: 'Nova', ownerId: 'alice' });
    });
    const db = selfVerified();
    await assertSucceeds(
      setDoc(doc(db, 'extras/nova/members/alice'), {
        uid: 'alice', email: 'alice@usp.br', displayName: 'Alice',
        role: 'admin', isOwner: true, status: 'active',
      }),
    );
  });
});

// ════════════════════════════════════════════════════════════════════════
// 🔴 BLOQUEIO 6.3 — aceitar convite (convidado cria o próprio membership)
// ════════════════════════════════════════════════════════════════════════
describe('🔴 BLOQUEIO 6.3 — aceitar convite', () => {
  async function seedInvite() {
    await seedBase();
    await testEnv.withSecurityRulesDisabled(async (ctx) => {
      const db = ctx.firestore();
      await setDoc(doc(db, 'users/bob'), { uid: 'bob', email: 'bob@usp.br', displayName: 'Bob', extraIds: [] });
      await setDoc(doc(db, 'invites/inv1'), {
        id: 'inv1', email: 'bob@usp.br', extraId: EXTRA, extraName: 'Extra A',
        role: 'member', invitedBy: { uid: 'owner', displayName: 'Owner' }, status: 'pending',
        // createdAt/expiresAt são obrigatórios: a regra de update faz unchanged('createdAt')
        // e lança erro se o campo não existir (o cliente real sempre grava ambos).
        createdAt: serverTimestamp(),
        expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
      });
    });
  }

  it('CONFIRMA bug: convidado NÃO consegue criar o próprio doc de membro', async () => {
    await seedInvite();
    const db = outsiderVerified(); // bob@usp.br, ainda não-membro
    await assertFails(
      setDoc(doc(db, `extras/${EXTRA}/members/bob`), {
        uid: 'bob', email: 'bob@usp.br', displayName: 'Bob',
        role: 'member', isOwner: false, status: 'active',
      }),
    );
  });

  it('CONFIRMA bug: convidado NÃO consegue incrementar memberCount da extra', async () => {
    await seedInvite();
    const db = outsiderVerified();
    await assertFails(
      updateDoc(doc(db, `extras/${EXTRA}`), { memberCount: increment(1) }),
    );
  });

  it('controle: marcar o convite como aceito (sozinho) é permitido ao destinatário', async () => {
    await seedInvite();
    const db = outsiderVerified();
    await assertSucceeds(
      updateDoc(doc(db, 'invites/inv1'), { status: 'accepted', respondedAt: serverTimestamp() }),
    );
  });
});

// ════════════════════════════════════════════════════════════════════════
// 🟡 ACHADO 6.4 — leitura global de perfis (PII entre tenants)
// ════════════════════════════════════════════════════════════════════════
describe('🟡 ACHADO 6.4 — leitura global de perfis', () => {
  it('DOCUMENTA vazamento: usuário sem extra em comum LÊ o perfil de qualquer um', async () => {
    await seedBase(); // owner e alice não compartilham extra com bob
    const db = outsiderVerified();
    // Hoje isto SUCEDE — é a regra permissiva demais (allow read: if isAuthed()).
    await assertSucceeds(getDoc(doc(db, 'users/owner')));
  });
});
