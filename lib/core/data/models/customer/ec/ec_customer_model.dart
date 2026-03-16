import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/entities/entities.dart';

class EcCustomerModel extends Equatable {
  final int? Id;
  final String? Name;
  final DateTime? DateOfBirth;
  final CustomerPersonType? PersonType;
  final String? CpfCnpjNumber;
  final String? ContactName;
  final String? Email;
  final String? PhoneArea;
  final String? PhoneNumber;

  const EcCustomerModel({
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

  factory EcCustomerModel.fromJson(Map json) => EcCustomerModel(
    Id: json['Id'],
    Name: json['Name'],
    DateOfBirth: json['DateOfBirth'],
    PersonType: CustomerPersonType.values.firstWhereOrNull(
      (e) => e.shortName == json['PersonType'],
    ),
    CpfCnpjNumber: json['CpfCnpjNumber'],
    ContactName: json['ContactName'],
    Email: json['Email'],
    PhoneArea: json['PhoneArea'],
    PhoneNumber: json['PhoneNumber'],
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'Id': Id,
    'Name': Name,
    'DateOfBirth': DateOfBirth,
    'PersonType': PersonType?.shortName,
    'CpfCnpjNumber': CpfCnpjNumber,
    'ContactName': ContactName,
    'Email': Email,
    'PhoneArea': PhoneArea,
    'PhoneNumber': PhoneNumber,
  };

  factory EcCustomerModel.fromEntity(CustomerEntity entity) => EcCustomerModel(
    Id: entity.Code,
    Name: entity.Name,
    DateOfBirth: entity.DateOfBirth,
    PersonType: CustomerPersonType.values.firstWhereOrNull(
      (e) => e == entity.PersonType,
    ),
    CpfCnpjNumber: entity.CpfCnpjNumber,
    ContactName: entity.Name,
    Email: entity.Emails?.firstOrNull,
    PhoneArea: entity.Telephones?.firstOrNull?.AreaCode,
    PhoneNumber: entity.Telephones?.firstOrNull?.PhoneNumber,
  );

  CustomerEntity toEntity() => CustomerEntity.empty().copyWith(
    Code: Id,
    Name: Name,
    DateOfBirth: DateOfBirth,
    PersonType: PersonType,
    CpfCnpjNumber: CpfCnpjNumber,
    Emails: [?Email],
    Telephones: [
      CustomerTelephoneEntity(AreaCode: PhoneArea, PhoneNumber: PhoneNumber),
    ],
  );
}
