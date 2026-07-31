import 'package:celta_inventario/features/synchronizer/data/models/details/details.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class BSFCouponSynchronizerErrorDetailModel extends BSFCouponSynchronizerModel
    implements BSFCouponSynchronizerErrorDetailEntity {
  const BSFCouponSynchronizerErrorDetailModel({
    required super.code,
    required super.enterprisePersonalizedCode,
    required super.creationDate,
    required super.deliveryDate,
    required super.couponNumber,
    required super.ecfNumber,
    required super.cashRegisterNumber,
    required super.details,
  });

  factory BSFCouponSynchronizerErrorDetailModel.fromJson(Map json) {
    final base = BSFCouponSynchronizerModel.fromJson(json);
    return BSFCouponSynchronizerErrorDetailModel(
      code: base.code,
      enterprisePersonalizedCode: base.enterprisePersonalizedCode,
      creationDate: base.creationDate,
      deliveryDate: base.deliveryDate,
      couponNumber: base.couponNumber,
      ecfNumber: base.ecfNumber,
      cashRegisterNumber: base.cashRegisterNumber,
      details: base.details,
    );
  }

  factory BSFCouponSynchronizerErrorDetailModel.fromEntity(
    BSFCouponSynchronizerErrorDetailEntity entity,
  ) => BSFCouponSynchronizerErrorDetailModel(
    code: entity.code,
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
        code: code,
        enterprisePersonalizedCode: enterprisePersonalizedCode,
        creationDate: creationDate,
        deliveryDate: deliveryDate,
        couponNumber: couponNumber,
        ecfNumber: ecfNumber,
        cashRegisterNumber: cashRegisterNumber,
        details: details,
      );
}
