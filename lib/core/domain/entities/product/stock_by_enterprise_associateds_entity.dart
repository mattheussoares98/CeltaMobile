import 'package:equatable/equatable.dart';

class StockByEnterpriseAssociatedsEntity extends Equatable {
  final String Enterprise;
  final double StockBalanceForSale;
  final String? StorageAreaAddress;
  const StockByEnterpriseAssociatedsEntity({
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
