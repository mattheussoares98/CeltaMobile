import 'package:equatable/equatable.dart';

class EcBuyMovementBuyerDtoEntity extends Equatable {
  final int? code;
  final String? personalizedCode;
  final bool? buyer;
  final bool? seller;
  final bool? pdvOperator;
  final DateTime? dateOfBirth;
  final String? cpfNumber;
  final String? rgNumber;
  final String? name;
  final String? nameReduced;

  const EcBuyMovementBuyerDtoEntity({
    required this.code,
    required this.personalizedCode,
    required this.buyer,
    required this.seller,
    required this.pdvOperator,
    required this.dateOfBirth,
    required this.cpfNumber,
    required this.rgNumber,
    required this.name,
    required this.nameReduced,
  });

  @override
  List<Object?> get props => [
    code,
    personalizedCode,
    buyer,
    seller,
    pdvOperator,
    dateOfBirth,
    cpfNumber,
    rgNumber,
    name,
    nameReduced,
  ];
}
