import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/events_repository.dart';
import '../../domain/app_event.dart';

final eventsRepositoryProvider = Provider<EventsRepository>(
  (ref) => EventsRepository(ref.watch(firestoreProvider)),
);

/// Stream de todos os eventos da extra ativa, ordenados por data crescente.
final eventsProvider = StreamProvider<List<AppEvent>>((ref) {
  final extraId =
      ref.watch(currentAppUserProvider).value?.activeExtraId;
  if (extraId == null) return Stream<List<AppEvent>>.value(const []);
  return ref.watch(eventsRepositoryProvider).watchAll(extraId);
});

/// Apenas os próximos eventos (a partir de hoje 00:00).
final upcomingEventsProvider = Provider<List<AppEvent>>((ref) {
  final all = ref.watch(eventsProvider).value ?? const <AppEvent>[];
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, now.day);
  return all.where((e) => !e.startDate.isBefore(start)).toList();
});
