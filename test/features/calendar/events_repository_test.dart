import 'package:extrahub/features/calendar/data/events_repository.dart';
import 'package:extrahub/features/calendar/domain/app_event.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeFirebaseFirestore db;
  late EventsRepository repo;

  setUp(() {
    db = FakeFirebaseFirestore();
    repo = EventsRepository(db);
  });

  test('create grava evento com convocados e dia inteiro (HU-09)', () async {
    final id = await repo.create(
      extraId: 'E',
      title: 'Reunião',
      startDate: DateTime(2026, 6, 20, 19),
      allDay: false,
      location: 'Sala 5-104',
      relatedProjectId: 'p1',
      invitees: const [
        EventInvitee(uid: 'u1', displayName: 'U1'),
        EventInvitee(uid: 'u2', displayName: 'U2'),
      ],
      createdBy: 'owner',
    );

    final e = (await db.doc('extras/E/events/$id').get()).data()!;
    expect(e['title'], 'Reunião');
    expect(e['location'], 'Sala 5-104');
    expect(e['relatedProjectId'], 'p1');
    final invitees = e['invitees'] as List;
    expect(invitees.length, 2);
    expect((invitees.first as Map)['uid'], 'u1');
  });

  test('update substitui os convocados', () async {
    final id = await repo.create(
      extraId: 'E',
      title: 'T',
      startDate: DateTime(2026, 6, 20, 19),
      createdBy: 'owner',
      invitees: const [EventInvitee(uid: 'u1', displayName: 'U1')],
    );
    await repo.update(
      extraId: 'E',
      eventId: id,
      title: 'T2',
      startDate: DateTime(2026, 6, 21, 19),
      invitees: const [],
    );
    final e = (await db.doc('extras/E/events/$id').get()).data()!;
    expect(e['title'], 'T2');
    expect((e['invitees'] as List), isEmpty);
  });
}
