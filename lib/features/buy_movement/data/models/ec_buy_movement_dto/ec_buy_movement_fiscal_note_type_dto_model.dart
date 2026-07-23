import 'package:celta_inventario/features/buy_movement/domain/entities/entities.dart';

class EcBuyMovementFiscalNoteTypeDtoModel
    extends EcBuyMovementFiscalNoteTypeDtoEntity {
  const EcBuyMovementFiscalNoteTypeDtoModel({
    required super.code,
    required super.personalizedCode,
    required super.name,
  });

  factory EcBuyMovementFiscalNoteTypeDtoModel.fromJson(Map json) =>
      EcBuyMovementFiscalNoteTypeDtoModel(
        code: json['code'] as int?,
        personalizedCode: json['personalizedCode']?.toString(),
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
    'code': code,
    'personalizedCode': personalizedCode,
    'name': name,
  };

  factory EcBuyMovementFiscalNoteTypeDtoModel.fromEntity(
    EcBuyMovementFiscalNoteTypeDtoEntity entity,
  ) => EcBuyMovementFiscalNoteTypeDtoModel(
    code: entity.code,
    personalizedCode: entity.personalizedCode,
    name: entity.name,
  );

  EcBuyMovementFiscalNoteTypeDtoEntity toEntity() =>
      EcBuyMovementFiscalNoteTypeDtoEntity(
        code: code,
        personalizedCode: personalizedCode,
        name: name,
      );
}
