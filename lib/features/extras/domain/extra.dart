import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/firestore/timestamp_converter.dart';
import 'extra_category.dart';

part 'extra.freezed.dart';
part 'extra.g.dart';

/// Uma "extra" — Empresa Júnior, Atlética, Grupo PET, time de competição, etc.
///
/// Cada extra é uma organização independente com seus próprios membros,
/// projetos, avisos e eventos (subcollections em Firestore).
@freezed
abstract class Extra with _$Extra {
  const factory Extra({
    required String id,
    required String name,
    @Default(null) String? description,
    required ExtraCategory category,
    @Default('USP - São Carlos') String university,
    required String ownerId,
    @Default(0) int memberCount,
    @Default(0) int projectCount,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _Extra;

  factory Extra.fromJson(Map<String, dynamic> json) => _$ExtraFromJson(json);

  factory Extra.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Extra document ${doc.id} has no data');
    }
    return Extra.fromJson({...data, 'id': doc.id});
  }
}
