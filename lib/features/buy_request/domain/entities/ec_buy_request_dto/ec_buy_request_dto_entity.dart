import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class EcBuyRequestDtoEntity extends Equatable {
  final int code;
  final String? personalizedCode;
  final EcBuyRequestBuyerDtoEntity? buyer;
  final EcBuyRequestTypeDtoEntity? requestType;
  final EcBuyRequestSupplierDtoEntity? supplier;
  final List<EcBuyRequestEnterpriseItemDtoEntity>? enterprises;
  final double? totalLiquid;

  const EcBuyRequestDtoEntity({
    required this.code,
    required this.personalizedCode,
    required this.buyer,
    required this.requestType,
    required this.supplier,
    required this.enterprises,
    required this.totalLiquid,
  });

  @override
  List<Object?> get props => [
    code,
    personalizedCode,
    buyer,
    requestType,
    supplier,
    enterprises,
    totalLiquid,
  ];
}
