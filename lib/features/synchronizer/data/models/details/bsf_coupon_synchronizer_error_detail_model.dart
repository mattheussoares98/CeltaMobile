import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

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
            json['enterprisePersonalizedCode'] as String,
        creationDate: DateTime.parse(json['creationDate'] as String),
        deliveryDate: DateTime.parse(json['deliveryDate'] as String),
        couponNumber: json['couponNumber'] as String,
        ecfNumber: json['ecfNumber'] as String,
        cashRegisterNumber: json['cashRegisterNumber'] as String,
        details: List<String>.from(json['details'] as List),
      );

  Map toJson() => {
    'enterprisePersonalizedCode': enterprisePersonalizedCode,
    'creationDate': creationDate.toIso8601String(),
    'deliveryDate': deliveryDate.toIso8601String(),
    'couponNumber': couponNumber,
    'ecfNumber': ecfNumber,
    'cashRegisterNumber': cashRegisterNumber,
    'details': details,
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
