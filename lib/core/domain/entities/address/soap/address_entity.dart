import 'package:equatable/equatable.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';

class AddressEntity extends Equatable {
  final String Zip;
  final String Address;
  final String? Number;
  final String District;
  final String City;
  final BrazilStates? State;
  final String? Complement;
  final String? Reference;

  const AddressEntity({
    required this.Zip,
    required this.Address,
    required this.Number,
    required this.District,
    required this.City,
    required this.State,
    required this.Complement,
    required this.Reference,
  });

  @override
  List<Object?> get props => [
    Zip,
    Address,
    Number,
    District,
    City,
    State,
    Complement,
    Reference,
  ];
}
