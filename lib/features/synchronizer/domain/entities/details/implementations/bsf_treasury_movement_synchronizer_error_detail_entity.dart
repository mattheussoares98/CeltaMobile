import 'package:celta_inventario/features/synchronizer/domain/entities/details/details.dart';

class BSFTreasuryMovementSynchronizerErrorDetailEntity
    extends SynchronizerErrorDetailEntity {
  final String enterprisePersonalizedCode;
  final DateTime saleDate;
  final String couponNumber;
  final String ecfNumber;

  const BSFTreasuryMovementSynchronizerErrorDetailEntity({
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
