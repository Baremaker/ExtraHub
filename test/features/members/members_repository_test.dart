import 'package:extrahub/features/members/data/members_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeFirebaseFirestore db;
  late MembersRepository repo;

  setUp(() {
    db = FakeFirebaseFirestore();
    repo = MembersRepository(db);
  });

  Future<void> seed({String status = 'active'}) async {
    await db.doc('extras/E').set({'id': 'E', 'memberCount': 2});
    await db.doc('users/u1').set({
      'uid': 'u1',
      'extraIds': ['E'],
    });
    await db.doc('extras/E/members/u1').set({
      'uid': 'u1',
      'displayName': 'U1',
      'role': 'member',
      'isOwner': false,
      'status': status,
    });
  }

  test('markAsInactive marca ex-membro e -1 memberCount (HU-08)', () async {
    await seed();
    await repo.markAsInactive('E', 'u1');

    final m = (await db.doc('extras/E/members/u1').get()).data()!;
    expect(m['status'], 'inactive');
    expect(m['leftAt'], isNotNull);
    expect((await db.doc('extras/E').get()).data()!['memberCount'], 1);
  });

  test('reactivate volta a ativo e +1 memberCount', () async {
    await seed(status: 'inactive');
    await repo.reactivate('E', 'u1');

    final m = (await db.doc('extras/E/members/u1').get()).data()!;
    expect(m['status'], 'active');
    expect(m['leftAt'], isNull);
    expect((await db.doc('extras/E').get()).data()!['memberCount'], 3);
  });

  test('promoteToAdmin / demoteToMember alteram o papel', () async {
    await seed();
    await repo.promoteToAdmin('E', 'u1');
    expect((await db.doc('extras/E/members/u1').get()).data()!['role'], 'admin');
    await repo.demoteToMember('E', 'u1');
    expect(
        (await db.doc('extras/E/members/u1').get()).data()!['role'], 'member');
  });

  test('removeMember apaga doc, tira extraId do user e -1 memberCount',
      () async {
    await seed();
    await repo.removeMember('E', 'u1');

    expect((await db.doc('extras/E/members/u1').get()).exists, isFalse);
    expect(
        (await db.doc('users/u1').get()).data()!['extraIds'], isNot(contains('E')));
    expect((await db.doc('extras/E').get()).data()!['memberCount'], 1);
  });
}
