import 'Package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class EcTreasuryMovementSynchronizerErrorDetailModel
    extends EcTreasuryMovementSynchronizerErrorDetailEntity {
  const EcTreasuryMovementSynchronizerErrorDetailModel({
    required super.enterprisePersonalizedCode,
    required super.saleDate,
    required super.couponNumber,
    required super.ecfNumber,
  });

  factory EcTreasuryMovementSynchronizerErrorDetailModel.fromJson(Map json) =>
      EcTreasuryMovementSynchronizerErrorDetailModel(
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

  factory EcTreasuryMovementSynchronizerErrorDetailModel.fromEntity(
    EcTreasuryMovementSynchronizerErrorDetailEntity entity,
  ) => EcTreasuryMovementSynchronizerErrorDetailModel(
    enterprisePersonalizedCode: entity.enterprisePersonalizedCode,
    saleDate: entity.saleDate,
    couponNumber: entity.couponNumber,
    ecfNumber: entity.ecfNumber,
  );

  EcTreasuryMovementSynchronizerErrorDetailEntity toEntity() =>
      EcTreasuryMovementSynchronizerErrorDetailEntity(
        enterprisePersonalizedCode: enterprisePersonalizedCode,
        saleDate: saleDate,
        couponNumber: couponNumber,
        ecfNumber: ecfNumber,
      );
}
