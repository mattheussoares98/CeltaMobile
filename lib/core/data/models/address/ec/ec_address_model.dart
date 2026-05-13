import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/entities/entities.dart';

class EcAddressModel extends Equatable {
  final String ZipCode;
  final String StreetName;
  final String? Number;
  final String? Complement;
  final String? Reference;
  final String District;
  final String City;
  final BrazilStates? State;

  const EcAddressModel({
    required this.ZipCode,
    required this.StreetName,
    required this.Number,
    required this.Complement,
    required this.Reference,
    required this.District,
    required this.City,
    required this.State,
  });

  @override
  List<Object?> get props => [
    ZipCode,
    StreetName,
    Number,
    Complement,
    Reference,
    District,
    City,
    State,
  ];

  factory EcAddressModel.fromJson(Map json) => EcAddressModel(
    ZipCode: json['zipCode'],
    StreetName: json['streetName'],
    Number: json['number'],
    Complement: json['complement'],
    Reference: json['reference'],
    District: json['district'],
    City: json['city'],
    State: BrazilStates.values.firstWhereOrNull((e) => e.uf == json['state']),
  );

  Map<String, dynamic> toJson() => {
    "zipCode": ZipCode,
    "streetName": StreetName,
    "number": Number,
    "complement": Complement,
    "reference": Reference,
    "district": District,
    "city": City,
    "state": State?.uf,
  };

  factory EcAddressModel.fromEntity(AddressEntity entity) => EcAddressModel(
    ZipCode: entity.Zip,
    StreetName: entity.Address,
    Number: entity.Number,
    Complement: entity.Complement,
    Reference: entity.Reference,
    District: entity.District,
    City: entity.City,
    State: BrazilStates.values.firstWhereOrNull((e) => e == entity.State),
  );

  AddressEntity toEntity() => AddressEntity(
    Zip: ZipCode,
    Address: StreetName,
    Number: Number,
    Complement: Complement,
    Reference: Reference,
    District: District,
    City: City,
    State: State,
  );
}
