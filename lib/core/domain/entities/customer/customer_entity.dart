import 'package:equatable/equatable.dart';

import '../entities.dart';

class CustomerEntity extends Equatable {
  final int? Code;
  final String? PersonalizedCode;
  final String? Name;
  final String? ReducedName;
  final String? CpfCnpjNumber;
  final String? RegistrationNumber;
  final DateTime? DateOfBirth;
  final CustomerSexType? SexType;
  final String? PersonType;
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
}
