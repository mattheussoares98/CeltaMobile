import 'package:celta_inventario/features/synchronizer/domain/entities/details/details.dart';

class EcCouponMarkedToReadSynchronizerErrorDetailEntity
    extends EcCouponSynchronizerEntity {
  const EcCouponMarkedToReadSynchronizerErrorDetailEntity({
    required super.code,
    required super.enterprisePersonalizedCode,
    required super.creationDate,
    required super.deliveryDate,
    required super.couponNumber,
    required super.ecfNumber,
    required super.cashRegisterNumber,
    required super.details,
  });
}
