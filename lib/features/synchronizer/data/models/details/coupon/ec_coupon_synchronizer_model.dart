import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class EcCouponSynchronizerModel extends EcCouponSynchronizerEntity {
  const EcCouponSynchronizerModel({
    required super.code,
    required super.enterprisePersonalizedCode,
    required super.creationDate,
    required super.deliveryDate,
    required super.couponNumber,
    required super.ecfNumber,
    required super.cashRegisterNumber,
    required super.details,
  });

  factory EcCouponSynchronizerModel.fromJson(Map json) =>
      EcCouponSynchronizerModel(
        code: json['Code'] as int,
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
    'Code': code,
    'EnterprisePersonalizedCode': enterprisePersonalizedCode,
    'CreationDate': creationDate.toIso8601String(),
    'DeliveryDate': deliveryDate.toIso8601String(),
    'CouponNumber': couponNumber,
    'EcfNumber': ecfNumber,
    'CashRegisterNumber': cashRegisterNumber,
    'Details': details,
  };
}
