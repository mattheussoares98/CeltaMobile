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
  final DateTime? DateOfBirth;
  final String? SexType;
  final String? PersonType;
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
    'Code': Code,
    'PersonalizedCode': PersonalizedCode,
    'Name': Name,
    'ReducedName': ReducedName,
    'CpfCnpjNumber': CpfCnpjNumber,
    'RegistrationNumber': RegistrationNumber,
    'DateOfBirth': DateOfBirth?.toIso8601String(),
    'SexType': SexType,
    'PersonType': PersonType,
    'Emails': Emails,
    'Telephones': Telephones?.map((e) => e.toJson()).toList(),
    'Addresses': Addresses?.map((e) => e.toJson()).toList(),
    'CustomerCovenants': CustomerCovenants?.map((e) => e.toJson()).toList(),
    'saleBlockadeInstructionModel': saleBlockadeInstructionModel?.toJson(),
    'saleBlockadeModel': saleBlockadeModel?.toJson(),
  };

  factory CustomerModel.fromJson(Map json) => CustomerModel(
    Code: json['Code'],
    PersonalizedCode: json['PersonalizedCode'],
    Name: json['Name'],
    ReducedName: json['ReducedName'],
    CpfCnpjNumber: json['CpfCnpjNumber'],
    RegistrationNumber: json['RegistrationNumber'],
    DateOfBirth: json['DateOfBirth'] == null
        ? null
        : DateTime.parse(json['DateOfBirth']),
    SexType: json['SexType'],
    PersonType: json['PersonType'],
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
    saleBlockadeInstructionModel: json['saleBlockadeInstructionModel'] == null
        ? null
        : CustomerSaleBlockadeInstructionModel.fromJson(
            json['saleBlockadeInstructionModel'],
          ),
    saleBlockadeModel: json['saleBlockadeModel'] == null
        ? null
        : CustomerSaleBlockadeModel.fromJson(json['saleBlockadeModel']),
  );

  factory CustomerModel.fromEntity(CustomerEntity entity) => CustomerModel(
    Code: entity.Code,
    PersonalizedCode: entity.PersonalizedCode,
    Name: entity.Name,
    ReducedName: entity.ReducedName,
    CpfCnpjNumber: entity.CpfCnpjNumber,
    RegistrationNumber: entity.RegistrationNumber,
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
