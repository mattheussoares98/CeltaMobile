import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class BSFTreasuryMovementSynchronizerErrorDetailModel
    extends BSFTreasuryMovementSynchronizerErrorDetailEntity {
  const BSFTreasuryMovementSynchronizerErrorDetailModel({
    required super.enterprisePersonalizedCode,
    required super.saleDate,
    required super.couponNumber,
    required super.ecfNumber,
  });

  factory BSFTreasuryMovementSynchronizerErrorDetailModel.fromJson(Map json) =>
      BSFTreasuryMovementSynchronizerErrorDetailModel(
        enterprisePersonalizedCode:
            json['EnterprisePersonalizedCode'] as String,
        saleDate: DateTime.parse(json['SaleDate'] as String),
        couponNumber: json['CouponNumber'] as String,
        ecfNumber: json['EcfNumber'] as String,
      );

  Map toJson() => {
    'EnterprisePersonalizedCode': enterprisePersonalizedCode,
    'SaleDate': saleDate.toIso8601String(),
    'CouponNumber': couponNumber,
    'EcfNumber': ecfNumber,
  };

  factory BSFTreasuryMovementSynchronizerErrorDetailModel.fromEntity(
    BSFTreasuryMovementSynchronizerErrorDetailEntity entity,
  ) => BSFTreasuryMovementSynchronizerErrorDetailModel(
    enterprisePersonalizedCode: entity.enterprisePersonalizedCode,
    saleDate: entity.saleDate,
    couponNumber: entity.couponNumber,
    ecfNumber: entity.ecfNumber,
  );

  BSFTreasuryMovementSynchronizerErrorDetailEntity toEntity() =>
      BSFTreasuryMovementSynchronizerErrorDetailEntity(
        enterprisePersonalizedCode: enterprisePersonalizedCode,
        saleDate: saleDate,
        couponNumber: couponNumber,
        ecfNumber: ecfNumber,
      );
}
