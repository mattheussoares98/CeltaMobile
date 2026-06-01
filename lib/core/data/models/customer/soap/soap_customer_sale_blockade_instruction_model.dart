import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class SoapCustomerSaleBlockadeInstructionModel extends Equatable {
  final int Code;
  final String PersonalizedCode;
  final String LegacyCode;
  final String Description;
  const SoapCustomerSaleBlockadeInstructionModel({
    required this.Code,
    required this.PersonalizedCode,
    required this.LegacyCode,
    required this.Description,
  });

  @override
  List<Object?> get props => [Code, PersonalizedCode, LegacyCode, Description];

  Map<String, dynamic> toJson() => <String, dynamic>{
    'Code': Code,
    'PersonalizedCode': PersonalizedCode,
    'LegacyCode': LegacyCode,
    'Description': Description,
  };

  factory SoapCustomerSaleBlockadeInstructionModel.fromJson(Map json) =>
      SoapCustomerSaleBlockadeInstructionModel(
        Code: json['Code'] as int,
        PersonalizedCode: json['PersonalizedCode'] as String,
        LegacyCode: json['LegacyCode'] as String,
        Description: json['Description'] as String,
      );

  CustomerSaleBlockadeInstructionEntity toEntity() =>
      CustomerSaleBlockadeInstructionEntity(
        Code: Code,
        PersonalizedCode: PersonalizedCode,
        LegacyCode: LegacyCode,
        Description: Description,
      );

  factory SoapCustomerSaleBlockadeInstructionModel.fromEntity(
    CustomerSaleBlockadeInstructionEntity entity,
  ) => SoapCustomerSaleBlockadeInstructionModel(
    Code: entity.Code,
    PersonalizedCode: entity.PersonalizedCode,
    LegacyCode: entity.LegacyCode,
    Description: entity.Description,
  );
}
