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
    // createdAt é incluído porque as regras de update de users/extras fazem
    // unchanged('createdAt') — e a rule lança erro se o campo não existir.
    await setDoc(doc(db, 'users/owner'), { uid: 'owner', email: 'owner@usp.br', displayName: 'Owner', createdAt: serverTimestamp() });
    await setDoc(doc(db, 'users/alice'), { uid: 'alice', email: 'alice@usp.br', displayName: 'Alice', createdAt: serverTimestamp() });
    await setDoc(doc(db, `extras/${EXTRA}`), {
      id: EXTRA, name: 'Extra A', ownerId: 'owner', memberCount: 2, projectCount: 0,
      createdAt: serverTimestamp(),
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
// ✅ HU-02 — signup cria users/{uid} (corrigido: 6.2)
// ════════════════════════════════════════════════════════════════════════
describe('✅ HU-02 — signup cria o próprio perfil (corrigido 6.2)', () => {
  it('signup com e-mail @usp.br NÃO verificado cria o próprio perfil', async () => {
    const db = selfUnverified();
    await assertSucceeds(
      setDoc(doc(db, 'users/alice'), { uid: 'alice', email: 'alice@usp.br', displayName: 'Alice' }),
    );
  });

  it('com e-mail verificado também cria o próprio perfil', async () => {
    const db = selfVerified();
    await assertSucceeds(
      setDoc(doc(db, 'users/alice'), { uid: 'alice', email: 'alice@usp.br', displayName: 'Alice' }),
    );
  });

  it('NÃO pode criar o perfil de OUTRO uid', async () => {
    const db = selfUnverified(); // alice
    await assertFails(
      setDoc(doc(db, 'users/bob'), { uid: 'bob', email: 'bob@usp.br', displayName: 'Bob' }),
    );
  });

  it('NÃO pode escrever em outras coleções antes de verificar (ex.: criar extra)', async () => {
    const db = selfUnverified();
    await assertFails(
      setDoc(doc(db, 'extras/nova'), { id: 'nova', name: 'X', ownerId: 'alice' }),
    );
  });
});

// ════════════════════════════════════════════════════════════════════════
// ✅ HU-01 — criar extra + membro do dono na MESMA transação (corrigido: 6.1)
// ════════════════════════════════════════════════════════════════════════
describe('✅ HU-01 — criar extra (corrigido 6.1, getAfter)', () => {
  async function seedAliceUser() {
    await testEnv.withSecurityRulesDisabled(async (ctx) => {
      await setDoc(doc(ctx.firestore(), 'users/alice'), {
        uid: 'alice', email: 'alice@usp.br', displayName: 'Alice',
        extraIds: [], createdAt: serverTimestamp(),
      });
    });
  }

  it('PERMITE o batch que cria extra + membership do dono + atualiza o user', async () => {
    await seedAliceUser();
    const db = selfVerified();
    const batch = writeBatch(db);
    batch.set(doc(db, 'extras/nova'), { id: 'nova', name: 'Nova', ownerId: 'alice', memberCount: 1, projectCount: 0, createdAt: serverTimestamp() });
    batch.set(doc(db, 'extras/nova/members/alice'), {
      uid: 'alice', email: 'alice@usp.br', displayName: 'Alice',
      role: 'admin', isOwner: true, status: 'active',
    });
    batch.update(doc(db, 'users/alice'), { extraIds: ['nova'], activeExtraId: 'nova', updatedAt: serverTimestamp() });
    await assertSucceeds(batch.commit());
  });

  it('NEGA se a extra criada no batch tiver ownerId diferente do criador', async () => {
    await seedAliceUser();
    const db = selfVerified();
    const batch = writeBatch(db);
    batch.set(doc(db, 'extras/nova'), { id: 'nova', name: 'Nova', ownerId: 'outro', memberCount: 1, projectCount: 0, createdAt: serverTimestamp() });
    batch.set(doc(db, 'extras/nova/members/alice'), {
      uid: 'alice', email: 'alice@usp.br', displayName: 'Alice',
      role: 'admin', isOwner: true, status: 'active',
    });
    await assertFails(batch.commit());
  });

  it('NEGA criar membership isOwner=true numa extra de OUTRO dono', async () => {
    // bob não é admin da extraA (dono = owner) e tenta se autopromover a dono.
    await seedBase();
    const db = outsiderVerified();
    await assertFails(
      setDoc(doc(db, `extras/${EXTRA}/members/bob`), {
        uid: 'bob', email: 'bob@usp.br', displayName: 'Bob',
        role: 'admin', isOwner: true, status: 'active',
      }),
    );
  });
});

// ════════════════════════════════════════════════════════════════════════
// ✅ HU-03 — aceitar convite (corrigido: 6.3, id determinístico)
// ════════════════════════════════════════════════════════════════════════
describe('✅ HU-03 — aceitar convite (corrigido 6.3)', () => {
  const INV = `${EXTRA}__bob@usp.br`; // id determinístico

  async function seedInvite({ role = 'member', expired = false } = {}) {
    await seedBase();
    await testEnv.withSecurityRulesDisabled(async (ctx) => {
      const db = ctx.firestore();
      await setDoc(doc(db, 'users/bob'), {
        uid: 'bob', email: 'bob@usp.br', displayName: 'Bob',
        extraIds: [], createdAt: serverTimestamp(),
      });
      await setDoc(doc(db, `invites/${INV}`), {
        id: INV, email: 'bob@usp.br', extraId: EXTRA, extraName: 'Extra A',
        role, invitedBy: { uid: 'owner', displayName: 'Owner' }, status: 'pending',
        createdAt: serverTimestamp(),
        expiresAt: new Date(Date.now() + (expired ? -1 : 7 * 24 * 60 * 60 * 1000)),
      });
    });
  }

  it('PERMITE o batch completo do aceite (convite + membership + user + memberCount)', async () => {
    await seedInvite();
    const db = outsiderVerified(); // bob
    const batch = writeBatch(db);
    batch.update(doc(db, `invites/${INV}`), { status: 'accepted', respondedAt: serverTimestamp() });
    batch.set(doc(db, `extras/${EXTRA}/members/bob`), {
      uid: 'bob', email: 'bob@usp.br', displayName: 'Bob',
      role: 'member', isOwner: false, status: 'active',
    });
    batch.update(doc(db, 'users/bob'), { extraIds: [EXTRA], activeExtraId: EXTRA, updatedAt: serverTimestamp() });
    batch.update(doc(db, `extras/${EXTRA}`), { memberCount: increment(1), updatedAt: serverTimestamp() });
    await assertSucceeds(batch.commit());
  });

  it('PERMITE o convidado criar o próprio membership (papel batendo o convite)', async () => {
    await seedInvite();
    const db = outsiderVerified();
    await assertSucceeds(
      setDoc(doc(db, `extras/${EXTRA}/members/bob`), {
        uid: 'bob', email: 'bob@usp.br', displayName: 'Bob',
        role: 'member', isOwner: false, status: 'active',
      }),
    );
  });

  it('PERMITE incrementar memberCount em +1 ao aceitar', async () => {
    await seedInvite();
    const db = outsiderVerified();
    await assertSucceeds(updateDoc(doc(db, `extras/${EXTRA}`), { memberCount: increment(1) }));
  });

  it('NEGA criar membership SEM convite', async () => {
    await seedBase(); // sem convite para bob
    const db = outsiderVerified();
    await assertFails(
      setDoc(doc(db, `extras/${EXTRA}/members/bob`), {
        uid: 'bob', email: 'bob@usp.br', displayName: 'Bob',
        role: 'member', isOwner: false, status: 'active',
      }),
    );
  });

  it('NEGA criar membership com papel acima do convite (convite=member, tenta admin)', async () => {
    await seedInvite({ role: 'member' });
    const db = outsiderVerified();
    await assertFails(
      setDoc(doc(db, `extras/${EXTRA}/members/bob`), {
        uid: 'bob', email: 'bob@usp.br', displayName: 'Bob',
        role: 'admin', isOwner: false, status: 'active',
      }),
    );
  });

  it('NEGA aceitar convite EXPIRADO', async () => {
    await seedInvite({ expired: true });
    const db = outsiderVerified();
    await assertFails(
      setDoc(doc(db, `extras/${EXTRA}/members/bob`), {
        uid: 'bob', email: 'bob@usp.br', displayName: 'Bob',
        role: 'member', isOwner: false, status: 'active',
      }),
    );
  });

  it('NEGA incrementar memberCount em mais de +1 (anti-abuso)', async () => {
    await seedInvite();
    const db = outsiderVerified();
    await assertFails(updateDoc(doc(db, `extras/${EXTRA}`), { memberCount: increment(2) }));
  });

  it('NEGA usar o convite de outra pessoa (e-mail diferente)', async () => {
    await seedInvite(); // convite é para bob@usp.br
    const db = testEnv.authenticatedContext('eve', tok('eve@usp.br', true)).firestore();
    await assertFails(
      setDoc(doc(db, `extras/${EXTRA}/members/eve`), {
        uid: 'eve', email: 'eve@usp.br', displayName: 'Eve',
        role: 'member', isOwner: false, status: 'active',
      }),
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
