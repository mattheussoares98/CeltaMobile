import 'Package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class BSFSaleRequestMarkedSynchronizerErrorDetailModel
    extends BSFSaleRequestMarkedSynchronizerErrorDetailEntity {
  const BSFSaleRequestMarkedSynchronizerErrorDetailModel({
    required super.personalizedCode,
    required super.customer,
    required super.totalLiquid,
  });

  factory BSFSaleRequestMarkedSynchronizerErrorDetailModel.fromJson(Map json) =>
      BSFSaleRequestMarkedSynchronizerErrorDetailModel(
        personalizedCode: json['PersonalizedCode'] as String,
        customer: json['Customer'] as String,
        totalLiquid: (json['TotalLiquid'] as num).toDouble(),
      );

  Map toJson() => {
    'PersonalizedCode': personalizedCode,
    'Customer': customer,
    'TotalLiquid': totalLiquid,
  };

  factory BSFSaleRequestMarkedSynchronizerErrorDetailModel.fromEntity(
    BSFSaleRequestMarkedSynchronizerErrorDetailEntity entity,
  ) => BSFSaleRequestMarkedSynchronizerErrorDetailModel(
    personalizedCode: entity.personalizedCode,
    customer: entity.customer,
    totalLiquid: entity.totalLiquid,
  );

  BSFSaleRequestMarkedSynchronizerErrorDetailEntity toEntity() =>
      BSFSaleRequestMarkedSynchronizerErrorDetailEntity(
        personalizedCode: personalizedCode,
        customer: customer,
        totalLiquid: totalLiquid,
      );
}
