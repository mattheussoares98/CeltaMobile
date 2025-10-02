import '../../../../core/domain/entities/entities.dart';
import 'entities.dart';

class CustomerEntity {
  final int? Code;
  final String? PersonalizedCode;
  final String? Name;
  final String? ReducedName;
  final String? CpfCnpjNumber;
  final String? RegistrationNumber;
  final String? DateOfBirth;
  final String? SexType;
  final String? PersonType;
  final List<String>? Emails;
  final List<CustomerTelephoneEntity>? Telephones;
  final List<CustomerCovenantEntity>? CustomerCovenants;
  final List<AddressEntity>? Addresses;
  final CustomerSaleBlockadeInstructionEntity? saleBlockadeInstructionEntity;
  final CustomerSaleBlockadeEntity? saleBlockadeEntity;

  CustomerEntity({
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
    required this.saleBlockadeInstructionEntity,
    required this.saleBlockadeEntity,
  });
}
