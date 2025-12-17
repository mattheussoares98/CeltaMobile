import 'package:equatable/equatable.dart';

class SupplierEntity extends Equatable {
  final int Code;
  final String Name;
  final String FantasizesName;
  final String CnpjCpfNumber;
  final String InscriptionRgNumber;
  final String SupplierType;
  final String SupplierRegimeType;
  final String Date;
  final List? Emails; //always return a null value
  final List? Telephones; //always return a null value
  final List? Addresses; //always return a null value

  const SupplierEntity({
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
  ];
}
