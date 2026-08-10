import 'Package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class EcNFeDisableSynchronizerErrorDetailModel
    extends EcNFeDisableSynchronizerErrorDetailEntity {
  const EcNFeDisableSynchronizerErrorDetailModel({
    required super.enterprisePersonalizedCode,
    required super.issuanceDate,
    required super.number,
    required super.series,
  });

  factory EcNFeDisableSynchronizerErrorDetailModel.fromJson(Map json) =>
      EcNFeDisableSynchronizerErrorDetailModel(
        enterprisePersonalizedCode:
            json['EnterprisePersonalizedCode'] as String,
        issuanceDate: DateTime.parse(json['IssuanceDate'] as String),
        number: (json['Number'] as num).toInt(),
        series: json['Series'] as String,
      );

  Map toJson() => {
    'EnterprisePersonalizedCode': enterprisePersonalizedCode,
    'IssuanceDate': issuanceDate.toIso8601String(),
    'Number': number,
    'Series': series,
  };

  factory EcNFeDisableSynchronizerErrorDetailModel.fromEntity(
    EcNFeDisableSynchronizerErrorDetailEntity entity,
  ) => EcNFeDisableSynchronizerErrorDetailModel(
    enterprisePersonalizedCode: entity.enterprisePersonalizedCode,
    issuanceDate: entity.issuanceDate,
    number: entity.number,
    series: entity.series,
  );

  EcNFeDisableSynchronizerErrorDetailEntity toEntity() =>
      EcNFeDisableSynchronizerErrorDetailEntity(
        enterprisePersonalizedCode: enterprisePersonalizedCode,
        issuanceDate: issuanceDate,
        number: number,
        series: series,
      );
}
