import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';

class BSFTributarySituationModel extends BSFTributarySituationEntity {
  const BSFTributarySituationModel({
    required super.code,
    required super.codeCSOSN,
    required super.description,
    required super.fiscalBenefitCodeStatesRequired,
    required super.tributation,
    required super.originType,
    required super.isSubstitution,
    required super.isImported,
  });

  factory BSFTributarySituationModel.fromJson(Map<String, dynamic> json) =>
      BSFTributarySituationModel(
        code: json['Code'],
        codeCSOSN: json['CodeCSOSN'],
        description: json['Description'],
        fiscalBenefitCodeStatesRequired: json['FiscalBenefitCodeStatesRequired'],
        tributation: json['Tributation'],
        originType: json['OriginType'],
        isSubstitution: json['IsSubstitution'],
        isImported: json['IsImported'],
      );

  Map<String, dynamic> toJson() => {
        'Code': code,
        'CodeCSOSN': codeCSOSN,
        'Description': description,
        'FiscalBenefitCodeStatesRequired': fiscalBenefitCodeStatesRequired,
        'Tributation': tributation,
        'OriginType': originType,
        'IsSubstitution': isSubstitution,
        'IsImported': isImported,
      };

  factory BSFTributarySituationModel.fromEntity(
          BSFTributarySituationEntity entity) =>
      BSFTributarySituationModel(
        code: entity.code,
        codeCSOSN: entity.codeCSOSN,
        description: entity.description,
        fiscalBenefitCodeStatesRequired: entity.fiscalBenefitCodeStatesRequired,
        tributation: entity.tributation,
        originType: entity.originType,
        isSubstitution: entity.isSubstitution,
        isImported: entity.isImported,
      );

  BSFTributarySituationEntity toEntity() => BSFTributarySituationEntity(
        code: code,
        codeCSOSN: codeCSOSN,
        description: description,
        fiscalBenefitCodeStatesRequired: fiscalBenefitCodeStatesRequired,
        tributation: tributation,
        originType: originType,
        isSubstitution: isSubstitution,
        isImported: isImported,
      );
}
