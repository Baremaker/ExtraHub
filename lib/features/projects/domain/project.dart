import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/firestore/timestamp_converter.dart';

part 'project.freezed.dart';
part 'project.g.dart';

@JsonEnum(alwaysCreate: true)
enum ProjectStatus {
  @JsonValue('planning')  planning,
  @JsonValue('active')    active,
  @JsonValue('on_hold')   onHold,
  @JsonValue('completed') completed,
  @JsonValue('archived')  archived;

  String get label => switch (this) {
        planning  => 'Planejamento',
        active    => 'Em andamento',
        onHold    => 'Pausado',
        completed => 'Concluído',
        archived  => 'Arquivado',
      };
}

/// Cor para badge do projeto. Mapeia para tokens do tema.
@JsonEnum(alwaysCreate: true)
enum ProjectColor {
  @JsonValue('green')  green,
  @JsonValue('blue')   blue,
  @JsonValue('amber')  amber,
  @JsonValue('purple') purple,
  @JsonValue('pink')   pink,
  @JsonValue('red')    red;
}

/// Resumo de um membro alocado em um projeto (denormalizado para card de equipe).
@freezed
abstract class ProjectMemberRef with _$ProjectMemberRef {
  const factory ProjectMemberRef({
    required String uid,
    required String displayName,
    @Default(null) String? photoURL,
  }) = _ProjectMemberRef;

  factory ProjectMemberRef.fromJson(Map<String, dynamic> json) =>
      _$ProjectMemberRefFromJson(json);
}

/// Link externo associado a um projeto (GitHub, Drive, Figma, etc).
@freezed
abstract class ProjectLink with _$ProjectLink {
  const factory ProjectLink({
    required String label,
    required String url,
  }) = _ProjectLink;

  factory ProjectLink.fromJson(Map<String, dynamic> json) =>
      _$ProjectLinkFromJson(json);
}

@freezed
abstract class Project with _$Project {
  const factory Project({
    required String id,
    required String name,
    @Default(null) String? description,
    @Default(ProjectStatus.planning) ProjectStatus status,
    @Default(null) String? category,
    @Default(ProjectColor.green) ProjectColor color,
    @NullableTimestampConverter() DateTime? startDate,
    @NullableTimestampConverter() DateTime? dueDate,
    @Default(0) int progress,
    required String ownerId,
    @Default(<ProjectMemberRef>[]) List<ProjectMemberRef> members,
    @Default(<ProjectLink>[]) List<ProjectLink> links,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
    required String createdBy,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  factory Project.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Project document ${doc.id} has no data');
    }
    return Project.fromJson({...data, 'id': doc.id});
  }
}
