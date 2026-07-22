import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class EcBuyRequestDtoEntity extends Equatable {
  final int code;
  final String? personalizedCode;
  final String? observations;
  final EcBuyRequestBuyerDtoEntity? buyer;
  final EcBuyRequestTypeDtoEntity? requestType;
  final EcBuyRequestSupplierDtoEntity? supplier;
  final List<EcBuyRequestEnterpriseItemDtoEntity>? enterprises;
  final List<EcBuyRequestProductDtoEntity>? products;
  final DateTime? dateOfCreation;
  final DateTime? deliveryDate;
  final double? totalLiquid;

  const EcBuyRequestDtoEntity({
    required this.code,
    required this.personalizedCode,
    required this.observations,
    required this.buyer,
    required this.requestType,
    required this.supplier,
    required this.enterprises,
    required this.products,
    required this.totalLiquid,
    required this.dateOfCreation,
    required this.deliveryDate,
  });

  @override
  List<Object?> get props => [
    code,
    personalizedCode,
    observations,
    buyer,
    requestType,
    supplier,
    enterprises,
    products,
    totalLiquid,
    dateOfCreation,
    deliveryDate,
  ];
}
