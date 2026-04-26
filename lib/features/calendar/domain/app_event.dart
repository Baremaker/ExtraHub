import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/firestore/timestamp_converter.dart';

part 'app_event.freezed.dart';
part 'app_event.g.dart';

/// Evento no calendário da extra.
///
/// Não chamamos de `Event` para evitar conflito com o `dart:html` Event
/// quando rodando no web.
@freezed
abstract class AppEvent with _$AppEvent {
  const factory AppEvent({
    required String id,
    required String title,
    @Default(null) String? description,
    @TimestampConverter() required DateTime startDate,
    @NullableTimestampConverter() DateTime? endDate,
    @Default(false) bool allDay,
    @Default(null) String? location,
    @Default(null) String? relatedProjectId,
    @TimestampConverter() required DateTime createdAt,
    required String createdBy,
  }) = _AppEvent;

  factory AppEvent.fromJson(Map<String, dynamic> json) =>
      _$AppEventFromJson(json);

  factory AppEvent.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Event document ${doc.id} has no data');
    }
    return AppEvent.fromJson({...data, 'id': doc.id});
  }
}
