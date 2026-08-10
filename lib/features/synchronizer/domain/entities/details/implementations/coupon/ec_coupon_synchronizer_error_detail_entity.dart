import 'package:celta_inventario/features/synchronizer/domain/entities/details/details.dart';

class EcCouponSynchronizerErrorDetailEntity extends EcCouponSynchronizerEntity
    implements EcSelectableSynchronizerErrorDetailEntity {
  const EcCouponSynchronizerErrorDetailEntity({
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
}
