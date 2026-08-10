import 'Package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class EcSaleRequestMarkedSynchronizerErrorDetailModel
    extends EcSaleRequestMarkedSynchronizerErrorDetailEntity {
  const EcSaleRequestMarkedSynchronizerErrorDetailModel({
    required super.code,
    required super.personalizedCode,
    required super.customer,
    required super.totalLiquid,
    required super.customerCode,
    required super.requestTypeCode,
    required super.enterpriseCode,
  });

  factory EcSaleRequestMarkedSynchronizerErrorDetailModel.fromJson(Map json) =>
      EcSaleRequestMarkedSynchronizerErrorDetailModel(
        customerCode: json['CustomerCode'] as int,
        requestTypeCode: json['RequestTypeCode'] as int,
        enterpriseCode: json['EnterpriseCode'] as int,
        code: json['Code'] as int,
        personalizedCode: json['PersonalizedCode'] as String,
        customer: json['Customer'] as String,
        totalLiquid: (json['TotalLiquid'] as num).toDouble(),
      );

  Map toJson() => {
    'Code': code,
    'CustomerCode': customerCode,
    'RequestTypeCode': requestTypeCode,
    'EnterpriseCode': enterpriseCode,
    'PersonalizedCode': personalizedCode,
    'Customer': customer,
    'TotalLiquid': totalLiquid,
  };

  factory EcSaleRequestMarkedSynchronizerErrorDetailModel.fromEntity(
    EcSaleRequestMarkedSynchronizerErrorDetailEntity entity,
  ) => EcSaleRequestMarkedSynchronizerErrorDetailModel(
    code: entity.code,
    personalizedCode: entity.personalizedCode,
    customer: entity.customer,
    totalLiquid: entity.totalLiquid,
    customerCode: entity.customerCode,
    requestTypeCode: entity.requestTypeCode,
    enterpriseCode: entity.enterpriseCode,
  );

  EcSaleRequestMarkedSynchronizerErrorDetailEntity toEntity() =>
      EcSaleRequestMarkedSynchronizerErrorDetailEntity(
        code: code,
        personalizedCode: personalizedCode,
        customer: customer,
        totalLiquid: totalLiquid,
        customerCode: customerCode,
        requestTypeCode: requestTypeCode,
        enterpriseCode: enterpriseCode,
      );
}
