import 'package:celta_inventario/features/buy_request/data/models/ec_buy_request_dto/ec_buy_request_dto.dart';
import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class EcBuyRequestEnterpriseItemDtoModel extends Equatable {
  final dynamic buyRequest;
  final bool? isPrincipal;
  final EcBuyRequestEnterpriseDtoModel? enterprise;
  final double? totalLiquidValue;

  const EcBuyRequestEnterpriseItemDtoModel({
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

  factory EcBuyRequestEnterpriseItemDtoModel.fromJson(Map json) {
    return EcBuyRequestEnterpriseItemDtoModel(
      buyRequest: json['buyRequest'],
      isPrincipal: json['isPrincipal'] as bool?,
      enterprise: json['enterprise'] != null
          ? EcBuyRequestEnterpriseDtoModel.fromJson(json['enterprise'] as Map)
          : null,
      totalLiquidValue: (json['totalLiquidValue'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'buyRequest': buyRequest,
      'isPrincipal': isPrincipal,
      'enterprise': enterprise?.toJson(),
      'totalLiquidValue': totalLiquidValue,
    };
  }

  factory EcBuyRequestEnterpriseItemDtoModel.fromEntity(
    EcBuyRequestEnterpriseItemDtoEntity entity,
  ) {
    return EcBuyRequestEnterpriseItemDtoModel(
      buyRequest: entity.buyRequest,
      isPrincipal: entity.isPrincipal,
      enterprise: entity.enterprise == null
          ? null
          : EcBuyRequestEnterpriseDtoModel.fromEntity(entity.enterprise!),
      totalLiquidValue: entity.totalLiquidValue,
    );
  }

  EcBuyRequestEnterpriseItemDtoEntity toEntity() {
    return EcBuyRequestEnterpriseItemDtoEntity(
      buyRequest: buyRequest,
      isPrincipal: isPrincipal,
      enterprise: enterprise?.toEntity(),
      totalLiquidValue: totalLiquidValue,
    );
  }
}
