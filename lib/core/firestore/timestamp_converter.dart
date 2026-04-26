import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

/// Converte `Timestamp` do Firestore para `DateTime` do Dart e vice-versa.
///
/// Use-o em campos não-nuláveis com `@TimestampConverter()`.
class TimestampConverter implements JsonConverter<DateTime, Object?> {
  const TimestampConverter();

  @override
  DateTime fromJson(Object? json) {
    if (json is Timestamp) return json.toDate();
    if (json is DateTime) return json;
    if (json is int) return DateTime.fromMillisecondsSinceEpoch(json);
    if (json is String) return DateTime.parse(json);
    throw ArgumentError('Invalid timestamp value: $json');
  }

  @override
  Object toJson(DateTime date) => Timestamp.fromDate(date);
}

/// Versão nullable de [TimestampConverter].
class NullableTimestampConverter
    implements JsonConverter<DateTime?, Object?> {
  const NullableTimestampConverter();

  @override
  DateTime? fromJson(Object? json) {
    if (json == null) return null;
    return const TimestampConverter().fromJson(json);
  }

  @override
  Object? toJson(DateTime? date) {
    if (date == null) return null;
    return const TimestampConverter().toJson(date);
  }
}

/// Marca um campo `DateTime` para ser preenchido pelo servidor com
/// `FieldValue.serverTimestamp()` no momento de gravar, e lido como
/// `DateTime` ao recuperar.
///
/// Use no toJson manualmente quando criar documentos novos:
/// ```dart
/// 'createdAt': FieldValue.serverTimestamp(),
/// ```
typedef ServerTimestamp = DateTime;
