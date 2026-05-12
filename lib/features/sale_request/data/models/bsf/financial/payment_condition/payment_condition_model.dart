import '../../../../../../../core/domain/entities/entities.dart';

class PaymentConditionModel extends PaymentConditionEntity {
  const PaymentConditionModel({
    required super.isShielded,
    required super.composition,
    required super.symbolType,
    required super.fillType,
    required super.portionCount,
  });

  factory PaymentConditionModel.fromJson(Map<String, dynamic> json) =>
      PaymentConditionModel(
        isShielded: json['IsShielded'] ?? false,
        composition: json['Composition'],
        symbolType: PaymentConditionSymbolType.fromValue(json['SymbolType']),
        fillType: PaymentConditionFillType.fromValue(json['FillType']),
        portionCount: json['PortionCount'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
    'IsShielded': isShielded,
    'Composition': composition,
    'SymbolType': symbolType.value,
    'FillType': fillType.value,
    'PortionCount': portionCount,
  };

  factory PaymentConditionModel.fromEntity(PaymentConditionEntity entity) =>
      PaymentConditionModel(
        isShielded: entity.isShielded,
        composition: entity.composition,
        symbolType: entity.symbolType,
        fillType: entity.fillType,
        portionCount: entity.portionCount,
      );

  PaymentConditionEntity toEntity() => PaymentConditionEntity(
    isShielded: isShielded,
    composition: composition,
    symbolType: symbolType,
    fillType: fillType,
    portionCount: portionCount,
  );
}
