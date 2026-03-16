import 'package:equatable/equatable.dart';

import 'ec.dart';

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
}
