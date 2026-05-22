import 'package:equatable/equatable.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';

class StockModel extends Equatable {
  final int EnterpriseCode;
  final String Enterprise;
  final String StockName;
  final double StockQuantity;
  const StockModel({
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

  factory StockModel.fromJson(Map json) => StockModel(
    EnterpriseCode: json["EnterpriseCode"],
    Enterprise: json["Enterprise"],
    StockName: json["StockName"],
    StockQuantity: json["StockQuantity"],
  );

  Map<String, dynamic> toJson() => {
    "EnterpriseCode": EnterpriseCode,
    "Enterprise": Enterprise,
    "StockName": StockName,
    "StockQuantity": StockQuantity,
  };

  factory StockModel.fromEntity(StockEntity entity) => StockModel(
    EnterpriseCode: entity.EnterpriseCode,
    Enterprise: entity.Enterprise,
    StockName: entity.StockName,
    StockQuantity: entity.StockQuantity,
  );

  StockEntity toEntity() => StockEntity(
    EnterpriseCode: EnterpriseCode,
    Enterprise: Enterprise,
    StockName: StockName,
    StockQuantity: StockQuantity,
  );
}
