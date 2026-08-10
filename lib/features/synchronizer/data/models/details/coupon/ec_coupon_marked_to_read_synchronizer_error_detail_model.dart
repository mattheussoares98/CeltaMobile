import 'package:celta_inventario/features/synchronizer/data/models/details/details.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class EcCouponMarkedToReadSynchronizerErrorDetailModel
    extends EcCouponSynchronizerModel
    implements EcCouponMarkedToReadSynchronizerErrorDetailEntity {
  const EcCouponMarkedToReadSynchronizerErrorDetailModel({
    required super.code,
    required super.enterprisePersonalizedCode,
    required super.creationDate,
    required super.deliveryDate,
    required super.couponNumber,
    required super.ecfNumber,
    required super.cashRegisterNumber,
    required super.details,
  });

  factory EcCouponMarkedToReadSynchronizerErrorDetailModel.fromJson(Map json) {
    final base = EcCouponSynchronizerModel.fromJson(json);
    return EcCouponMarkedToReadSynchronizerErrorDetailModel(
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

  factory EcCouponMarkedToReadSynchronizerErrorDetailModel.fromEntity(
    EcCouponMarkedToReadSynchronizerErrorDetailEntity entity,
  ) => EcCouponMarkedToReadSynchronizerErrorDetailModel(
    code: entity.code,
    enterprisePersonalizedCode: entity.enterprisePersonalizedCode,
    creationDate: entity.creationDate,
    deliveryDate: entity.deliveryDate,
    couponNumber: entity.couponNumber,
    ecfNumber: entity.ecfNumber,
    cashRegisterNumber: entity.cashRegisterNumber,
    details: entity.details,
  );

  EcCouponMarkedToReadSynchronizerErrorDetailEntity toEntity() =>
      EcCouponMarkedToReadSynchronizerErrorDetailEntity(
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
