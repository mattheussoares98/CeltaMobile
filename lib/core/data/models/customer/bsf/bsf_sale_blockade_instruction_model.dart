import 'package:celta_inventario/core/domain/entities/entities.dart';

class BsfSaleBlockadeInstructionModel extends BsfSaleBlockadeInstructionEntity {
  const BsfSaleBlockadeInstructionModel({
    required super.code,
    required super.personalizedCode,
    required super.legacyCode,
    required super.description,
  });

  factory BsfSaleBlockadeInstructionModel.fromJson(Map json) =>
      BsfSaleBlockadeInstructionModel(
        code: json['Code'] as int?,
        personalizedCode: json['PersonalizedCode'] as String?,
        legacyCode: json['LegacyCode'] as String?,
        description: json['Description'] as String?,
      );

  Map<String, dynamic> toJson() => {
    'Code': code,
    'PersonalizedCode': personalizedCode,
    'LegacyCode': legacyCode,
    'Description': description,
  };

  factory BsfSaleBlockadeInstructionModel.fromEntity(
    BsfSaleBlockadeInstructionEntity entity,
  ) => BsfSaleBlockadeInstructionModel(
    code: entity.code,
    personalizedCode: entity.personalizedCode,
    legacyCode: entity.legacyCode,
    description: entity.description,
  );

  BsfSaleBlockadeInstructionEntity toEntity() =>
      BsfSaleBlockadeInstructionEntity(
        code: code,
        personalizedCode: personalizedCode,
        legacyCode: legacyCode,
        description: description,
      );
}
