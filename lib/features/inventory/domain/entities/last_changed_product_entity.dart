import 'package:equatable/equatable.dart';

class LastChangedProductEntity extends Equatable {
  final int codigoInternoProEmb;
  final double quantity;
  const LastChangedProductEntity({
    required this.codigoInternoProEmb,
    required this.quantity,
  });

  @override
  List<Object?> get props => [this.codigoInternoProEmb, this.quantity];
}
