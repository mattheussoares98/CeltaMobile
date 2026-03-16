import 'package:equatable/equatable.dart';

import '../../../../../core/data/models/models.dart';
import '../../../domain/entities/entities.dart';

class EcSaleRequestDeliveryModel extends Equatable {
  final String Transporter;
  final double TotalValue;
  final EcAddressModel DeliveryAddress;

  const EcSaleRequestDeliveryModel({
    required this.Transporter,
    required this.TotalValue,
    required this.DeliveryAddress,
  });

  @override
  List<Object?> get props => [Transporter, TotalValue, DeliveryAddress];

  factory EcSaleRequestDeliveryModel.fromJson(Map json) {
    return EcSaleRequestDeliveryModel(
      Transporter: json['Transporter'],
      TotalValue: json['TotalValue'],
      DeliveryAddress: EcAddressModel.fromJson(json['DeliveryAddress']),
    );
  }

  Map<String, dynamic> toJson() => {
    'Transporter': Transporter,
    'TotalValue': TotalValue,
    'DeliveryAddress': DeliveryAddress.toJson(),
  };

  factory EcSaleRequestDeliveryModel.fromEntity(DeliveryEntity entity) =>
      EcSaleRequestDeliveryModel(
        Transporter: entity.Transporter,
        TotalValue: entity.TotalValue,
        DeliveryAddress: EcAddressModel.fromEntity(entity.DeliveryAddress),
      );

  DeliveryEntity toEntity() => DeliveryEntity(
    Transporter: Transporter,
    TotalValue: TotalValue,
    DeliveryAddress: DeliveryAddress.toEntity(),
  );
}
