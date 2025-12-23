import 'package:equatable/equatable.dart';

class LastConfirmedAdjustEntity extends Equatable {
  final int productPackingCode;
  final double quantity;

  const LastConfirmedAdjustEntity({
    required this.productPackingCode,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productPackingCode, quantity];
}
