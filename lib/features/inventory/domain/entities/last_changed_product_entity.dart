import 'package:equatable/equatable.dart';

class LastChangedProductEntity extends Equatable {
  final int codigoInternoProEmb;
  final double quantity;
  final bool isSubtract;
  const LastChangedProductEntity({
    required this.codigoInternoProEmb,
    required this.quantity,
    required this.isSubtract,
  });

  @override
  List<Object?> get props => [codigoInternoProEmb, quantity, isSubtract];
}
