import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class EcSaleRequestFinalizationModel extends Equatable {
  final String Id;
  final String Name;
  final double TotalValue;
  final int PortionQuantity;

  const EcSaleRequestFinalizationModel({
    required this.Id,
    required this.Name,
    required this.TotalValue,
    required this.PortionQuantity,
  });

  @override
  List<Object?> get props => [Id, Name, TotalValue, PortionQuantity];

  Map<String, dynamic> toJson() => {
    'id': Id,
    'name': Name,
    'totalValue': TotalValue,
    'portionQuantity': PortionQuantity,
  };

  factory EcSaleRequestFinalizationModel.fromJson(Map json) =>
      EcSaleRequestFinalizationModel(
        Id: json['id'],
        Name: json['name'],
        TotalValue: json['totalValue'],
        PortionQuantity: json['portionQuantity'],
      );

  factory EcSaleRequestFinalizationModel.fromEntity(
    FinalizationEntity entity,
  ) => EcSaleRequestFinalizationModel(
    Id: entity.Id,
    Name: entity.Name,
    TotalValue: entity.TotalValue,
    PortionQuantity: entity.PortionQuantity,
  );

  FinalizationEntity toEntity() => FinalizationEntity(
    Id: Id,
    Name: Name,
    TotalValue: TotalValue,
    PortionQuantity: PortionQuantity,
  );
}
