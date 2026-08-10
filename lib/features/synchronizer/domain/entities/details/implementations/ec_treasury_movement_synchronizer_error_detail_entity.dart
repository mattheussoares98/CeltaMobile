import 'package:celta_inventario/features/synchronizer/domain/entities/details/details.dart';

class EcTreasuryMovementSynchronizerErrorDetailEntity
    extends EcSynchronizerErrorDetailEntity {
  final String enterprisePersonalizedCode;
  final DateTime saleDate;
  final String couponNumber;
  final String ecfNumber;

  const EcTreasuryMovementSynchronizerErrorDetailEntity({
    required this.enterprisePersonalizedCode,
    required this.saleDate,
    required this.couponNumber,
    required this.ecfNumber,
  });

  @override
  List<Object?> get props => [
    enterprisePersonalizedCode,
    saleDate,
    couponNumber,
    ecfNumber,
  ];
}
