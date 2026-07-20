import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class EcBuyRequestEnterpriseItemDtoEntity extends Equatable {
  final dynamic buyRequest;
  final bool? isPrincipal;
  final EcBuyRequestEnterpriseDtoEntity? enterprise;
  final double? totalLiquidValue;

  const EcBuyRequestEnterpriseItemDtoEntity({
    required this.buyRequest,
    required this.isPrincipal,
    required this.enterprise,
    required this.totalLiquidValue,
  });

  @override
  List<Object?> get props => [
    buyRequest,
    isPrincipal,
    enterprise,
    totalLiquidValue,
  ];
}
