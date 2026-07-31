import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class BSFSaleRequestMarkedSynchronizerErrorDetailModel
    extends BSFSaleRequestMarkedSynchronizerErrorDetailEntity {
  const BSFSaleRequestMarkedSynchronizerErrorDetailModel({
    required super.personalizedCode,
    required super.customer,
    required super.totalLiquid,
  });

  factory BSFSaleRequestMarkedSynchronizerErrorDetailModel.fromJson(Map json) =>
      BSFSaleRequestMarkedSynchronizerErrorDetailModel(
        personalizedCode: json['personalizedCode'] as String,
        customer: json['customer'] as String,
        totalLiquid: (json['totalLiquid'] as num).toDouble(),
      );

  Map toJson() => {
    'personalizedCode': personalizedCode,
    'customer': customer,
    'totalLiquid': totalLiquid,
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
