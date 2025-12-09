import 'package:equatable/equatable.dart';

class ProductNotFoundEntity extends Equatable {
  final int? internalCode;
  final double quantity;
  final String ean;
  final String? observations;

  const ProductNotFoundEntity({
    required this.internalCode,
    required this.quantity,
    required this.ean,
    required this.observations,
  });

  @override
  List<Object?> get props => [internalCode, quantity, ean, observations];

  ProductNotFoundEntity annulValues({
    bool? annulInternalCode,
    bool? annulObservations,
  }) => ProductNotFoundEntity(
    internalCode: annulInternalCode == true ? null : internalCode,
    observations: annulObservations == true ? null : observations,
    quantity: quantity,
    ean: ean,
  );
}
