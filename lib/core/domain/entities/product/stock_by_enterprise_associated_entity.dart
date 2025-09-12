import 'package:equatable/equatable.dart';

class StockByEnterpriseAssociatedEntity extends Equatable {
  final String Enterprise;
  final double StockBalanceForSale;
  final String? StorageAreaAddress;
  const StockByEnterpriseAssociatedEntity({
    required this.Enterprise,
    required this.StockBalanceForSale,
    required this.StorageAreaAddress,
  });

  @override
  List<Object?> get props => [
    Enterprise,
    StockBalanceForSale,
    StorageAreaAddress,
  ];
}
