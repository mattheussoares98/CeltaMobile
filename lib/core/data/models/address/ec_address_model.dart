import 'package:equatable/equatable.dart';

class EcAddressModel extends Equatable {
  final String ZipCode;
  final String StreetName;
  final String Number;
  final String Complement;
  final String Reference;
  final String District;
  final String City;
  final String State;

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
}
