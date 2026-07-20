import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class EcBuyRequestEnterpriseDtoModel extends Equatable {
  final String? personalizedCode;
  final String? cnpjNumber;
  final String? name;

  const EcBuyRequestEnterpriseDtoModel({
    required this.personalizedCode,
    required this.cnpjNumber,
    required this.name,
  });

  @override
  List<Object?> get props => [personalizedCode, cnpjNumber, name];

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
