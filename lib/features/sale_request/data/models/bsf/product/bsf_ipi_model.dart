import '../../../../domain/entities/entities.dart';

class BSFIpiModel extends BSFIpiEntity {
  const BSFIpiModel({
    required super.aliquot,
    required super.type,
    required super.tributarySituation,
    required super.fiscalObservation,
    required super.isValid,
  });

  factory BSFIpiModel.fromJson(Map<String, dynamic> json) => BSFIpiModel(
    aliquot: (json['Aliquot'] as num?)?.toDouble(),
    type: json['Type'] as int?,
    tributarySituation: json['TributarySituation'],
    fiscalObservation: json['FiscalObservation'],
    isValid: json['IsValid'],
  );

  Map<String, dynamic> toJson() => {
    'Aliquot': aliquot,
    'Type': type,
    'TributarySituation': tributarySituation,
    'FiscalObservation': fiscalObservation,
    'IsValid': isValid,
  };

  factory BSFIpiModel.fromEntity(BSFIpiEntity entity) => BSFIpiModel(
    aliquot: entity.aliquot,
    type: entity.type,
    tributarySituation: entity.tributarySituation,
    fiscalObservation: entity.fiscalObservation,
    isValid: entity.isValid,
  );

  BSFIpiEntity toEntity() => BSFIpiEntity(
    aliquot: aliquot,
    type: type,
    tributarySituation: tributarySituation,
    fiscalObservation: fiscalObservation,
    isValid: isValid,
  );
}
