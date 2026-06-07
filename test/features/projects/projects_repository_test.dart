import 'package:extrahub/features/projects/data/projects_repository.dart';
import 'package:extrahub/features/projects/domain/project.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeFirebaseFirestore db;
  late ProjectsRepository repo;

  setUp(() {
    db = FakeFirebaseFirestore();
    repo = ProjectsRepository(db);
  });

  Future<void> seedMember(String uid) => db.doc('extras/E/members/$uid').set({
        'uid': uid,
        'displayName': uid.toUpperCase(),
        'role': 'member',
        'isOwner': false,
        'status': 'active',
        'inProjectIds': <String>[],
      });

  test('createProject grava projeto, popula inProjectIds e +1 projectCount',
      () async {
    await db.doc('extras/E').set({'id': 'E', 'projectCount': 0});
    await seedMember('u1');

    final pid = await repo.createProject(
      extraId: 'E',
      name: 'Projeto X',
      status: ProjectStatus.active,
      color: ProjectColor.green,
      progress: 10,
      ownerId: 'u1',
      members: const [ProjectMemberRef(uid: 'u1', displayName: 'U1')],
      links: const [ProjectLink(label: 'GitHub', url: 'https://github.com/x')],
      createdBy: 'u1',
    );

    final p = (await db.doc('extras/E/projects/$pid').get()).data()!;
    expect(p['status'], 'active');
    expect((p['members'] as List).length, 1);
    expect((p['links'] as List).length, 1);

    final m = (await db.doc('extras/E/members/u1').get()).data()!;
    expect(m['inProjectIds'], contains(pid));

    final e = (await db.doc('extras/E').get()).data()!;
    expect(e['projectCount'], 1);
  });

  test('createProject falha se um membro alocado não existe', () async {
    await db.doc('extras/E').set({'id': 'E', 'projectCount': 0});
    await expectLater(
      repo.createProject(
        extraId: 'E',
        name: 'P',
        status: ProjectStatus.planning,
        color: ProjectColor.blue,
        progress: 0,
        ownerId: 'ghost',
        members: const [ProjectMemberRef(uid: 'ghost', displayName: 'Ghost')],
        links: const [],
        createdBy: 'ghost',
      ),
      throwsA(isA<StateError>()),
    );
  });

  test('updateProject sincroniza inProjectIds (adiciona novos, remove saídos)',
      () async {
    await db.doc('extras/E').set({'id': 'E', 'projectCount': 0});
    await seedMember('u1');
    await seedMember('u2');
    final pid = await repo.createProject(
      extraId: 'E',
      name: 'P',
      status: ProjectStatus.active,
      color: ProjectColor.green,
      progress: 0,
      ownerId: 'u1',
      members: const [ProjectMemberRef(uid: 'u1', displayName: 'U1')],
      links: const [],
      createdBy: 'u1',
    );

    // Troca a equipe: sai u1, entra u2.
    await repo.updateProject(
      extraId: 'E',
      projectId: pid,
      name: 'P',
      status: ProjectStatus.active,
      color: ProjectColor.green,
      progress: 50,
      ownerId: 'u2',
      members: const [ProjectMemberRef(uid: 'u2', displayName: 'U2')],
      links: const [],
    );

    final u1 = (await db.doc('extras/E/members/u1').get()).data()!;
    final u2 = (await db.doc('extras/E/members/u2').get()).data()!;
    expect(u1['inProjectIds'], isNot(contains(pid)));
    expect(u2['inProjectIds'], contains(pid));
    expect((await db.doc('extras/E/projects/$pid').get()).data()!['progress'],
        50);
  });

  test('deleteProject remove inProjectIds e -1 projectCount', () async {
    await db.doc('extras/E').set({'id': 'E', 'projectCount': 0});
    await seedMember('u1');
    final pid = await repo.createProject(
      extraId: 'E',
      name: 'P',
      status: ProjectStatus.active,
      color: ProjectColor.green,
      progress: 0,
      ownerId: 'u1',
      members: const [ProjectMemberRef(uid: 'u1', displayName: 'U1')],
      links: const [],
      createdBy: 'u1',
    );

    await repo.deleteProject(extraId: 'E', projectId: pid);

    expect((await db.doc('extras/E/projects/$pid').get()).exists, isFalse);
    final m = (await db.doc('extras/E/members/u1').get()).data()!;
    expect(m['inProjectIds'], isNot(contains(pid)));
    expect((await db.doc('extras/E').get()).data()!['projectCount'], 0);
  });
}
