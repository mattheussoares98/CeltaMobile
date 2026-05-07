import 'package:equatable/equatable.dart';

class EcRequestTypeParametersEntity extends Equatable {
  final int userCode;
  final bool inclusiveSale;
  final bool inclusiveBuy;
  final bool inclusiveTransfer;

  const EcRequestTypeParametersEntity({
    required this.userCode,
    required this.inclusiveSale,
    required this.inclusiveBuy,
    required this.inclusiveTransfer,
  });

  @override
  List<Object?> get props => [
    userCode,
    inclusiveSale,
    inclusiveBuy,
    inclusiveTransfer,
  ];
}
