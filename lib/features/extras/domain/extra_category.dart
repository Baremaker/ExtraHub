import 'package:json_annotation/json_annotation.dart';

/// Categoria de uma extracurricular.
///
/// Usamos enum (e não string livre) para permitir filtros consistentes na
/// listagem e para deixar a UI prever rótulos. Se faltar uma categoria,
/// adicione-a aqui.
@JsonEnum(alwaysCreate: true)
enum ExtraCategory {
  @JsonValue('junior_enterprise') juniorEnterprise,
  @JsonValue('athletic')          athletic,
  @JsonValue('pet_group')         petGroup,
  @JsonValue('competition_team')  competitionTeam,
  @JsonValue('league')            league,
  @JsonValue('study_group')       studyGroup,
  @JsonValue('other')             other;

  /// Rótulo legível em português para exibir na UI.
  String get label => switch (this) {
        juniorEnterprise => 'Empresa Júnior',
        athletic         => 'Atlética',
        petGroup         => 'Grupo PET',
        competitionTeam  => 'Time de Competição',
        league           => 'Liga Acadêmica',
        studyGroup       => 'Grupo de Estudos',
        other            => 'Outro',
      };
}
