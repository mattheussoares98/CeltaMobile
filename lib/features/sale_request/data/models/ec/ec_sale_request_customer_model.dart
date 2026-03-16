import 'package:equatable/equatable.dart';

class EcSaleRequestCustomerModel extends Equatable {
  final int Id;
  final String Name;
  final DateTime? DateOfBirth;
  final String PersonType;
  final String? CpfCnpjNumber;
  final String? ContactName;
  final String? Email;
  final String? PhoneArea;
  final String? PhoneNumber;

  const EcSaleRequestCustomerModel({
    required this.Id,
    required this.Name,
    required this.DateOfBirth,
    required this.PersonType,
    required this.CpfCnpjNumber,
    required this.ContactName,
    required this.Email,
    required this.PhoneArea,
    required this.PhoneNumber,
  });

  @override
  List<Object?> get props => [
    Id,
    Name,
    DateOfBirth,
    PersonType,
    CpfCnpjNumber,
    ContactName,
    Email,
    PhoneArea,
    PhoneNumber,
  ];
}
