import 'package:equatable/equatable.dart';

class OfferParams extends Equatable {
  final double price;
  final DateTime? effectuationDateOffer;
  final DateTime? endDateOffer;

  const OfferParams({
    required this.price,
    required this.effectuationDateOffer,
    required this.endDateOffer,
  });

  @override
  List<Object?> get props => [price, effectuationDateOffer, endDateOffer];
}

class RetailParams extends Equatable {
  final double price;
  final DateTime? effectuationDatePrice;

  const RetailParams({
    required this.price,
    required this.effectuationDatePrice,
  });

  @override
  List<Object?> get props => [price, effectuationDatePrice];
}
