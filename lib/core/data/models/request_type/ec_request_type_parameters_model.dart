import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class EcRequestTypeParametersModel extends Equatable {
  final int enterpriseCode;
  final bool inclusiveSale;
  final bool inclusiveBuy;
  final bool inclusiveTransfer;

  const EcRequestTypeParametersModel({
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

  factory EcRequestTypeParametersModel.fromEntity(
    EcRequestTypeParametersEntity entity,
  ) => EcRequestTypeParametersModel(
    enterpriseCode: entity.enterpriseCode,
    inclusiveSale: entity.inclusiveSale,
    inclusiveBuy: entity.inclusiveBuy,
    inclusiveTransfer: entity.inclusiveTransfer,
  );

  EcRequestTypeParametersEntity toEntity() => EcRequestTypeParametersEntity(
    enterpriseCode: enterpriseCode,
    inclusiveSale: inclusiveSale,
    inclusiveBuy: inclusiveBuy,
    inclusiveTransfer: inclusiveTransfer,
  );

  Map<String, dynamic> toJson() => {
    'enterpriseCode': enterpriseCode,
    'InclusiveSale': inclusiveSale,
    'InclusiveBuy': inclusiveBuy,
    'InclusiveTransfer': inclusiveTransfer,
  };

  factory EcRequestTypeParametersModel.fromJson(Map json) =>
      EcRequestTypeParametersModel(
        enterpriseCode: json['enterpriseCode'],
        inclusiveSale: json['InclusiveSale'],
        inclusiveBuy: json['InclusiveBuy'],
        inclusiveTransfer: json['InclusiveTransfer'],
      );
}
