import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/announcements_repository.dart';
import '../../domain/announcement.dart';

final announcementsRepositoryProvider =
    Provider<AnnouncementsRepository>(
  (ref) => AnnouncementsRepository(ref.watch(firestoreProvider)),
);

/// Stream de todos os avisos da extra ativa, já ordenados.
final announcementsProvider =
    StreamProvider<List<Announcement>>((ref) {
  final extraId =
      ref.watch(currentAppUserProvider).value?.activeExtraId;
  if (extraId == null) return Stream<List<Announcement>>.value(const []);
  return ref.watch(announcementsRepositoryProvider).watchAll(extraId);
});
