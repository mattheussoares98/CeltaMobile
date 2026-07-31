import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class BSFFiscalNoteSynchronizerErrorDetailModel
    extends BSFFiscalNoteSynchronizerErrorDetailEntity {
  const BSFFiscalNoteSynchronizerErrorDetailModel({
    required super.enterprisePersonalizedCode,
    required super.issuanceDate,
    required super.number,
    required super.series,
  });

  factory BSFFiscalNoteSynchronizerErrorDetailModel.fromJson(Map json) =>
      BSFFiscalNoteSynchronizerErrorDetailModel(
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

  factory BSFFiscalNoteSynchronizerErrorDetailModel.fromEntity(
    BSFFiscalNoteSynchronizerErrorDetailEntity entity,
  ) => BSFFiscalNoteSynchronizerErrorDetailModel(
    enterprisePersonalizedCode: entity.enterprisePersonalizedCode,
    issuanceDate: entity.issuanceDate,
    number: entity.number,
    series: entity.series,
  );

  BSFFiscalNoteSynchronizerErrorDetailEntity toEntity() =>
      BSFFiscalNoteSynchronizerErrorDetailEntity(
        enterprisePersonalizedCode: enterprisePersonalizedCode,
        issuanceDate: issuanceDate,
        number: number,
        series: series,
      );
}
