import 'package:equatable/equatable.dart';

import '../../../../../core/domain/entities/entities.dart';
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
        TotalValue: (json['totalValue'] as num).toDouble(),
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

  factory EcSaleRequestFinalizationModel.fromBSFPaymentFinalizationWrapperEntity(
    BSFPaymentFinalizationWrapperEntity entity,
  ) => EcSaleRequestFinalizationModel(
    Id: entity.paymentFinalization?.code?.toString() ?? '',
    Name: entity.paymentFinalization?.paymentForm?.name ?? '',
    TotalValue: entity.value ?? 0.0,
    PortionQuantity: entity.quantityOfPortions ?? 1,
  );

  FinalizationEntity toEntity() => FinalizationEntity(
    Id: Id,
    Name: Name,
    TotalValue: TotalValue,
    PortionQuantity: PortionQuantity,
  );
}
