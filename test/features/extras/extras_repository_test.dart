import 'package:extrahub/features/extras/data/extras_repository.dart';
import 'package:extrahub/features/extras/domain/extra_category.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeFirebaseFirestore db;
  late ExtrasRepository repo;

  setUp(() {
    db = FakeFirebaseFirestore();
    repo = ExtrasRepository(db);
  });

  test('createExtra cria extra + membership do dono + atualiza user (HU-01)',
      () async {
    await db.doc('users/u1').set({
      'uid': 'u1',
      'email': 'ana@usp.br',
      'displayName': 'Ana',
      'extraIds': <String>[],
    });

    final extraId = await repo.createExtra(
      ownerUid: 'u1',
      ownerEmail: 'ana@usp.br',
      ownerDisplayName: 'Ana',
      name: 'Minha Extra',
      description: 'desc',
      category: ExtraCategory.juniorEnterprise,
    );

    final extra = (await db.doc('extras/$extraId').get()).data()!;
    expect(extra['ownerId'], 'u1');
    expect(extra['memberCount'], 1);
    expect(extra['projectCount'], 0);
    expect(extra['category'], 'junior_enterprise');

    final member = (await db.doc('extras/$extraId/members/u1').get()).data()!;
    expect(member['isOwner'], true);
    expect(member['role'], 'admin');
    expect(member['status'], 'active');

    final user = (await db.doc('users/u1').get()).data()!;
    expect(user['extraIds'], contains(extraId));
    expect(user['activeExtraId'], extraId);
  });

  test('createExtra falha se o doc do user não existe', () async {
    await expectLater(
      repo.createExtra(
        ownerUid: 'ghost',
        ownerEmail: 'g@usp.br',
        ownerDisplayName: 'Ghost',
        name: 'X',
        category: ExtraCategory.other,
      ),
      throwsA(isA<StateError>()),
    );
  });
}
