import 'package:equatable/equatable.dart';

import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';

class EcSaleRequestDeliveryModel extends Equatable {
  final String? Transporter;
  final double TotalValue;
  final EcAddressModel? DeliveryAddress;

  const EcSaleRequestDeliveryModel({
    required this.Transporter,
    required this.TotalValue,
    required this.DeliveryAddress,
  });

  @override
  List<Object?> get props => [Transporter, TotalValue, DeliveryAddress];

  factory EcSaleRequestDeliveryModel.fromJson(Map json) {
    return EcSaleRequestDeliveryModel(
      Transporter: json['transporter'],
      TotalValue: json['totalValue'],
      DeliveryAddress: EcAddressModel.fromJson(json['deliveryAddress']),
    );
  }

  Map<String, dynamic> toJson() => {
    'transporter': Transporter,
    'totalValue': TotalValue,
    'deliveryAddress': DeliveryAddress?.toJson(),
  };

  factory EcSaleRequestDeliveryModel.fromEntity(DeliveryEntity entity) =>
      EcSaleRequestDeliveryModel(
        Transporter: entity.Transporter,
        TotalValue: entity.TotalValue,
        DeliveryAddress: entity.DeliveryAddress == null
            ? null
            : EcAddressModel.fromEntity(entity.DeliveryAddress!),
      );

  DeliveryEntity toEntity() => DeliveryEntity(
    Transporter: Transporter,
    TotalValue: TotalValue,
    DeliveryAddress: DeliveryAddress?.toEntity(),
  );
}
