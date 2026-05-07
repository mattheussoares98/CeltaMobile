import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class EcRequestTypeParametersModel extends Equatable {
  final int userCode;
  final bool inclusiveSale;
  final bool inclusiveBuy;
  final bool inclusiveTransfer;

  const EcRequestTypeParametersModel({
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

  factory EcRequestTypeParametersModel.fromEntity(
    EcRequestTypeParametersEntity entity,
  ) => EcRequestTypeParametersModel(
    userCode: entity.userCode,
    inclusiveSale: entity.inclusiveSale,
    inclusiveBuy: entity.inclusiveBuy,
    inclusiveTransfer: entity.inclusiveTransfer,
  );

  EcRequestTypeParametersEntity toEntity() => EcRequestTypeParametersEntity(
    userCode: userCode,
    inclusiveSale: inclusiveSale,
    inclusiveBuy: inclusiveBuy,
    inclusiveTransfer: inclusiveTransfer,
  );

  Map<String, dynamic> toJson() => {
    'UserCode': userCode,
    'InclusiveSale': inclusiveSale,
    'InclusiveBuy': inclusiveBuy,
    'InclusiveTransfer': inclusiveTransfer,
  };

  factory EcRequestTypeParametersModel.fromJson(Map<String, dynamic> json) =>
      EcRequestTypeParametersModel(
        userCode: json['UserCode'],
        inclusiveSale: json['InclusiveSale'],
        inclusiveBuy: json['InclusiveBuy'],
        inclusiveTransfer: json['InclusiveTransfer'],
      );
}
