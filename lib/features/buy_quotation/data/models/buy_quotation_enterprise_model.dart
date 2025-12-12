import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';
import 'models.dart';

class BuyQuotationEnterpriseModel extends Equatable {
  final int? Code;
  final BuyQuotationEnterpriseInfoModel enterprise;

  const BuyQuotationEnterpriseModel({
    required this.Code,
    required this.enterprise,
  });

  @override
  List<Object?> get props => [Code, enterprise];

  factory BuyQuotationEnterpriseModel.fromJson(Map json) =>
      BuyQuotationEnterpriseModel(
        Code: json['Code'],
        enterprise: BuyQuotationEnterpriseInfoModel.fromJson(
          json['Enterprise'],
        ),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'Code': Code,
    'Enterprise': enterprise.toJson(),
  };

  factory BuyQuotationEnterpriseModel.fromEntity(
    BuyQuotationEnterpriseEntity entity,
  ) => BuyQuotationEnterpriseModel(
    Code: entity.Code,
    enterprise: BuyQuotationEnterpriseInfoModel.fromEntity(entity.enterprise),
  );

  BuyQuotationEnterpriseEntity toEntity() => BuyQuotationEnterpriseEntity(
    Code: Code,
    enterprise: enterprise.toEntity(),
  );
}
