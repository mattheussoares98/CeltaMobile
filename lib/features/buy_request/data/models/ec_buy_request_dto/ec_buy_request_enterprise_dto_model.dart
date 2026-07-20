import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';

class EcBuyRequestEnterpriseDtoModel extends EcBuyRequestEnterpriseDtoEntity {
  const EcBuyRequestEnterpriseDtoModel({
    required super.personalizedCode,
    required super.cnpjNumber,
    required super.name,
  });

  factory EcBuyRequestEnterpriseDtoModel.fromJson(Map json) {
    return EcBuyRequestEnterpriseDtoModel(
      personalizedCode: json['personalizedCode']?.toString(),
      cnpjNumber: json['cnpjNumber']?.toString(),
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'personalizedCode': personalizedCode,
      'cnpjNumber': cnpjNumber,
      'name': name,
    };
  }

  factory EcBuyRequestEnterpriseDtoModel.fromEntity(
    EcBuyRequestEnterpriseDtoEntity entity,
  ) {
    return EcBuyRequestEnterpriseDtoModel(
      personalizedCode: entity.personalizedCode,
      cnpjNumber: entity.cnpjNumber,
      name: entity.name,
    );
  }

  EcBuyRequestEnterpriseDtoEntity toEntity() {
    return EcBuyRequestEnterpriseDtoEntity(
      personalizedCode: personalizedCode,
      cnpjNumber: cnpjNumber,
      name: name,
    );
  }
}
