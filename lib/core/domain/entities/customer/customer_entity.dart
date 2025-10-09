// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../entities.dart';

class CustomerEntity extends Equatable {
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
  final List<CustomerTelephoneEntity>? Telephones;
  final List<CustomerCovenantEntity>? CustomerCovenants;
  final List<AddressEntity>? Addresses;
  final CustomerSaleBlockadeInstructionEntity? saleBlockadeInstruction;
  final CustomerSaleBlockadeEntity? saleBlockade;

  const CustomerEntity({
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

  CustomerEntity copyWith({
    int? Code,
    String? PersonalizedCode,
    String? Name,
    String? ReducedName,
    String? CpfCnpjNumber,
    String? RegistrationNumber,
    String? Password,
    bool? HasPassword,
    DateTime? DateOfBirth,
    CustomerSexType? SexType,
    CustomerPersonType? PersonType,
    List<String>? Emails,
    List<CustomerTelephoneEntity>? Telephones,
    List<CustomerCovenantEntity>? CustomerCovenants,
    List<AddressEntity>? Addresses,
    CustomerSaleBlockadeInstructionEntity? saleBlockadeInstruction,
    CustomerSaleBlockadeEntity? saleBlockade,
  }) {
    return CustomerEntity(
      Code: Code ?? this.Code,
      PersonalizedCode: PersonalizedCode ?? this.PersonalizedCode,
      Name: Name ?? this.Name,
      ReducedName: ReducedName ?? this.ReducedName,
      CpfCnpjNumber: CpfCnpjNumber ?? this.CpfCnpjNumber,
      RegistrationNumber: RegistrationNumber ?? this.RegistrationNumber,
      Password: Password ?? this.Password,
      HasPassword: HasPassword ?? this.HasPassword,
      DateOfBirth: DateOfBirth ?? this.DateOfBirth,
      SexType: SexType ?? this.SexType,
      PersonType: PersonType ?? this.PersonType,
      Emails: Emails ?? this.Emails,
      Telephones: Telephones ?? this.Telephones,
      CustomerCovenants: CustomerCovenants ?? this.CustomerCovenants,
      Addresses: Addresses ?? this.Addresses,
      saleBlockadeInstruction:
          saleBlockadeInstruction ?? this.saleBlockadeInstruction,
      saleBlockade: saleBlockade ?? this.saleBlockade,
    );
  }

  factory CustomerEntity.empty() => const CustomerEntity(
    Code: null,
    PersonalizedCode: null,
    Name: null,
    ReducedName: null,
    CpfCnpjNumber: null,
    RegistrationNumber: null,
    Password: null,
    HasPassword: null,
    DateOfBirth: null,
    SexType: null,
    PersonType: null,
    Emails: null,
    Telephones: null,
    CustomerCovenants: null,
    Addresses: null,
    saleBlockadeInstruction: null,
    saleBlockade: null,
  );
}
