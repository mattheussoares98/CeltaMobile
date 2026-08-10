import 'Package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class EcFiscalNoteSynchronizerErrorDetailModel
    extends EcFiscalNoteSynchronizerErrorDetailEntity {
  const EcFiscalNoteSynchronizerErrorDetailModel({
    required super.enterprisePersonalizedCode,
    required super.issuanceDate,
    required super.number,
    required super.series,
  });

  factory EcFiscalNoteSynchronizerErrorDetailModel.fromJson(Map json) =>
      EcFiscalNoteSynchronizerErrorDetailModel(
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

  factory EcFiscalNoteSynchronizerErrorDetailModel.fromEntity(
    EcFiscalNoteSynchronizerErrorDetailEntity entity,
  ) => EcFiscalNoteSynchronizerErrorDetailModel(
    enterprisePersonalizedCode: entity.enterprisePersonalizedCode,
    issuanceDate: entity.issuanceDate,
    number: entity.number,
    series: entity.series,
  );

  EcFiscalNoteSynchronizerErrorDetailEntity toEntity() =>
      EcFiscalNoteSynchronizerErrorDetailEntity(
        enterprisePersonalizedCode: enterprisePersonalizedCode,
        issuanceDate: issuanceDate,
        number: number,
        series: series,
      );
}
