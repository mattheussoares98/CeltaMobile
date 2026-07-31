import 'Package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class BSFCouponSynchronizerErrorDetailModel
    extends BSFCouponSynchronizerErrorDetailEntity {
  const BSFCouponSynchronizerErrorDetailModel({
    required super.enterprisePersonalizedCode,
    required super.creationDate,
    required super.deliveryDate,
    required super.couponNumber,
    required super.ecfNumber,
    required super.cashRegisterNumber,
    required super.details,
  });

  factory BSFCouponSynchronizerErrorDetailModel.fromJson(Map json) =>
      BSFCouponSynchronizerErrorDetailModel(
        enterprisePersonalizedCode:
            json['EnterprisePersonalizedCode'] as String,
        creationDate: DateTime.parse(json['CreationDate'] as String),
        deliveryDate: DateTime.parse(json['DeliveryDate'] as String),
        couponNumber: json['CouponNumber'] as String,
        ecfNumber: json['EcfNumber'] as String,
        cashRegisterNumber: json['CashRegisterNumber'] as String,
        details: List<String>.from(json['Details'] as List),
      );

  Map toJson() => {
    'EnterprisePersonalizedCode': enterprisePersonalizedCode,
    'CreationDate': creationDate.toIso8601String(),
    'DeliveryDate': deliveryDate.toIso8601String(),
    'CouponNumber': couponNumber,
    'EcfNumber': ecfNumber,
    'CashRegisterNumber': cashRegisterNumber,
    'Details': details,
  };

  factory BSFCouponSynchronizerErrorDetailModel.fromEntity(
    BSFCouponSynchronizerErrorDetailEntity entity,
  ) => BSFCouponSynchronizerErrorDetailModel(
    enterprisePersonalizedCode: entity.enterprisePersonalizedCode,
    creationDate: entity.creationDate,
    deliveryDate: entity.deliveryDate,
    couponNumber: entity.couponNumber,
    ecfNumber: entity.ecfNumber,
    cashRegisterNumber: entity.cashRegisterNumber,
    details: entity.details,
  );

  BSFCouponSynchronizerErrorDetailEntity toEntity() =>
      BSFCouponSynchronizerErrorDetailEntity(
        enterprisePersonalizedCode: enterprisePersonalizedCode,
        creationDate: creationDate,
        deliveryDate: deliveryDate,
        couponNumber: couponNumber,
        ecfNumber: ecfNumber,
        cashRegisterNumber: cashRegisterNumber,
        details: details,
      );
}
