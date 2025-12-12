import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class BuyQuotationProductEnterpriseModel extends Equatable {
  final int? Code;
  final int? EnterpriseCode;
  final double? Quantity;

  const BuyQuotationProductEnterpriseModel({
    required this.Code,
    required this.EnterpriseCode,
    required this.Quantity,
  });

  @override
  List<Object?> get props => [Code, EnterpriseCode, Quantity];

  factory BuyQuotationProductEnterpriseModel.fromJson(Map json) {
    return BuyQuotationProductEnterpriseModel(
      Code: json['Code'],
      EnterpriseCode: json['EnterpriseCode'],
      Quantity: json['Quantity'],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'Code': Code,
    'EnterpriseCode': EnterpriseCode,
    'Quantity': Quantity,
  };

  factory BuyQuotationProductEnterpriseModel.fromEntity(
    BuyQuotationProductEnterpriseEntity entity,
  ) => BuyQuotationProductEnterpriseModel(
    Code: entity.Code,
    EnterpriseCode: entity.EnterpriseCode,
    Quantity: entity.Quantity,
  );

  BuyQuotationProductEnterpriseEntity toEntity() =>
      BuyQuotationProductEnterpriseEntity(
        Code: Code,
        EnterpriseCode: EnterpriseCode,
        Quantity: Quantity,
      );
}
