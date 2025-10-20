import 'package:equatable/equatable.dart';

class BuyerEntity extends Equatable {
  final int Code;
  final String PersonalizedCode;
  final String Name;
  final String NameReduced;
  final String CpfNumber;
  final String RgNumber;
  final bool Seller;
  final bool Buyer;

  const BuyerEntity({
    required this.Code,
    required this.PersonalizedCode,
    required this.Name,
    required this.NameReduced,
    required this.CpfNumber,
    required this.RgNumber,
    required this.Seller,
    required this.Buyer,
  });

  @override
  List<Object?> get props => [
    Code,
    PersonalizedCode,
    Name,
    NameReduced,
    CpfNumber,
    RgNumber,
    Seller,
    Buyer,
  ];
}
