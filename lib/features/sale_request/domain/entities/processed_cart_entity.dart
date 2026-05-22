import 'package:equatable/equatable.dart';

import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';

class ProcessedCartEntity extends Equatable {
  final String? crossId;
  final int EnterpriseCode;
  final int RequestTypeCode;
  final int CustomerCode;
  final int? SellerCode;
  final int? CovenantCode;
  final String? Instructions;
  final String? Observations;
  final List<SaleRequestCartProductEntity>? Products;

  const ProcessedCartEntity({
    required this.crossId,
    required this.EnterpriseCode,
    required this.RequestTypeCode,
    required this.SellerCode,
    required this.CovenantCode,
    required this.CustomerCode,
    required this.Products,
    required this.Instructions,
    required this.Observations,
  });

  @override
  List<Object?> get props => [
    crossId,
    EnterpriseCode,
    RequestTypeCode,
    CustomerCode,
    SellerCode,
    CovenantCode,
    Instructions,
    Observations,
    Products,
  ];
}
