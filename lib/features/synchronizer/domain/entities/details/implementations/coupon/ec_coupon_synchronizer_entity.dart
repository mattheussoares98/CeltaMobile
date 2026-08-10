import 'package:celta_inventario/features/synchronizer/domain/entities/details/details.dart';

class EcCouponSynchronizerEntity extends EcSynchronizerErrorDetailEntity {
  final int code;
  final String enterprisePersonalizedCode;
  final DateTime creationDate;
  final DateTime deliveryDate;
  final String couponNumber;
  final String ecfNumber;
  final String cashRegisterNumber;
  final List<String> details;

  const EcCouponSynchronizerEntity({
    required this.code,
    required this.enterprisePersonalizedCode,
    required this.creationDate,
    required this.deliveryDate,
    required this.couponNumber,
    required this.ecfNumber,
    required this.cashRegisterNumber,
    required this.details,
  });

  @override
  List<Object?> get props => [
    code,
    enterprisePersonalizedCode,
    creationDate,
    deliveryDate,
    couponNumber,
    ecfNumber,
    cashRegisterNumber,
    details,
  ];
}
