import 'package:extrahub/features/announcements/data/announcements_repository.dart';
import 'package:extrahub/features/announcements/domain/announcement.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeFirebaseFirestore db;
  late AnnouncementsRepository repo;

  setUp(() {
    db = FakeFirebaseFirestore();
    repo = AnnouncementsRepository(db);
  });

  const author = AnnouncementAuthor(uid: 'owner', displayName: 'Owner');

  test('create grava aviso com autor e pinned (HU-06)', () async {
    final id = await repo.create(
      extraId: 'E',
      title: 'Reunião geral',
      body: 'Sexta às 19h',
      pinned: true,
      author: author,
    );
    final a = (await db.doc('extras/E/announcements/$id').get()).data()!;
    expect(a['title'], 'Reunião geral');
    expect(a['pinned'], true);
    expect((a['author'] as Map)['uid'], 'owner');
  });

  test('togglePinned alterna o destaque', () async {
    final id = await repo.create(
      extraId: 'E',
      title: 'T',
      body: 'B',
      pinned: false,
      author: author,
    );
    await repo.togglePinned(
        extraId: 'E', announcementId: id, pinned: true);
    expect((await db.doc('extras/E/announcements/$id').get()).data()!['pinned'],
        true);
  });

  test('update altera título/corpo e mantém o autor', () async {
    final id = await repo.create(
      extraId: 'E',
      title: 'Antigo',
      body: 'B',
      pinned: false,
      author: author,
    );
    await repo.update(
      extraId: 'E',
      announcementId: id,
      title: 'Novo',
      body: 'B2',
      pinned: false,
    );
    final a = (await db.doc('extras/E/announcements/$id').get()).data()!;
    expect(a['title'], 'Novo');
    expect((a['author'] as Map)['uid'], 'owner');
  });
}
