import 'package:equatable/equatable.dart';

import '../entities.dart';

class LastConfirmedAdjustEntity extends Equatable {
  final int productPackingCode;
  final double quantity;
  final OperationType operationType;

  const LastConfirmedAdjustEntity({
    required this.productPackingCode,
    required this.quantity,
    required this.operationType,
  });

  @override
  List<Object?> get props => [productPackingCode, quantity, operationType];
}
