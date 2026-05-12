import 'package:equatable/equatable.dart';

import '../../../../domain/entities/entities.dart';
import '../../models.dart';

class SoapCustomerModel extends Equatable {
  final int? Code;
  final String? PersonalizedCode;
  final String? Name;
  final String? ReducedName;
  final String? CpfCnpjNumber;
  final String? RegistrationNumber;
  final String? Password;
  final bool? HasPassword;
  final DateTime? DateOfBirth;
  final CustomerSexType? SexType;
  final CustomerPersonType? PersonType;
  final List<String>? Emails;
  final List<SoapCustomerTelephoneModel>? Telephones;
  final List<SoapCustomerCovenantModel>? CustomerCovenants;
  final List<SoapAddressModel>? Addresses;
  final SoapCustomerSaleBlockadeInstructionModel? saleBlockadeInstruction;
  final SoapCustomerSaleBlockadeModel? saleBlockade;

  const SoapCustomerModel({
    required this.Name,
    required this.Code,
    required this.PersonalizedCode,
    required this.ReducedName,
    required this.CpfCnpjNumber,
    required this.RegistrationNumber,
    required this.Password,
    required this.HasPassword,
    required this.DateOfBirth,
    required this.SexType,
    required this.PersonType,
    required this.Emails,
    required this.Telephones,
    required this.Addresses,
    required this.CustomerCovenants,
    required this.saleBlockadeInstruction,
    required this.saleBlockade,
  });

  @override
  List<Object?> get props => [
    Code,
    PersonalizedCode,
    Name,
    ReducedName,
    CpfCnpjNumber,
    RegistrationNumber,
    Password,
    HasPassword,
    DateOfBirth,
    SexType,
    PersonType,
    Emails,
    Telephones,
    Addresses,
    CustomerCovenants,
    saleBlockadeInstruction,
    saleBlockade,
  ];

  Map<String, dynamic> toJson() => <String, dynamic>{
    'Name': Name,
    'ReducedName': ReducedName,
    'CpfCnpjNumber': CpfCnpjNumber,
    'RegistrationNumber': RegistrationNumber,
    'Password': Password,
    'DateOfBirth': DateOfBirth?.toIso8601String(),
    'SexType': SexType?.shortName,
    'PersonType': PersonType?.shortName,
    'Emails': Emails,
    'Telephones': Telephones?.map((e) => e.toJson()).toList(),
    'Addresses': Addresses?.map((e) => e.toJson()).toList(),
    'CustomerCovenants': CustomerCovenants?.map((e) => e.toJson()).toList(),
    //! throw error if pass the value in a new customer
    if (Code != null) 'Code': Code,
    if (PersonalizedCode != null) 'PersonalizedCode': PersonalizedCode,
    if (HasPassword != null) 'HasPassword': HasPassword,
    if (saleBlockadeInstruction != null)
      'SaleBlockadeInstruction': saleBlockadeInstruction?.toJson(),
    if (saleBlockade != null) 'SaleBlockade': saleBlockade?.toJson(),
  };

  factory SoapCustomerModel.fromJson(Map json) => SoapCustomerModel(
    Code: json['Code'],
    PersonalizedCode: json['PersonalizedCode'],
    Name: json['Name'],
    ReducedName: json['ReducedName'],
    CpfCnpjNumber: json['CpfCnpjNumber'],
    RegistrationNumber: json['RegistrationNumber'],
    Password: json['Password'],
    HasPassword: json['HasPassword'],
    DateOfBirth: json['DateOfBirth'] == null
        ? null
        : DateTime.parse(json['DateOfBirth']),
    SexType: json['SexType'] == null
        ? null
        : CustomerSexType.values.firstWhere(
            (e) => e.shortName == json['SexType'],
          ),
    PersonType: json['PersonType'] == null
        ? null
        : CustomerPersonType.values.firstWhere(
            (e) => e.shortName == json['PersonType'],
          ),
    Emails: (json['Emails'] as List?)?.map((e) => e.toString()).toList(),
    Telephones: (json['Telephones'] as List?)
        ?.map((e) => SoapCustomerTelephoneModel.fromJson(e))
        .toList(),
    Addresses: (json['Addresses'] as List?)
        ?.map((e) => SoapAddressModel.fromJson(e))
        .toList(),
    CustomerCovenants: (json['CustomerCovenants'] as List?)
        ?.map((e) => SoapCustomerCovenantModel.fromJson(e))
        .toList(),
    saleBlockadeInstruction: json['SaleBlockadeInstruction'] == null
        ? null
        : SoapCustomerSaleBlockadeInstructionModel.fromJson(
            json['SaleBlockadeInstruction'],
          ),
    saleBlockade: json['SaleBlockade'] == null
        ? null
        : SoapCustomerSaleBlockadeModel.fromJson(json['SaleBlockade']),
  );

  factory SoapCustomerModel.fromEntity(SoapCustomerEntity entity) =>
      SoapCustomerModel(
        Code: entity.Code,
        PersonalizedCode: entity.PersonalizedCode,
        Name: entity.Name,
        ReducedName: entity.ReducedName,
        CpfCnpjNumber: entity.CpfCnpjNumber,
        RegistrationNumber: entity.RegistrationNumber,
        Password: entity.Password,
        HasPassword: entity.HasPassword,
        DateOfBirth: entity.DateOfBirth,
        SexType: entity.SexType,
        PersonType: entity.PersonType,
        Emails: entity.Emails,
        Telephones: entity.Telephones?.map(
          (e) => SoapCustomerTelephoneModel.fromEntity(e),
        ).toList(),
        Addresses: entity.Addresses?.map(
          (e) => SoapAddressModel.fromEntity(e),
        ).toList(),
        CustomerCovenants: entity.CustomerCovenants?.map(
          (e) => SoapCustomerCovenantModel.fromEntity(e),
        ).toList(),
        saleBlockadeInstruction: entity.saleBlockadeInstruction == null
            ? null
            : SoapCustomerSaleBlockadeInstructionModel.fromEntity(
                entity.saleBlockadeInstruction!,
              ),
        saleBlockade: entity.saleBlockade == null
            ? null
            : SoapCustomerSaleBlockadeModel.fromEntity(entity.saleBlockade!),
      );

  SoapCustomerEntity toEntity() => SoapCustomerEntity(
    Code: Code,
    PersonalizedCode: PersonalizedCode,
    Name: Name,
    ReducedName: ReducedName,
    CpfCnpjNumber: CpfCnpjNumber,
    RegistrationNumber: RegistrationNumber,
    Password: Password,
    HasPassword: HasPassword,
    DateOfBirth: DateOfBirth,
    SexType: SexType,
    PersonType: PersonType,
    Emails: Emails,
    Telephones: Telephones?.map((e) => e.toEntity()).toList(),
    Addresses: Addresses?.map((e) => e.toEntity()).toList(),
    CustomerCovenants: CustomerCovenants?.map((e) => e.toEntity()).toList(),
    saleBlockadeInstruction: saleBlockadeInstruction?.toEntity(),
    saleBlockade: saleBlockade?.toEntity(),
  );
}
