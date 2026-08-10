import 'package:celta_inventario/features/synchronizer/data/models/details/details.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class EcCouponSynchronizerErrorDetailModel extends EcCouponSynchronizerModel
    implements EcCouponSynchronizerErrorDetailEntity {
  const EcCouponSynchronizerErrorDetailModel({
    required super.code,
    required super.enterprisePersonalizedCode,
    required super.creationDate,
    required super.deliveryDate,
    required super.couponNumber,
    required super.ecfNumber,
    required super.cashRegisterNumber,
    required super.details,
  });

  @override
  List<int> get selectableCodes => [code];

  factory EcCouponSynchronizerErrorDetailModel.fromJson(Map json) {
    final base = EcCouponSynchronizerModel.fromJson(json);
    return EcCouponSynchronizerErrorDetailModel(
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

  factory EcCouponSynchronizerErrorDetailModel.fromEntity(
    EcCouponSynchronizerErrorDetailEntity entity,
  ) => EcCouponSynchronizerErrorDetailModel(
    code: entity.code,
    enterprisePersonalizedCode: entity.enterprisePersonalizedCode,
    creationDate: entity.creationDate,
    deliveryDate: entity.deliveryDate,
    couponNumber: entity.couponNumber,
    ecfNumber: entity.ecfNumber,
    cashRegisterNumber: entity.cashRegisterNumber,
    details: entity.details,
  );

  EcCouponSynchronizerErrorDetailEntity toEntity() =>
      EcCouponSynchronizerErrorDetailEntity(
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
