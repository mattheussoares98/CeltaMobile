import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/entities.dart';

class DeliveryEntity extends Equatable {
  final String? Transporter;
  final double TotalValue;
  final AddressEntity? DeliveryAddress;

  const DeliveryEntity({
    required this.Transporter,
    required this.TotalValue,
    required this.DeliveryAddress,
  });

  @override
  List<Object?> get props => [Transporter, TotalValue, DeliveryAddress];

  factory DeliveryEntity.empty() => const DeliveryEntity(
    Transporter: null,
    TotalValue: 0,
    DeliveryAddress: null,
  );
}
