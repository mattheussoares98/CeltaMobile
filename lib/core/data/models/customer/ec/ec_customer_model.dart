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
    Id: json['id'],
    Name: json['name'],
    DateOfBirth: json['dateOfBirth'] == null
        ? null
        : DateTime.tryParse(json['dateOfBirth']),
    PersonType: CustomerPersonType.values.firstWhereOrNull(
      (e) => e.shortName == json['personType'],
    ),
    CpfCnpjNumber: json['cpfCnpjNumber'],
    ContactName: json['contactName'],
    Email: json['email'],
    PhoneArea: json['phoneArea'],
    PhoneNumber: json['phoneNumber'],
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': Id,
    'name': Name,
    'dateOfBirth': DateOfBirth?.toIso8601String(),
    'personType': PersonType?.shortName,
    'cpfCnpjNumber': CpfCnpjNumber,
    'contactName': ContactName,
    'email': Email,
    'phoneArea': PhoneArea,
    'phoneNumber': PhoneNumber,
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
