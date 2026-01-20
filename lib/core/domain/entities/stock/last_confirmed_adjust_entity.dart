import 'package:equatable/equatable.dart';

class LastConfirmedAdjustEntity extends Equatable {
  final int productPackingCode;
  final double quantity;
  final bool isSubtract;

  const LastConfirmedAdjustEntity({
    required this.productPackingCode,
    required this.quantity,
    required this.isSubtract,
  });

  @override
  List<Object?> get props => [productPackingCode, quantity, isSubtract];
}
