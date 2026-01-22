import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class StockByEnterpriseAssociatedModel extends Equatable {
  final String Enterprise;
  final double StockBalanceForSale;
  final List<String>? StorageAreaAddress;
  const StockByEnterpriseAssociatedModel({
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

  factory StockByEnterpriseAssociatedModel.fromJson(Map json) {
    return StockByEnterpriseAssociatedModel(
      Enterprise: json['Enterprise'],
      StockBalanceForSale: json['StockBalanceForSale'],
      StorageAreaAddress: json['StorageAreaAddress'] == null
          ? null
          : List<String>.from(json['StorageAreaAddress']),
    );
  }

  Map<String, dynamic> toJson() => {
    'Enterprise': Enterprise,
    'StockBalanceForSale': StockBalanceForSale,
    'StorageAreaAddress': StorageAreaAddress,
  };

  factory StockByEnterpriseAssociatedModel.fromEntity(
    StockByEnterpriseAssociatedEntity entity,
  ) {
    return StockByEnterpriseAssociatedModel(
      Enterprise: entity.Enterprise,
      StockBalanceForSale: entity.StockBalanceForSale,
      StorageAreaAddress: entity.StorageAreaAddress,
    );
  }

  StockByEnterpriseAssociatedEntity toEntity() =>
      StockByEnterpriseAssociatedEntity(
        Enterprise: Enterprise,
        StockBalanceForSale: StockBalanceForSale,
        StorageAreaAddress: StorageAreaAddress,
      );
}
