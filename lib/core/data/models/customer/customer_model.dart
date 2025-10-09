import 'package:equatable/equatable.dart';

import '../models.dart';
import '../../../domain/entities/entities.dart';
import 'customer.dart';

class CustomerModel extends Equatable {
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
  final List<CustomerTelephoneModel>? Telephones;
  final List<CustomerCovenantModel>? CustomerCovenants;
  final List<AddressModel>? Addresses;
  final CustomerSaleBlockadeInstructionModel? saleBlockadeInstructionModel;
  final CustomerSaleBlockadeModel? saleBlockadeModel;

  const CustomerModel({
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
    required this.saleBlockadeInstructionModel,
    required this.saleBlockadeModel,
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
    saleBlockadeInstructionModel,
    saleBlockadeModel,
  ];

  Map<String, dynamic> toJson() => <String, dynamic>{
    'Code': Code ?? 0,
    'PersonalizedCode': PersonalizedCode,
    'Name': Name,
    'ReducedName': ReducedName,
    'CpfCnpjNumber': CpfCnpjNumber,
    'RegistrationNumber': RegistrationNumber,
    'Password': Password,
    'HasPassword': HasPassword,
    'DateOfBirth': DateOfBirth?.toIso8601String(),
    'SexType': SexType?.shortName,
    'PersonType': PersonType?.shortName,
    'Emails': Emails,
    'Telephones': Telephones?.map((e) => e.toJson()).toList(),
    'Addresses': Addresses?.map((e) => e.toJson()).toList(),
    'CustomerCovenants': CustomerCovenants?.map((e) => e.toJson()).toList(),
    'SaleBlockadeInstructionModel': saleBlockadeInstructionModel?.toJson(),
    'SaleBlockadeModel': saleBlockadeModel?.toJson(),
  };

  factory CustomerModel.fromJson(Map json) => CustomerModel(
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
        ?.map((e) => CustomerTelephoneModel.fromJson(e))
        .toList(),
    Addresses: (json['Addresses'] as List?)
        ?.map((e) => AddressModel.fromJson(e))
        .toList(),
    CustomerCovenants: (json['CustomerCovenants'] as List?)
        ?.map((e) => CustomerCovenantModel.fromJson(e))
        .toList(),
    saleBlockadeInstructionModel: json['SaleBlockadeInstructionModel'] == null
        ? null
        : CustomerSaleBlockadeInstructionModel.fromJson(
            json['SaleBlockadeInstructionModel'],
          ),
    saleBlockadeModel: json['SaleBlockadeModel'] == null
        ? null
        : CustomerSaleBlockadeModel.fromJson(json['SaleBlockadeModel']),
  );

  factory CustomerModel.fromEntity(CustomerEntity entity) => CustomerModel(
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
      (e) => CustomerTelephoneModel.fromEntity(e),
    ).toList(),
    Addresses: entity.Addresses?.map(
      (e) => AddressModel.fromEntity(e),
    ).toList(),
    CustomerCovenants: entity.CustomerCovenants?.map(
      (e) => CustomerCovenantModel.fromEntity(e),
    ).toList(),
    saleBlockadeInstructionModel: entity.saleBlockadeInstruction == null
        ? null
        : CustomerSaleBlockadeInstructionModel.fromEntity(
            entity.saleBlockadeInstruction!,
          ),
    saleBlockadeModel: entity.saleBlockade == null
        ? null
        : CustomerSaleBlockadeModel.fromEntity(entity.saleBlockade!),
  );

  CustomerEntity toEntity() => CustomerEntity(
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
    saleBlockadeInstruction: saleBlockadeInstructionModel?.toEntity(),
    saleBlockade: saleBlockadeModel?.toEntity(),
  );
}
