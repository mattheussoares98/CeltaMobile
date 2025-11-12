import 'package:equatable/equatable.dart';

import 'customer.dart';

class CustomerCovenantEntity extends Equatable {
  final CovenantInfoEntity? covenant;
  final String? Matriculate;
  final double? LimitOfPurchase;

  const CustomerCovenantEntity({
    required this.covenant,
    required this.Matriculate,
    required this.LimitOfPurchase,
  });

  @override
  List<Object?> get props => [covenant, Matriculate, LimitOfPurchase];

  factory CustomerCovenantEntity.empty() => const CustomerCovenantEntity(
    covenant: null,
    Matriculate: null,
    LimitOfPurchase: null,
  );
}
