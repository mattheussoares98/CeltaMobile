import 'package:celta_inventario/features/buy_request/data/models/ec_buy_request_dto/ec_buy_request_dto.dart';
import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';

class EcBuyRequestEnterpriseItemDtoModel
    extends EcBuyRequestEnterpriseItemDtoEntity {
  const EcBuyRequestEnterpriseItemDtoModel({
    required super.buyRequest,
    required super.isPrincipal,
    required super.enterprise,
    required super.totalLiquidValue,
  });

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
      'enterprise': enterprise == null
          ? null
          : EcBuyRequestEnterpriseDtoModel.fromEntity(enterprise!).toJson(),
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
      enterprise: enterprise == null
          ? null
          : EcBuyRequestEnterpriseDtoModel.fromEntity(enterprise!).toEntity(),
      totalLiquidValue: totalLiquidValue,
    );
  }
}
