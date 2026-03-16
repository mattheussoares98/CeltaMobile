import 'package:equatable/equatable.dart';

class EcSaleRequestProductProductModel extends Equatable {
  final int Id;
  final String Plu;
  final String Name;
  final String PackingAbbreviation;
  final double PackingQuantity;

  const EcSaleRequestProductProductModel({
    required this.Id,
    required this.Plu,
    required this.Name,
    required this.PackingAbbreviation,
    required this.PackingQuantity,
  });

  @override
  List<Object?> get props => [
    Id,
    Plu,
    Name,
    PackingAbbreviation,
    PackingQuantity,
  ];
}
