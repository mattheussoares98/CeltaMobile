import 'package:equatable/equatable.dart';

import '../../../../../core/data/models/models.dart';

class DeliveryEntity extends Equatable {
  final String Transporter;
  final double TotalValue;
  final EcAddressModel DeliveryAddress;

  const DeliveryEntity({
    required this.Transporter,
    required this.TotalValue,
    required this.DeliveryAddress,
  });

  @override
  List<Object?> get props => [Transporter, TotalValue, DeliveryAddress];
}
