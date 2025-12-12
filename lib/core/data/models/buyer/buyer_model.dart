import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class BuyerModel extends Equatable {
  final int Code;
  final String PersonalizedCode;
  final String Name;
  final String NameReduced;
  final String CpfNumber;
  final String RgNumber;
  final bool Seller;
  final bool Buyer;

  const BuyerModel({
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

  factory BuyerModel.fromJson(Map json) => BuyerModel(
    Code: json['Code'],
    PersonalizedCode: json['PersonalizedCode'],
    Name: json['Name'],
    NameReduced: json['NameReduced'],
    CpfNumber: json['CpfNumber'],
    RgNumber: json['RgNumber'],
    Seller: json['Seller'],
    Buyer: json['Buyer'],
  );

  Map<String, dynamic> toJson() => {
    'Code': Code,
    'PersonalizedCode': PersonalizedCode,
    'Name': Name,
    'NameReduced': NameReduced,
    'CpfNumber': CpfNumber,
    'RgNumber': RgNumber,
    'Seller': Seller,
    'Buyer': Buyer,
  };

  factory BuyerModel.fromEntity(BuyerEntity entity) => BuyerModel(
    Code: entity.Code,
    PersonalizedCode: entity.PersonalizedCode,
    Name: entity.Name,
    NameReduced: entity.NameReduced,
    CpfNumber: entity.CpfNumber,
    RgNumber: entity.RgNumber,
    Seller: entity.Seller,
    Buyer: entity.Buyer,
  );

  BuyerEntity toEntity() => BuyerEntity(
    Code: Code,
    PersonalizedCode: PersonalizedCode,
    Name: Name,
    NameReduced: NameReduced,
    CpfNumber: CpfNumber,
    RgNumber: RgNumber,
    Seller: Seller,
    Buyer: Buyer,
  );
}
