import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class SupplierModel extends Equatable {
  final int Code;
  final String Name;
  final String FantasizesName;
  final String CnpjCpfNumber;
  final String InscriptionRgNumber;
  final String SupplierType;
  final String SupplierRegimeType;
  final String Date;
  final List? Emails;
  final List? Telephones;
  final List? Addresses;

  const SupplierModel({
    required this.Code,
    required this.Name,
    required this.FantasizesName,
    required this.CnpjCpfNumber,
    required this.InscriptionRgNumber,
    required this.SupplierType,
    required this.SupplierRegimeType,
    required this.Date,
    required this.Emails,
    required this.Telephones,
    required this.Addresses,
  });

  Map<String, dynamic> toJson() => {
    "Code": Code,
    "Name": Name,
    "FantasizesName": FantasizesName,
    "CnpjCpfNumber": CnpjCpfNumber,
    "InscriptionRgNumber": InscriptionRgNumber,
    "SupplierType": SupplierType,
    "SupplierRegimeType": SupplierRegimeType,
    "Date": Date,
    "Emails": Emails,
    "Telephones": Telephones,
    "Addresses": Addresses,
  };

  factory SupplierModel.fromJson(Map json) => SupplierModel(
    Code: json["Code"],
    Name: json["Name"],
    FantasizesName: json["FantasizesName"],
    CnpjCpfNumber: json["CnpjCpfNumber"],
    InscriptionRgNumber: json["InscriptionRgNumber"],
    SupplierType: json["SupplierType"],
    SupplierRegimeType: json["SupplierRegimeType"],
    Date: json["Date"],
    Addresses: json["Addresses"],
    Emails: json["Emails"],
    Telephones: json["Telephones"],
  );

  factory SupplierModel.fromEntity(SupplierEntity entity) => SupplierModel(
    Code: entity.Code,
    Name: entity.Name,
    FantasizesName: entity.FantasizesName,
    CnpjCpfNumber: entity.CnpjCpfNumber,
    InscriptionRgNumber: entity.InscriptionRgNumber,
    SupplierType: entity.SupplierType,
    SupplierRegimeType: entity.SupplierRegimeType,
    Date: entity.Date,
    Addresses: entity.Addresses,
    Emails: entity.Emails,
    Telephones: entity.Telephones,
  );

  SupplierEntity toEntity() => SupplierEntity(
    Code: Code,
    Name: Name,
    FantasizesName: FantasizesName,
    CnpjCpfNumber: CnpjCpfNumber,
    InscriptionRgNumber: InscriptionRgNumber,
    SupplierType: SupplierType,
    SupplierRegimeType: SupplierRegimeType,
    Date: Date,
    Addresses: Addresses,
    Emails: Emails,
    Telephones: Telephones,
  );

  @override
  List<Object?> get props => [
    Code,
    Name,
    FantasizesName,
    CnpjCpfNumber,
    InscriptionRgNumber,
    SupplierType,
    SupplierRegimeType,
    Date,
    Emails,
    Telephones,
    Addresses,
  ];
}
