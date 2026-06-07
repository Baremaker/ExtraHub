import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extrahub/features/extras/data/invites_repository.dart';
import 'package:extrahub/features/members/domain/member.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeFirebaseFirestore db;
  late InvitesRepository repo;

  setUp(() {
    db = FakeFirebaseFirestore();
    repo = InvitesRepository(db);
  });

  Future<String> seedInvite({String role = 'member'}) => repo.createInvite(
        extraId: 'E',
        extraName: 'Extra A',
        email: 'Bob@USP.br',
        role: role == 'admin' ? MemberRole.admin : MemberRole.member,
        inviterUid: 'owner',
        inviterDisplayName: 'Owner',
      );

  test('createInvite usa id determinístico extraId__email (normalizado)',
      () async {
    final id = await seedInvite();
    expect(id, 'E__bob@usp.br');
    final doc = (await db.doc('invites/E__bob@usp.br').get()).data()!;
    expect(doc['status'], 'pending');
    expect(doc['role'], 'member');
    expect(doc['email'], 'bob@usp.br');
  });

  test('createInvite bloqueia duplicata pendente', () async {
    await seedInvite();
    await expectLater(seedInvite(), throwsA(isA<StateError>()));
  });

  test('acceptInvite cria membership, +1 memberCount, atualiza user e aceita',
      () async {
    await db.doc('extras/E').set({'id': 'E', 'memberCount': 1});
    await db.doc('users/bob').set({
      'uid': 'bob',
      'email': 'bob@usp.br',
      'displayName': 'Bob',
      'extraIds': <String>[],
    });
    final id = await seedInvite(role: 'admin');

    await repo.acceptInvite(
      inviteId: id,
      uid: 'bob',
      userEmail: 'bob@usp.br',
      userDisplayName: 'Bob',
    );

    final m = (await db.doc('extras/E/members/bob').get()).data()!;
    expect(m['role'], 'admin');
    expect(m['isOwner'], false);
    expect(m['status'], 'active');

    final e = (await db.doc('extras/E').get()).data()!;
    expect(e['memberCount'], 2);

    final u = (await db.doc('users/bob').get()).data()!;
    expect(u['extraIds'], contains('E'));
    expect(u['activeExtraId'], 'E');

    final inv = (await db.doc('invites/$id').get()).data()!;
    expect(inv['status'], 'accepted');
  });

  test('acceptInvite recusa convite expirado', () async {
    await db.doc('extras/E').set({'id': 'E', 'memberCount': 1});
    await db.doc('users/bob').set({
      'uid': 'bob',
      'email': 'bob@usp.br',
      'displayName': 'Bob',
      'extraIds': <String>[],
    });
    final id = await seedInvite();
    await db.doc('invites/$id').update({
      'expiresAt': Timestamp.fromDate(
        DateTime.now().subtract(const Duration(days: 1)),
      ),
    });

    await expectLater(
      repo.acceptInvite(
        inviteId: id,
        uid: 'bob',
        userEmail: 'bob@usp.br',
        userDisplayName: 'Bob',
      ),
      throwsA(isA<StateError>()),
    );
  });

  test('declineInvite marca como recusado', () async {
    final id = await seedInvite();
    await repo.declineInvite(id);
    final inv = (await db.doc('invites/$id').get()).data()!;
    expect(inv['status'], 'declined');
  });
}
