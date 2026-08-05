import 'Package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class BSFSaleRequestMarkedSynchronizerErrorDetailModel
    extends BSFSaleRequestMarkedSynchronizerErrorDetailEntity {
  const BSFSaleRequestMarkedSynchronizerErrorDetailModel({
    required super.code,
    required super.personalizedCode,
    required super.customer,
    required super.totalLiquid,
  });

  factory BSFSaleRequestMarkedSynchronizerErrorDetailModel.fromJson(Map json) =>
      BSFSaleRequestMarkedSynchronizerErrorDetailModel(
        code: json['Code'] as int,
        personalizedCode: json['PersonalizedCode'] as String,
        customer: json['Customer'] as String,
        totalLiquid: (json['TotalLiquid'] as num).toDouble(),
      );

  Map toJson() => {
    'Code': code,
    'PersonalizedCode': personalizedCode,
    'Customer': customer,
    'TotalLiquid': totalLiquid,
  };

  factory BSFSaleRequestMarkedSynchronizerErrorDetailModel.fromEntity(
    BSFSaleRequestMarkedSynchronizerErrorDetailEntity entity,
  ) => BSFSaleRequestMarkedSynchronizerErrorDetailModel(
    code: entity.code,
    personalizedCode: entity.personalizedCode,
    customer: entity.customer,
    totalLiquid: entity.totalLiquid,
  );

  BSFSaleRequestMarkedSynchronizerErrorDetailEntity toEntity() =>
      BSFSaleRequestMarkedSynchronizerErrorDetailEntity(
        code: code,
        personalizedCode: personalizedCode,
        customer: customer,
        totalLiquid: totalLiquid,
      );
}
