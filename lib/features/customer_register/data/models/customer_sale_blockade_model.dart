import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class CustomerSaleBlockadeModel extends Equatable {
  final int Code;
  final String PersonalizedCode;
  final String LegacyCode;
  final String Description;
  final bool AllowSaleRequest;
  final bool AllowSale;
  final bool AllowSaleWithPaymentFinalizationTypeCheckOrPortion;
  const CustomerSaleBlockadeModel({
    required this.Code,
    required this.PersonalizedCode,
    required this.LegacyCode,
    required this.Description,
    required this.AllowSaleRequest,
    required this.AllowSale,
    required this.AllowSaleWithPaymentFinalizationTypeCheckOrPortion,
  });

  @override
  List<Object?> get props => [
    Code,
    PersonalizedCode,
    LegacyCode,
    Description,
    AllowSaleRequest,
    AllowSale,
    AllowSaleWithPaymentFinalizationTypeCheckOrPortion,
  ];

  Map<String, dynamic> toJson() => <String, dynamic>{
    'Code': Code,
    'PersonalizedCode': PersonalizedCode,
    'LegacyCode': LegacyCode,
    'Description': Description,
    'AllowSaleRequest': AllowSaleRequest,
    'AllowSale': AllowSale,
    'AllowSaleWithPaymentFinalizationTypeCheckOrPortion':
        AllowSaleWithPaymentFinalizationTypeCheckOrPortion,
  };

  factory CustomerSaleBlockadeModel.fromJson(Map json) =>
      CustomerSaleBlockadeModel(
        Code: json['Code'] as int,
        PersonalizedCode: json['PersonalizedCode'] as String,
        LegacyCode: json['LegacyCode'] as String,
        Description: json['Description'] as String,
        AllowSaleRequest: json['AllowSaleRequest'] as bool,
        AllowSale: json['AllowSale'] as bool,
        AllowSaleWithPaymentFinalizationTypeCheckOrPortion:
            json['AllowSaleWithPaymentFinalizationTypeCheckOrPortion'] as bool,
      );

  factory CustomerSaleBlockadeModel.fromEntity(
    CustomerSaleBlockadeEntity entity,
  ) => CustomerSaleBlockadeModel(
    Code: entity.Code,
    PersonalizedCode: entity.PersonalizedCode,
    LegacyCode: entity.LegacyCode,
    Description: entity.Description,
    AllowSaleRequest: entity.AllowSaleRequest,
    AllowSale: entity.AllowSale,
    AllowSaleWithPaymentFinalizationTypeCheckOrPortion:
        entity.AllowSaleWithPaymentFinalizationTypeCheckOrPortion,
  );

  CustomerSaleBlockadeEntity toEntity() => CustomerSaleBlockadeEntity(
    Code: Code,
    PersonalizedCode: PersonalizedCode,
    LegacyCode: LegacyCode,
    Description: Description,
    AllowSaleRequest: AllowSaleRequest,
    AllowSale: AllowSale,
    AllowSaleWithPaymentFinalizationTypeCheckOrPortion:
        AllowSaleWithPaymentFinalizationTypeCheckOrPortion,
  );
}
