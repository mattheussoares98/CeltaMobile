import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';
import 'models.dart';

class BuyQuotationEnterpriseModel extends Equatable {
  final int? Code;
  final BuyQuotationEnterpriseInfoModel enterprise;
  final bool? isSelected;

  const BuyQuotationEnterpriseModel({
    required this.Code,
    required this.enterprise,
    required this.isSelected,
  });

  @override
  List<Object?> get props => [Code, enterprise, isSelected];

  factory BuyQuotationEnterpriseModel.fromJson(Map json) =>
      BuyQuotationEnterpriseModel(
        Code: json['Code'],
        enterprise: BuyQuotationEnterpriseInfoModel.fromJson(
          json['Enterprise'],
        ),
        isSelected: json['isSelected'] == true || json['Code'] != null,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'Code': Code,
    'Enterprise': enterprise.toJson(),
    'isSelected': isSelected,
  };

  factory BuyQuotationEnterpriseModel.fromEntity(
    BuyQuotationEnterpriseEntity entity,
  ) => BuyQuotationEnterpriseModel(
    Code: entity.Code,
    isSelected: entity.isSelected,
    enterprise: BuyQuotationEnterpriseInfoModel.fromEntity(entity.enterprise),
  );

  BuyQuotationEnterpriseEntity toEntity() => BuyQuotationEnterpriseEntity(
    Code: Code,
    enterprise: enterprise.toEntity(),
    isSelected: isSelected,
  );
}
