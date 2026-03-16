import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

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
    ZipCode: json['ZipCode'],
    StreetName: json['StreetName'],
    Number: json['Number'],
    Complement: json['Complement'],
    Reference: json['Reference'],
    District: json['District'],
    City: json['City'],
    State: json['State'],
  );

  Map<String, dynamic> toJson() => {
    "ZipCode": ZipCode,
    "StreetName": StreetName,
    "Number": Number,
    "Complement": Complement,
    "Reference": Reference,
    "District": District,
    "City": City,
    "State": State,
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
