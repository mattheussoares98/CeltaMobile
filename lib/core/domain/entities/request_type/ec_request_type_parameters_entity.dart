import 'package:equatable/equatable.dart';

class EcRequestTypeParametersEntity extends Equatable {
  final int enterpriseCode;
  final bool inclusiveSale;
  final bool inclusiveBuy;
  final bool inclusiveTransfer;

  const EcRequestTypeParametersEntity({
    required this.enterpriseCode,
    required this.inclusiveSale,
    required this.inclusiveBuy,
    required this.inclusiveTransfer,
  });

  @override
  List<Object?> get props => [
    enterpriseCode,
    inclusiveSale,
    inclusiveBuy,
    inclusiveTransfer,
  ];
}
