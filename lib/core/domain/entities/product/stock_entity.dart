import 'package:equatable/equatable.dart';

class StockEntity extends Equatable {
  final int EnterpriseCode;
  final String Enterprise;
  final String StockName;
  final double StockQuantity;
  const StockEntity({
    required this.EnterpriseCode,
    required this.Enterprise,
    required this.StockName,
    required this.StockQuantity,
  });
  @override
  List<Object?> get props => [
    EnterpriseCode,
    Enterprise,
    StockName,
    StockQuantity,
  ];
}
