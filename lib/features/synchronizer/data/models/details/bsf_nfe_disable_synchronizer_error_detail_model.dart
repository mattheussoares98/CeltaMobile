import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class BSFNFeDisableSynchronizerErrorDetailModel
    extends BSFNFeDisableSynchronizerErrorDetailEntity {
  const BSFNFeDisableSynchronizerErrorDetailModel({
    required super.enterprisePersonalizedCode,
    required super.issuanceDate,
    required super.number,
    required super.series,
  });

  factory BSFNFeDisableSynchronizerErrorDetailModel.fromJson(Map json) =>
      BSFNFeDisableSynchronizerErrorDetailModel(
        enterprisePersonalizedCode:
            json['enterprisePersonalizedCode'] as String,
        issuanceDate: DateTime.parse(json['issuanceDate'] as String),
        number: (json['number'] as num).toInt(),
        series: json['series'] as String,
      );

  Map toJson() => {
    'enterprisePersonalizedCode': enterprisePersonalizedCode,
    'issuanceDate': issuanceDate.toIso8601String(),
    'number': number,
    'series': series,
  };

  factory BSFNFeDisableSynchronizerErrorDetailModel.fromEntity(
    BSFNFeDisableSynchronizerErrorDetailEntity entity,
  ) => BSFNFeDisableSynchronizerErrorDetailModel(
    enterprisePersonalizedCode: entity.enterprisePersonalizedCode,
    issuanceDate: entity.issuanceDate,
    number: entity.number,
    series: entity.series,
  );

  BSFNFeDisableSynchronizerErrorDetailEntity toEntity() =>
      BSFNFeDisableSynchronizerErrorDetailEntity(
        enterprisePersonalizedCode: enterprisePersonalizedCode,
        issuanceDate: issuanceDate,
        number: number,
        series: series,
      );
}
